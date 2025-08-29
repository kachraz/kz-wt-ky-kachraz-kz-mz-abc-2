#!/usr/bin/bash
# This bash srcript is for installing the KL docker image here
clear

# Colors
export RED='\033[0;31m'
export GREEN='\033[0;32m'
export YELLOW='\033[0;33m'
export BLUE='\033[0;34m'
export PURPLE='\033[0;35m'
export CYAN='\033[0;36m'
export WHITE='\033[0;37m'
export NC='\033[0m' # No Color

# Commands

hea1() {
    echo -e "${CYAN}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
    echo -e "${PURPLE}$1${NC}"
    echo -e "${CYAN}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
}

foset() {
    hea1 "Setup a foundry project, setup uv venv and install slither"
    # Get name of Project
    echo -e "Enter the name of the project: "
    read name_of_project
    if [ -z "$name_of_project" ]; then
        echo -e "${RED}BASTARD ! Project name cannot be empty${NC}"
        exit 1
    fi

    # Commands to execute
    CO1="forge init --no-commit --no-git --force --vscode $name_of_project && cd $name_of_project "
    CO2="uv venv && source venv/bin/activate.fish"
    CO3="uv pip install slither-analyzer"
    CO4="solc-select install 0.8.13 && solc-select use 0.8.13"

    # Execution Commands
    eval "$CO1"
    eval "$CO2"
    eval "$CO3"
    eval "$CO4"

    echo -e "${GREEN}Now run ${CO4}${NC}"
}

fo_only() {
    hea1 "Setup a foundry project, setup uv venv and install slither"
    # Get name of Project
    echo -e "Enter the name of the project: "
    read name_of_project
    if [ -z "$name_of_project" ]; then
        echo -e "${RED}BASTARD ! Project name cannot be empty${NC}"
        exit 1
    fi

    # Commands to execute
    CO1="forge init --no-commit --no-git --force --vscode $name_of_project && cd $name_of_project "

    # Execution Commands
    eval "$CO1"

    echo -e "${GREEN}Foundry Only Install ${CO4}${NC}"
}

######### Foundry Executions ############

# Declare the rpc and key arrays
rpcz=(
    "https://eth-sepolia.g.alchemy.com/v2/y-cD2hUWMXwa6cAWy7uplLSSoRQ5v7Fx"
    "https://eth-holesky.g.alchemy.com/v2/y-cD2hUWMXwa6cAWy7uplLSSoRQ5v7Fx"
)
keyz=(
    "0x6890220d6cc0218032cab963a528672d85643a2c7edf340de6e27861d1900958"
    "0xff630bf91f95d3e7af70c12490b858cd5e0818b2bc6af6fccff9d933a1097bc4"

)
accz=(
    "0x420A8Fe13265Df3B9323C3D7681b2854B1309338"
    "0x420fFfdA7565D31e9b4b7ebAF0269b5564644656"

)
ETHERSCAN_API_KEY="2JEANQYC4C9S6PKDFWNGVT2UER24T32D2M"

# Testing
fo_test() {
    hea1 "Foundry Run"
    CO1="forge test"
    eval "$CO1"
}

###############################################
# Forge Create
################################################
CONTRACT_PATH_CREATE="src/SimpleStorage.sol:SimpleStorage"

fo_create_holeksy() {
    hea1 "Foundry Create - One of contract deployment"

    LOG_FILE="logs/deploy_create_holesky.log"
    mkdir -p logs

    echo -e "██╗  ██╗  ██████╗  ██╗      ███████╗ ███████╗ ██╗  ██╗ ██╗   ██╗"
    echo -e "██║  ██║ ██╔═══██╗ ██║      ██╔════╝ ██╔════╝ ██║ ██╔╝ ╚██╗ ██╔╝"
    echo -e "███████║ ██║   ██║ ██║      █████╗   ███████╗ █████╔╝   ╚████╔╝ "
    echo -e "██╔══██║ ██║   ██║ ██║      ██╔══╝   ╚════██║ ██╔═██╗    ╚██╔╝  "
    echo -e "██║  ██║ ╚██████╔╝ ███████╗ ███████╗ ███████║ ██║  ██╗    ██║   "
    echo -e "╚═╝  ╚═╝  ╚═════╝  ╚══════╝ ╚══════╝ ╚══════╝ ╚═╝  ╚═╝    ╚═╝   "

    CO1="forge create ${CONTRACT_PATH_CREATE} \
        --rpc-url ${rpcz[1]} \
        --private-key ${keyz[0]} \
        --etherscan-api-key ${ETHERSCAN_API_KEY} \
        --optimize true \
        --optimizer-runs 999\
        --build-info --build-info-path outz/ \
        --verify --broadcast \
        --out outz/"

    echo -e "${BLUE}Running: $CO1${NC}"

    # Run and log to file
    eval "$CO1" 2>&1 | tee "$LOG_FILE"

    echo -e "${GREEN}Successfully deployed contract${NC}"
    echo -e "${YELLOW}Log saved to $LOG_FILE${NC}"
}

