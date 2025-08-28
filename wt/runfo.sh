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
    "https://eth-sepolia.g.alchemy.com/v2/YfG5-esHajH3FpsLvC4eMFMEFYl9Lqcg"
    "https://eth-holesky.g.alchemy.com/v2/YfG5-esHajH3FpsLvC4eMFMEFYl9Lqcg"
)
keyz=(
    "0x3f03926cdb1f85a7b189060f53b0d055eb8c0cc9a838e929525eded8d7440dde"
    "0x6ce075e337c519ed35567152183557bbfec6d8c33d480464539a1fa2fd53dc04"
    "0xf66f5d4d5e2c7477f1139c94308732eb962309c2808838be8d7331f1a0b6806c"
)
accz=(
    "0x2ce40e5d9BC00dA5f397690E83E88183c4d4b23F"
    "0x5508D7e21f7B096481AfCc9bA2e2a405Be96b878"
    "0x2C1381655097598Bae22c5326b0F3B43220a18c4"
)
ETHERSCAN_API_KEY="2JEANQYC4C9S6PKDFWNGVT2UER24T32D2M"

# Testing
fo_test() {
    hea1 "Foundry Run"
    CO1="forge test"
    eval "$CO1"
}

# Contract Deploy with verfication
fo_create() {

    hea1 "Foundry Create - One of contract deployment"

    CONTRACT_PATH="src/Counter.sol:Counter"

    # RPC_URL="https://eth-sepolia.g.alchemy.com/v2/YfG5-esHajH3FpsLvC4eMFMEFYl9Lqcg"
    # PRIVATE_KEY="0x3f03926cdb1f85a7b189060f53b0d055eb8c0cc9a838e929525eded8d7440dde"
    # ETHERSCAN_API_KEY="2JEANQYC4C9S6PKDFWNGVT2UER24T32D2M"

    CO1="forge create ${CONTRACT_PATH} \
  --rpc-url ${rpcz[1]} \
  --private-key ${keyz[1]} \
  --etherscan-api-key ${ETHERSCAN_API_KEY} \
  --verify --broadcast"

    eval "$CO1"
    echo -e "${GREEN}Successfully deployed contract${NC}"

}

fo_script() {
    hea1 "Foundry Script - One of contract deployment"

    CO1="forge script script/Counter.s.sol:CounterScript \
        --rpc-url ${rpcz[1]} \
        --private-key ${keyz[1]} \
        --broadcast"

    eval "$CO1"
    echo -e "${GREEN}Successfully deployed contract${NC}"
}

# Execution
# foset # Setup a new foundry project with slither
# fo_only # Setup only foundry project
# fo_test # Run the tests
# fo_create # Deploy the contract with verification
# fo_script # Run the script
