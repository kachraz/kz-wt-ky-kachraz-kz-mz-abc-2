#!/bin/bash

# =============================================
# CONFIGURATION - SET TO FALSE TO DISABLE FUNCTIONS
# =============================================

ENABLE_ANCHOR_CLEAN=true
ENABLE_ANCHOR_BUILD=true
ENABLE_ANCHOR_DEPLOY=true
ENABLE_ANCHOR_TEST=true

# =============================================
# WALLET CONFIGURATION
# =============================================

WALLET_DIR="$HOME/.config/solana"  # Default Solana wallet directory
WALLET_FILE="id.json"              # Default wallet file name

# =============================================
# NETWORK CONFIGURATION - SET TO DEVNET
# =============================================

DEFAULT_CLUSTER="devnet"
RPC_URL="https://api.devnet.solana.com"

# =============================================
# COLOR DEFINITIONS
# =============================================

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

BG_RED='\033[41m'
BG_GREEN='\033[42m'
BG_YELLOW='\033[43m'
BG_BLUE='\033[44m'
NC_BG='\033[49m'

# =============================================
# UTILITY FUNCTIONS
# =============================================

print_header() {
    echo -e "${BG_BLUE}${WHITE}=============================================${NC}${NC_BG}"
    echo -e "${BG_BLUE}${WHITE}           ANCHOR DEVNET DEPLOY MANAGER       ${NC}${NC_BG}"
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

get_balance() {
    solana balance --url $RPC_URL 2>/dev/null | awk '{print $1}' || echo "0"
}

show_balance() {
    local balance=$(get_balance)
    echo -e "${CYAN}Current balance: ${GREEN}$balance SOL${NC}"
    echo "$balance"
}

request_airdrop() {
    local amount=${1:-2}
    echo -e "${CYAN}Requesting airdrop of $amount SOL...${NC}"
    solana airdrop "$amount" --url $RPC_URL
    
    if [ $? -eq 0 ]; then
        print_status "Airdrop successful"
        show_balance
    else
        print_error "Airdrop failed"
        return 1
    fi
}

check_anchor_installed() {
    if ! command -v anchor &> /dev/null; then
        print_error "Anchor CLI is not installed. Please install it first." 
        print_info "Installation instructions: https://www.anchor-lang.com/docs/installation"
        print_info "Quick install: cargo install --git https://github.com/coral-xyz/anchor avm --force && avm install latest && avm use latest"
        exit 1
    fi
}

check_solana_installed() {
    if ! command -v solana &> /dev/null; then
        print_error "Solana CLI is not installed. Please install it first." 
        print_info "Installation instructions: https://solana.com/docs/intro/installation"
        print_info "Quick install: sh -c \"\$(curl -sSfL https://release.anza.xyz/stable/install)\""
        exit 1
    fi
}

check_wallet() {
    local wallet_path="$WALLET_DIR/$WALLET_FILE"
    
    if [ ! -f "$wallet_path" ]; then
        print_error "Wallet not found: $wallet_path"
        print_info "Available wallets in $WALLET_DIR:"
        ls -la "$WALLET_DIR"/*.json 2>/dev/null || echo "No wallet files found"
        return 1
    fi
    
    # Set the wallet
    solana config set --keypair "$wallet_path"
    solana config set --url $RPC_URL
    
    local pubkey=$(solana-keygen pubkey "$wallet_path")
    print_status "Using wallet: ${GREEN}$pubkey${NC}"
    print_status "Wallet file: ${BLUE}$wallet_path${NC}"
    
    return 0
}

ensure_min_balance() {
    local min_balance=${1:-1.5}
    local balance=$(get_balance)
    
    # Simple numeric comparison without bc
    if [ $(echo "$balance < $min_balance" | awk '{print ($1 < $3)}') -eq 1 ]; then
        print_warning "Low balance: $balance SOL (minimum recommended: $min_balance SOL)"
        echo -e -n "${CYAN}Request airdrop? (y/N): ${NC}"
        read confirm
        if [[ "$confirm" =~ ^[Yy]$ ]]; then
            request_airdrop 2
        fi
    else
        print_info "Balance sufficient: ${GREEN}$balance SOL${NC}"
    fi
}

# =============================================
# ANCHOR FUNCTIONS
# =============================================

anchor_clean() {
    if [ "$ENABLE_ANCHOR_CLEAN" = false ]; then
        print_warning "Anchor clean is disabled"
        return
    fi
    
    echo -e "${CYAN}Cleaning Anchor project...${NC}"
    
    # Show balance before
    local start_balance=$(show_balance)
    
    # Clean target directory
    if [ -d "target" ]; then
        print_info "Removing target directory"
        rm -rf target/
        print_status "Target directory removed"
    fi
    
    # Clean node_modules if exists
    if [ -d "node_modules" ]; then
        print_info "Removing node_modules directory"
        rm -rf node_modules/
        print_status "Node modules removed"
    fi
    
    # Clean any other build artifacts
    print_info "Cleaning cargo build artifacts"
    cargo clean
    
    if [ $? -eq 0 ]; then
        print_status "Project cleaned successfully"
    else
        print_error "Failed to clean project"
        return 1
    fi
    
    # Show balance after
    local end_balance=$(show_balance)
    echo -e "${CYAN}Balance change: ${GREEN}$start_balance${NC} → ${GREEN}$end_balance${NC} SOL${NC}"
}

anchor_build() {
    if [ "$ENABLE_ANCHOR_BUILD" = false ]; then
        print_warning "Anchor build is disabled"
        return
    fi
    
    echo -e "${CYAN}Building Anchor project...${NC}"
    
    # Show balance before
    local start_balance=$(show_balance)
    
    # Build the project
    print_info "Running anchor build"
    anchor build
    
    if [ $? -eq 0 ]; then
        print_status "Project built successfully"
        
        # Show program ID
        local program_id=$(grep -E '^declare_id!\("([^"]+)"\)' programs/*/src/lib.rs | head -1 | cut -d'"' -f2)
        if [ -n "$program_id" ]; then
            print_info "Program ID: ${GREEN}$program_id${NC}"
        fi
    else
        print_error "Build failed"
        return 1
    fi
    
    # Show balance after
    local end_balance=$(show_balance)
    echo -e "${CYAN}Balance change: ${GREEN}$start_balance${NC} → ${GREEN}$end_balance${NC} SOL${NC}"
}