fo_create_sepolia() {
    hea1 "Foundry Create - One of contract deployment"

    LOG_FILE="logs/deploy_create_sepolia.log"
    mkdir -p logs

    echo -e "███████╗ ███████╗ ██████╗   ██████╗  ██╗      ██╗  █████╗ "
    echo -e "██╔════╝ ██╔════╝ ██╔══██╗ ██╔═══██╗ ██║      ██║ ██╔══██╗"
    echo -e "███████╗ █████╗   ██████╔╝ ██║   ██║ ██║      ██║ ███████║"
    echo -e "╚════██║ ██╔══╝   ██╔═══╝  ██║   ██║ ██║      ██║ ██╔══██║"
    echo -e "███████║ ███████╗ ██║      ╚██████╔╝ ███████╗ ██║ ██║  ██║"
    echo -e "╚══════╝ ╚══════╝ ╚═╝       ╚═════╝  ╚══════╝ ╚═╝ ╚═╝  ╚═╝"

    CO1="forge create ${CONTRACT_PATH_CREATE} \
        --rpc-url ${rpcz[0]} \
        --private-key ${keyz[0]} \
        --optimize true \
        --optimizer-runs 999\
        --build-info --build-info-path outz/ \
        --etherscan-api-key ${ETHERSCAN_API_KEY} \
        --verify --broadcast \
        --out outz/"

    echo -e "${BLUE}Running: $CO1${NC}"

    # Run and log to file
    eval "$CO1" 2>&1 | tee "$LOG_FILE"

    echo -e "${GREEN}Successfully deployed contract${NC}"
    echo -e "${YELLOW}Log saved to $LOG_FILE${NC}"
}

fo_create_anvil() {
    hea1 "Foundry Create - One of contract deployment"

    LOG_FILE="logs/deploy_create_avil.log"
    mkdir -p logs

    echo -e " █████╗  ███╗   ██╗ ██╗   ██╗ ██╗ ██╗     "
    echo -e "██╔══██╗ ████╗  ██║ ██║   ██║ ██║ ██║     "
    echo -e "███████║ ██╔██╗ ██║ ██║   ██║ ██║ ██║     "
    echo -e "██╔══██║ ██║╚██╗██║ ╚██╗ ██╔╝ ██║ ██║     "
    echo -e "██║  ██║ ██║ ╚████║  ╚████╔╝  ██║ ███████╗"
    echo -e "╚═╝  ╚═╝ ╚═╝  ╚═══╝   ╚═══╝   ╚═╝ ╚══════╝"

    ANVIL_RPC="127.0.0.1:8545"
    ANVIL_KEY="0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80"

    CO1="forge create ${CONTRACT_PATH_CREATE} \
        --rpc-url  ${ANVIL_RPC}\
        --private-key ${ANVIL_KEY} \
        --broadcast \
        --out outz/"

    echo -e "${BLUE}Running: $CO1${NC}"

    # Run and log to file
    eval "$CO1" 2>&1 | tee "$LOG_FILE"

    echo -e "${GREEN}Successfully deployed contract${NC}"
    echo -e "${YELLOW}Log saved to $LOG_FILE${NC}"
}

fo_create_anvil_nochain() {
    hea1 "Foundry Create - One of contract deployment"

    LOG_FILE="logs/deploy_create_avil.log"
    mkdir -p logs

    echo -e " █████╗  ███╗   ██╗ ██╗   ██╗ ██╗ ██╗     "
    echo -e "██╔══██╗ ████╗  ██║ ██║   ██║ ██║ ██║     "
    echo -e "███████║ ██╔██╗ ██║ ██║   ██║ ██║ ██║     "
    echo -e "██╔══██║ ██║╚██╗██║ ╚██╗ ██╔╝ ██║ ██║     "
    echo -e "██║  ██║ ██║ ╚████║  ╚████╔╝  ██║ ███████╗"
    echo -e "╚═╝  ╚═╝ ╚═╝  ╚═══╝   ╚═══╝   ╚═╝ ╚══════╝"

    CO1="forge create ${CONTRACT_PATH_CREATE} \
        --out outz/"

    echo -e "${BLUE}Running: $CO1${NC}"

    # Run and log to file
    eval "$CO1" 2>&1 | tee "$LOG_FILE"

    echo -e "${GREEN}Successfully deployed contract${NC}"
    echo -e "${YELLOW}Log saved to $LOG_FILE${NC}"
}

###############################################
# Forge Script
################################################

# Common Variables
CONTRACT_PATH_SCRIPT="script/DeploySimpleStorage.s.sol:DeploySimpleStorage"

