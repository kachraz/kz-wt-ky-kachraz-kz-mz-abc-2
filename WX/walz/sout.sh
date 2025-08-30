#!/bin/bash

# =============================================
# CONFIGURATION - COMMENT OUT FUNCTIONS YOU DON'T WANT
# =============================================

# Set to false to disable functions
# ENABLE_CREATE_WALLET=true
ENABLE_CHECK_BALANCE=true
# ENABLE_TRANSFER_FUNDS=true

# =============================================
# COLOR DEFINITIONS
# =============================================

# Text colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# Background colors
BG_RED='\033[41m'
BG_GREEN='\033[42m'
BG_YELLOW='\033[43m'
BG_BLUE='\033[44m'
NC_BG='\033[49m' # No Background

# =============================================
# NETWORK CONFIGURATION
# =============================================

NETWORK="devnet"
RPC_URL="https://api.devnet.solana.com"

# =============================================
# FILE PATHS
# =============================================

WALLET_DIR="./s1"
BALANCE_FILE="./balances.txt"
LOG_FILE="./solana_operations.log"

# =============================================
# DEFAULT AMOUNTS
# =============================================

DEFAULT_AIRDROP_AMOUNT=1
DEFAULT_TRANSFER_AMOUNT=0.1

# =============================================
# UTILITY FUNCTIONS
# =============================================

print_header() {
    echo -e "${BG_BLUE}${WHITE}=============================================${NC}${NC_BG}"
    echo -e "${BG_BLUE}${WHITE}            SOLANA DEVNET MANAGER            ${NC}${NC_BG}"
    echo -e "${BG_BLUE}${WHITE}=============================================${NC}${NC_BG}"
    echo
}

print_status() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

log_message() {
    local message="$1"
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $message" >> "$LOG_FILE"
}

check_solana_installed() {
    if ! command -v solana &> /dev/null; then
        print_error "Solana CLI is not installed. Please install it first."
        exit 1
    fi
}

create_wallet_directory() {
    if [ ! -d "$WALLET_DIR" ]; then
        mkdir -p "$WALLET_DIR"
        print_status "Created wallet directory: $WALLET_DIR"
    fi
}

