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

# UV Setup
foset