fo_script_holeksy() {
    hea1 "Foundry Script - One of contract deployment"

    LOG_FILE="logs/deploy_script._holesky.log"

    mkdir -p logs

    echo -e "██╗  ██╗  ██████╗  ██╗      ███████╗ ███████╗ ██╗  ██╗ ██╗   ██╗"
    echo -e "██║  ██║ ██╔═══██╗ ██║      ██╔════╝ ██╔════╝ ██║ ██╔╝ ╚██╗ ██╔╝"
    echo -e "███████║ ██║   ██║ ██║      █████╗   ███████╗ █████╔╝   ╚████╔╝ "
    echo -e "██╔══██║ ██║   ██║ ██║      ██╔══╝   ╚════██║ ██╔═██╗    ╚██╔╝  "
    echo -e "██║  ██║ ╚██████╔╝ ███████╗ ███████╗ ███████║ ██║  ██╗    ██║   "
    echo -e "╚═╝  ╚═╝  ╚═════╝  ╚══════╝ ╚══════╝ ╚══════╝ ╚═╝  ╚═╝    ╚═╝   "

    CO1="forge script ${CONTRACT_PATH_SCRIPT} \
        --rpc-url ${rpcz[1]} \
        --private-key ${keyz[0]} \
        --optimize true \
        --optimizer-runs 999\
        --build-info --build-info-path outz/ \
        --etherscan-api-key ${ETHERSCAN_API_KEY} \
        --verify \
        --broadcast \
        --out outz/"

    echo -e "${BLUE}Running: $CO1${NC}"

    # Run and log to file
    eval "$CO1" 2>&1 | tee "$LOG_FILE"

    echo -e "${GREEN}Successfully deployed contract${NC}"
    echo -e "${YELLOW}Log saved to $LOG_FILE${NC}"
}

fo_script_sepolia() {
    hea1 "Foundry Script - One of contract deployment"

    LOG_FILE="logs/deploy_script_sepolia.log"
    mkdir -p logs

    echo -e "███████╗ ███████╗ ██████╗   ██████╗  ██╗      ██╗  █████╗ "
    echo -e "██╔════╝ ██╔════╝ ██╔══██╗ ██╔═══██╗ ██║      ██║ ██╔══██╗"
    echo -e "███████╗ █████╗   ██████╔╝ ██║   ██║ ██║      ██║ ███████║"
    echo -e "╚════██║ ██╔══╝   ██╔═══╝  ██║   ██║ ██║      ██║ ██╔══██║"
    echo -e "███████║ ███████╗ ██║      ╚██████╔╝ ███████╗ ██║ ██║  ██║"
    echo -e "╚══════╝ ╚══════╝ ╚═╝       ╚═════╝  ╚══════╝ ╚═╝ ╚═╝  ╚═╝"

    CO1="forge script ${CONTRACT_PATH_SCRIPT} \
        --rpc-url ${rpcz[0]} \
        --private-key ${keyz[0]} \
        --optimize true \
        --optimizer-runs 999\
        --build-info --build-info-path outz/ \
        --etherscan-api-key ${ETHERSCAN_API_KEY} \
        --verify \
        --broadcast \
        --out outz/"

    echo -e "${BLUE}Running: $CO1${NC}"

    # Run and log to file
    eval "$CO1" 2>&1 | tee "$LOG_FILE"

    echo -e "${GREEN}Successfully deployed contract${NC}"
    echo -e "${YELLOW}Log saved to $LOG_FILE${NC}"
}

fo_script_anvil() {
    hea1 "Foundry Script - One of contract deployment"
    LOG_FILE="logs/deploy_create_avil.log"
    mkdir -p logs

    echo -e " █████╗  ███╗   ██╗ ██╗   ██╗ ██╗ ██╗     "
    echo -e "██╔══██╗ ████╗  ██║ ██║   ██║ ██║ ██║     "
    echo -e "███████║ ██╔██╗ ██║ ██║   ██║ ██║ ██║     "
    echo -e "██╔══██║ ██║╚██╗██║ ╚██╗ ██╔╝ ██║ ██║     "
    echo -e "██║  ██║ ██║ ╚████║  ╚████╔╝  ██║ ███████╗"
    echo -e "╚═╝  ╚═╝ ╚═╝  ╚═══╝   ╚═══╝   ╚═╝ ╚══════╝"

    ANVIL_RPC="127.0.0.1:8545"
    ANVIL_KEY="0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80"

    CO1="forge script ${CONTRACT_PATH_SCRIPT} \
        --rpc-url ${ANVIL_RPC} \
        --private-key ${ANVIL_KEY} \
        --broadcast \
        --out outz/"

    echo -e "${BLUE}Running: $CO1${NC}"

    # Run and log to file
    eval "$CO1" 2>&1 | tee "$LOG_FILE"

    echo -e "${GREEN}Successfully deployed contract${NC}"
    echo -e "${YELLOW}Log saved to $LOG_FILE${NC}"
}

