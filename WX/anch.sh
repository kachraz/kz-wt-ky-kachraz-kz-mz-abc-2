#!/bin/bash

# =============================================
# CONFIGURATION - SET TO FALSE TO DISABLE FUNCTIONS
# =============================================

ENABLE_ANCHOR_CLEAN=true
ENABLE_ANCHOR_BUILD=true
ENABLE_ANCHOR_DEPLOY=true
ENABLE_ANCHOR_TEST=true

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
    echo -e "${BG_BLUE}${WHITE}           ANCHOR PROJECT MANAGER            ${NC}${NC_BG}"
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

# =============================================
# ANCHOR FUNCTIONS
# =============================================

anchor_clean() {
    if [ "$ENABLE_ANCHOR_CLEAN" = false ]; then
        print_warning "Anchor clean is disabled"
        return
    fi
    
    echo -e "${CYAN}Cleaning Anchor project...${NC}"
    
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
}

anchor_build() {
    if [ "$ENABLE_ANCHOR_BUILD" = false ]; then
        print_warning "Anchor build is disabled"
        return
    fi
    
    echo -e "${CYAN}Building Anchor project...${NC}"
    
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
}

anchor_deploy() {
    if [ "$ENABLE_ANCHOR_DEPLOY" = false ]; then
        print_warning "Anchor deploy is disabled"
        return
    fi
    
    echo -e "${CYAN}Deploying Anchor project...${NC}"
    
    # Check if we're on the right network
    local current_cluster=$(solana config get | grep "RPC URL" | awk '{print $3}')
    if [[ ! "$current_cluster" =~ (devnet|testnet|localhost) ]]; then
        print_warning "You are deploying to ${RED}$current_cluster${NC}"
        echo -e -n "${CYAN}Are you sure you want to deploy here? (y/N): ${NC}"
        read confirm
        if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
            print_info "Deployment cancelled"
            return
        fi
    fi
    
    # Check balance
    local balance=$(solana balance | awk '{print $1}')
    print_info "Current balance: ${GREEN}$balance SOL${NC}"
    
    if (( $(echo "$balance < 1.0" | bc -l) )); then
        print_warning "Low balance. You might need to request an airdrop"
        if [[ "$current_cluster" =~ (devnet|testnet|localhost) ]]; then
            echo -e -n "${CYAN}Request airdrop? (y/N): ${NC}"
            read confirm
            if [[ "$confirm" =~ ^[Yy]$ ]]; then
                solana airdrop 2
            fi
        fi
    fi
    
    # Deploy the project
    print_info "Running anchor deploy"
    anchor deploy
    
    if [ $? -eq 0 ]; then
        print_status "Project deployed successfully"
    else
        print_error "Deployment failed"
        
        # Check if it's a buffer account issue
        if grep -q "buffer" <<< "$(anchor deploy 2>&1)"; then
            print_info "You may need to close hanging buffer accounts:"
            print_info "Run: solana program show --buffers"
            print_info "Then: solana program close <BUFFER_ADDRESS>"
        fi
        
        return 1
    fi
}

anchor_test() {
    if [ "$ENABLE_ANCHOR_TEST" = false ]; then
        print_warning "Anchor test is disabled"
        return
    fi
    
    echo -e "${CYAN}Testing Anchor project...${NC}"
    
    # Check if we need to start a local validator
    local current_cluster=$(solana config get | grep "RPC URL" | awk '{print $3}')
    if [[ "$current_cluster" =~ (localhost|127.0.0.1) ]]; then
        print_info "Local cluster detected. Checking if validator is running..."
        if ! solana ping >/dev/null 2>&1; then
            print_warning "Local validator not running. Tests may fail."
            print_info "Start validator with: solana-test-validator"
        fi
    fi
    
    # Run tests
    print_info "Running anchor test"
    anchor test
    
    if [ $? -eq 0 ]; then
        print_status "Tests passed successfully"
    else
        print_error "Tests failed"
        return 1
    fi
}

# =============================================
# MAIN MENU
# =============================================

show_menu() {
    echo
    echo -e "${CYAN}Select Anchor operations to run:${NC}"
    echo
    
    if [ "$ENABLE_ANCHOR_CLEAN" = true ]; then
        echo -e "  ${GREEN}1${NC}) Clean project"
    fi
    
    if [ "$ENABLE_ANCHOR_BUILD" = true ]; then
        echo -e "  ${GREEN}2${NC}) Build project"
    fi
    
    if [ "$ENABLE_ANCHOR_DEPLOY" = true ]; then
        echo -e "  ${GREEN}3${NC}) Deploy project"
    fi
    
    if [ "$ENABLE_ANCHOR_TEST" = true ]; then
        echo -e "  ${GREEN}4${NC}) Run tests"
    fi
    
    echo -e "  ${GREEN}5${NC}) Run all operations"
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
        *)
            print_error "Invalid option: $choice"
            ;;
    esac
    
    # Add spacing between operations
    echo
done

print_info "Operations completed"
print_info "For more Anchor CLI details, see: https://www.anchor-lang.com/docs/references/cli"

# Show final status
echo -e "${GREEN}=============================================${NC}"
echo -e "${GREEN}Script execution finished${NC}"
echo -e "${GREEN}=============================================${NC}"