anchor_deploy() {
    if [ "$ENABLE_ANCHOR_DEPLOY" = false ]; then
        print_warning "Anchor deploy is disabled"
        return
    fi
    
    echo -e "${CYAN}Deploying Anchor project to DevNet...${NC}"
    
    # Ensure minimum balance
    ensure_min_balance 1.5
    
    # Show balance before
    local start_balance=$(show_balance)
    
    # Deploy the project
    print_info "Running anchor deploy --provider.cluster devnet" 
    anchor deploy --provider.cluster devnet
    
    if [ $? -eq 0 ]; then
        print_status "Project deployed successfully to DevNet!"
        
        # Show deployment details
        local program_id=$(grep -E '^declare_id!\("([^"]+)"\)' programs/*/src/lib.rs | head -1 | cut -d'"' -f2)
        if [ -n "$program_id" ]; then
            print_info "Program deployed at: ${GREEN}$program_id${NC}"
            print_info "Explorer URL: https://explorer.solana.com/address/$program_id?cluster=devnet"
        fi
    else
        print_error "Deployment failed"
        
        # Check for common deployment issues 
        local deploy_output=$(anchor deploy --provider.cluster devnet 2>&1)
        
        if echo "$deploy_output" | grep -q "buffer"; then
            print_info "Buffer account issue detected. You may need to close hanging buffer accounts:"
            print_info "Run: solana program show --buffers --url $RPC_URL"
            print_info "Then: solana program close <BUFFER_ADDRESS> --url $RPC_URL" 
        fi
        
        if echo "$deploy_output" | grep -q "insufficient funds"; then
            print_info "Insufficient funds. Request more SOL with: solana airdrop 2 --url $RPC_URL" 
        fi
        
        return 1
    fi
    
    # Show balance after
    local end_balance=$(show_balance)
    local balance_change=$(awk "BEGIN {print $start_balance - $end_balance; exit}")
    echo -e "${CYAN}Balance change: ${GREEN}$start_balance${NC} → ${GREEN}$end_balance${NC} SOL (Cost: ${RED}$balance_change${NC} SOL)${NC}"
}

anchor_test() {
    if [ "$ENABLE_ANCHOR_TEST" = false ]; then
        print_warning "Anchor test is disabled"
        return
    fi
    
    echo -e "${CYAN}Testing Anchor project on DevNet...${NC}"
    
    # Show balance before
    local start_balance=$(show_balance)
    
    # Run tests
    print_info "Running anchor test --provider.cluster devnet"
    anchor test --provider.cluster devnet
    
    if [ $? -eq 0 ]; then
        print_status "Tests passed successfully on DevNet"
    else
        print_error "Tests failed on DevNet"
        return 1
    fi
    
    # Show balance after
    local end_balance=$(show_balance)
    local balance_change=$(awk "BEGIN {print $start_balance - $end_balance; exit}")
    echo -e "${CYAN}Balance change: ${GREEN}$start_balance${NC} → ${GREEN}$end_balance${NC} SOL (Cost: ${RED}$balance_change${NC} SOL)${NC}"
}

# =============================================
# MAIN MENU
# =============================================

show_menu() {
    echo
    echo -e "${CYAN}Select Anchor operations to run (DevNet):${NC}"
    echo
    
    if [ "$ENABLE_ANCHOR_CLEAN" = true ]; then
        echo -e "  ${GREEN}1${NC}) Clean project"
    fi
    
    if [ "$ENABLE_ANCHOR_BUILD" = true ]; then
        echo -e "  ${GREEN}2${NC}) Build project"
    fi
    
    if [ "$ENABLE_ANCHOR_DEPLOY" = true ]; then
        echo -e "  ${GREEN}3${NC}) Deploy to DevNet"
    fi
    
    if [ "$ENABLE_ANCHOR_TEST" = true ]; then
        echo -e "  ${GREEN}4${NC}) Test on DevNet"
    fi
    
    echo -e "  ${GREEN}5${NC}) Run all operations"
    echo -e "  ${GREEN}6${NC}) Request airdrop"
    echo -e "  ${GREEN}7${NC}) Check balance"
    echo -e "  ${GREEN}8${NC}) Change wallet directory"
    echo -e "  ${GREEN}0${NC}) Exit"
    echo
    echo -e -n "${CYAN}Your choice (comma-separated for multiple, e.g., 1,2,3): ${NC}"
}

# =============================================
# SCRIPT INITIALIZATION
# =============================================

# Initialize
check_anchor_installed
check_solana_installed

# Clear screen and print header
clear
print_header

# Check and set wallet
if ! check_wallet; then
    echo -e -n "${CYAN}Enter full path to your wallet file: ${NC}"
    read custom_wallet
    if [ -f "$custom_wallet" ]; then
        WALLET_DIR=$(dirname "$custom_wallet")
        WALLET_FILE=$(basename "$custom_wallet")
        check_wallet
    else
        print_error "Wallet file not found: $custom_wallet"
        exit 1
    fi
fi

# Show initial balance
show_balance

# =============================================
# MAIN EXECUTION
# =============================================

show_menu
read choices

# Convert comma-separated choices to array
IFS=',' read -ra choices_array <<< "$choices"

# Check if we should exit
for choice in "${choices_array[@]}"; do
    if [ "$choice" = "0" ]; then
        print_status "Goodbye!"
        exit 0
    fi
done

# Run selected operations
for choice in "${choices_array[@]}"; do
    case $choice in
        1)
            anchor_clean
            ;;
        2)
            anchor_build
            ;;
        3)
            anchor_deploy
            ;;
        4)
            anchor_test
            ;;
        5)
            # Run all operations in sequence
            if [ "$ENABLE_ANCHOR_CLEAN" = true ]; then
                anchor_clean
                echo
            fi
            
            if [ "$ENABLE_ANCHOR_BUILD" = true ]; then
                anchor_build
                echo
            fi
            
            if [ "$ENABLE_ANCHOR_DEPLOY" = true ]; then
                anchor_deploy
                echo
            fi
            
            if [ "$ENABLE_ANCHOR_TEST" = true ]; then
                anchor_test
                echo
            fi
            ;;
        6)
            request_airdrop 2
            ;;
        7)
            show_balance
            ;;
        8)
            echo -e -n "${CYAN}Enter new wallet directory: ${NC}"
            read new_dir
            if [ -d "$new_dir" ]; then
                WALLET_DIR="$new_dir"
                echo -e -n "${CYAN}Enter wallet file name: ${NC}"
                read new_file
                if [ -f "$WALLET_DIR/$new_file" ]; then
                    WALLET_FILE="$new_file"
                    check_wallet
                else
                    print_error "Wallet file not found: $WALLET_DIR/$new_file"
                fi
            else
                print_error "Directory not found: $new_dir"
            fi
            ;;
        *)
            print_error "Invalid option: $choice"
            ;;
    esac
    
    # Add spacing between operations
    echo
done

print_info "Operations completed"
print_info "Final balance: $(get_balance) SOL"
print_info "Explorer: https://explorer.solana.com/?cluster=devnet"

# Show final status
echo -e "${GREEN}=============================================${NC}"
echo -e "${GREEN}DevNet deployment script execution finished${NC}"
echo -e "${GREEN}=============================================${NC}"