fo_script_anvil_nochain() {
    hea1 "Foundry Script - One of contract deployment"
    LOG_FILE="logs/deploy_create_avil.log"
    mkdir -p logs

    echo -e " █████╗  ███╗   ██╗ ██╗   ██╗ ██╗ ██╗     "
    echo -e "██╔══██╗ ████╗  ██║ ██║   ██║ ██║ ██║     "
    echo -e "███████║ ██╔██╗ ██║ ██║   ██║ ██║ ██║     "
    echo -e "██╔══██║ ██║╚██╗██║ ╚██╗ ██╔╝ ██║ ██║     "
    echo -e "██║  ██║ ██║ ╚████║  ╚████╔╝  ██║ ███████╗"
    echo -e "╚═╝  ╚═╝ ╚═╝  ╚═══╝   ╚═══╝   ╚═╝ ╚══════╝"

    CO1="forge script ${CONTRACT_PATH_SCRIPT} \
        --out outz/"

    echo -e "${BLUE}Running: $CO1${NC}"

    # Run and log to file
    eval "$CO1" 2>&1 | tee "$LOG_FILE"

    echo -e "${GREEN}Successfully deployed contract${NC}"
    echo -e "${YELLOW}Log saved to $LOG_FILE${NC}"
}

###############################################
# Manual
################################################

main_menu() {
    echo -e "${CYAN}┌──────────────────────────────────────────┐${NC}"
    echo -e "${CYAN}│${NC}       ${PURPLE}🔥 Foundry Launcher Menu 🔥 ${CYAN}${NC}"
    echo -e "${CYAN}├──────────────────────────────────────────┤${NC}"
    echo -e "${CYAN}│${NC}  ${GREEN}1)${NC} ${WHITE}Full Foundry + Slither Setup ${CYAN}${NC}"
    echo -e "${CYAN}│${NC}  ${GREEN}2)${NC} ${WHITE}Foundry Only Setup {CYAN}${NC}"
    echo -e "${CYAN}│${NC}  ${GREEN}3)${NC} ${WHITE}Run Forge Tests                                 ${CYAN}${NC}"
    echo -e "${CYAN}│${NC}  ${GREEN}4)${NC} ${WHITE}Create Contract on ${BLUE}Holesky${WHITE}       ${CYAN}${NC}"
    echo -e "${CYAN}│${NC}  ${GREEN}5)${NC} ${WHITE}Create Contract on ${BLUE}Sepolia${WHITE}       ${CYAN}${NC}"
    echo -e "${CYAN}│${NC}  ${GREEN}6)${NC} ${WHITE}Create Contract on ${BLUE}Anvil${WHITE}       ${CYAN}${NC}"
    echo -e "${CYAN}│${NC}  ${GREEN}7)${NC} ${WHITE}Create Contract on ${BLUE}Anvil-NoChain${WHITE}       ${CYAN}${NC}"
    echo -e "${CYAN}│${NC}  ${GREEN}8)${NC} ${WHITE}Script Deploy on ${BLUE}Holesky${WHITE}         ${CYAN}${NC}"
    echo -e "${CYAN}│${NC}  ${GREEN}9)${NC} ${WHITE}Script Deploy on ${BLUE}Sepolia${WHITE}         ${CYAN}${NC}"
    echo -e "${CYAN}│${NC}  ${GREEN}10)${NC} ${WHITE}Script Deploy on ${BLUE}Anvil${WHITE}         ${CYAN}${NC}"
    echo -e "${CYAN}│${NC}  ${GREEN}11)${NC} ${WHITE}Script Deploy on ${BLUE}Anvil-NoChain${WHITE}         ${CYAN}${NC}"
    echo -e "${CYAN}│${NC}  ${RED}0)${NC} ${WHITE}Exit                                              ${CYAN}${NC}"
    echo -e "${CYAN}└──────────────────────────────────────────┘${NC}"

    echo -ne "${YELLOW}Enter your choice [0-7]: ${NC}"
    read choice

    case $choice in
    1) foset ;;
    2) fo_only ;;
    3) fo_test ;;
    4) fo_create_holeksy ;;
    5) fo_create_sepolia ;;
    6) fo_create_anvil ;;
    7) fo_create_anvil_nochain ;;
    8) fo_script_holeksy ;;
    9) fo_script_sepolia ;;
    10) fo_script_anvil ;;
    11) fo_script_anvil_nochain ;;
    0)
        echo -e "${GREEN}👋 Exiting. Have a productive dev sesh!${NC}"
        exit 0
        ;;
    *)
        echo -e "${RED}❌ Invalid choice. Try again.${NC}"
        exit 1
        ;;
    esac
}

# Run it
main_menu