select_wallet_file() {
    local wallet_files=("$WALLET_DIR"/*.json)
    
    if [ ${#wallet_files[@]} -eq 0 ]; then
        print_error "No wallets found in $WALLET_DIR"
        return 1
    fi
    
    echo -e "${CYAN}Available wallets:${NC}"
    for i in "${!wallet_files[@]}"; do
        local pubkey=$(solana-keygen pubkey "${wallet_files[$i]}" 2>/dev/null || echo "Unknown")
        echo -e "  ${GREEN}$(($i+1))${NC}) ${YELLOW}$(basename "${wallet_files[$i]}")${NC} -> ${BLUE}$pubkey${NC}"
    done
    
    echo -e -n "${CYAN}Select a wallet (1-${#wallet_files[@]}): ${NC}"
    read selection
    
    if [[ $selection =~ ^[0-9]+$ ]] && [ "$selection" -ge 1 ] && [ "$selection" -le ${#wallet_files[@]} ]; then
        SELECTED_WALLET="${wallet_files[$(($selection-1))]}"
        return 0
    else
        print_error "Invalid selection"
        return 1
    fi
}

# =============================================
# WALLET FUNCTIONS
# =============================================

create_wallet() {
    if [ "$ENABLE_CREATE_WALLET" = false ]; then
        print_warning "Wallet creation is disabled"
        return
    fi
    
    echo -e "${CYAN}Creating a new wallet...${NC}"
    echo -e -n "${CYAN}Enter wallet name (leave blank for auto-generated): ${NC}"
    read wallet_name
    
    if [ -z "$wallet_name" ]; then
        wallet_name="wallet_$(date +%s)"
    fi
    
    local wallet_path="$WALLET_DIR/$wallet_name"
    
    # Create wallet
    solana-keygen new --outfile "$wallet_path.json" --force --no-passphrase > /dev/null 2>&1
    
    if [ $? -eq 0 ]; then
        local pubkey=$(solana-keygen pubkey "$wallet_path.json")
        print_status "Wallet created successfully!"
        echo -e "  ${YELLOW}Public key:${NC} ${GREEN}$pubkey${NC}"
        echo -e "  ${YELLOW}Keypair file:${NC} ${BLUE}$wallet_path.json${NC}"
        
        # Request airdrop
        echo
        print_info "Requesting airdrop on $NETWORK..."
        solana airdrop $DEFAULT_AIRDROP_AMOUNT "$pubkey" --url $RPC_URL
        
        if [ $? -eq 0 ]; then
            print_status "Airdrop successful!"
        else
            print_warning "Airdrop failed. You can request manually later."
        fi
        
        log_message "Created wallet: $wallet_name with pubkey: $pubkey"
    else
        print_error "Failed to create wallet"
        log_message "Failed to create wallet: $wallet_name"
    fi
}

check_balance() {
    if [ "$ENABLE_CHECK_BALANCE" = false ]; then
        print_warning "Balance checking is disabled"
        return
    fi
    
    echo -e "${CYAN}Checking wallet balance...${NC}"
    
    if ! select_wallet_file; then
        return
    fi
    
    local wallet_path="$SELECTED_WALLET"
    local pubkey=$(solana-keygen pubkey "$wallet_path")
    
    print_info "Checking balance for: $pubkey"
    
    # Get balance
    local balance=$(solana balance "$pubkey" --url $RPC_URL 2>/dev/null)
    
    if [ $? -eq 0 ]; then
        print_status "Balance: $balance"
        
        # Write to balance file
        echo "$(date '+%Y-%m-%d %H:%M:%S') - $pubkey - $balance" >> "$BALANCE_FILE"
        print_info "Balance written to: $BALANCE_FILE"
        
        log_message "Checked balance for $pubkey: $balance"
    else
        print_error "Failed to check balance"
        log_message "Failed to check balance for: $pubkey"
    fi
}

transfer_funds() {
    if [ "$ENABLE_TRANSFER_FUNDS" = false ]; then
        print_warning "Fund transfers are disabled"
        return
    fi
    
    echo -e "${CYAN}Transferring funds between wallets...${NC}"
    
    # Select sender wallet
    echo -e "${YELLOW}Select SENDER wallet:${NC}"
    if ! select_wallet_file; then
        return
    fi
    local from_wallet="$SELECTED_WALLET"
    local from_pubkey=$(solana-keygen pubkey "$from_wallet")
    
    # Get recipient address
    echo -e -n "${CYAN}Enter RECIPIENT address: ${NC}"
    read to_address
    
    if [ -z "$to_address" ]; then
        print_error "Recipient address is required"
        return
    fi
    
    # Get amount
    echo -e -n "${CYAN}Enter amount to transfer (default: $DEFAULT_TRANSFER_AMOUNT): ${NC}"
    read amount
    amount=${amount:-$DEFAULT_TRANSFER_AMOUNT}
    
    # Confirm transaction
    echo
    echo -e "${YELLOW}Transaction details:${NC}"
    echo -e "  ${YELLOW}From:${NC}    ${RED}$from_pubkey${NC}"
    echo -e "  ${YELLOW}To:${NC}      ${GREEN}$to_address${NC}"
    echo -e "  ${YELLOW}Amount:${NC}  ${BLUE}$amount SOL${NC}"
    echo
    echo -e -n "${CYAN}Confirm transfer? (y/N): ${NC}"
    read confirm
    
    if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
        print_info "Transfer cancelled"
        return
    fi
    
    # Perform transfer
    print_info "Processing transfer..."
    solana transfer --from "$from_wallet" "$to_address" "$amount" \
        --url $RPC_URL \
        --fee-payer "$from_wallet" \
        --allow-unfunded-recipient
    
    if [ $? -eq 0 ]; then
        print_status "Transfer successful!"
        log_message "Transferred $amount SOL from $from_pubkey to $to_address"
    else
        print_error "Transfer failed"
        log_message "Failed to transfer $amount SOL from $from_pubkey to $to_address"
    fi
}

# =============================================
# MAIN MENU
# =============================================

show_menu() {
    echo
    echo -e "${CYAN}Please select an option:${NC}"
    echo
    
    if [ "$ENABLE_CREATE_WALLET" = true ]; then
        echo -e "  ${GREEN}1${NC}) Create new wallet"
    fi
    
    if [ "$ENABLE_CHECK_BALANCE" = true ]; then
        echo -e "  ${GREEN}2${NC}) Check wallet balance"
    fi
    
    if [ "$ENABLE_TRANSFER_FUNDS" = true ]; then
        echo -e "  ${GREEN}3${NC}) Transfer funds"
    fi
    
    echo -e "  ${GREEN}0${NC}) Exit"
    echo
    echo -e -n "${CYAN}Your choice: ${NC}"
}

# =============================================
# SCRIPT INITIALIZATION
# =============================================

# Initialize
check_solana_installed
create_wallet_directory

# Clear screen and print header
clear
print_header

# =============================================
# MAIN LOOP
# =============================================

while true; do
    show_menu
    read choice
    
    case $choice in
        1)
            if [ "$ENABLE_CREATE_WALLET" = true ]; then
                create_wallet
            else
                print_warning "This option is disabled"
            fi
            ;;
        2)
            if [ "$ENABLE_CHECK_BALANCE" = true ]; then
                check_balance
            else
                print_warning "This option is disabled"
            fi
            ;;
        3)
            if [ "$ENABLE_TRANSFER_FUNDS" = true ]; then
                transfer_funds
            else
                print_warning "This option is disabled"
            fi
            ;;
        0)
            print_status "Goodbye!"
            exit 0
            ;;
        *)
            print_error "Invalid option"
            ;;
    esac
    
    echo
    echo -e -n "${CYAN}Press Enter to continue...${NC}"
    read -r
    clear
    print_header
done