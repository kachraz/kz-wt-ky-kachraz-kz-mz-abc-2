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

# Setup Env and install packages
uvSetup() {
    hea1 "Setting up Environment"

    # Get Name of project
    echo -e "Enter the name of the project: "
    read name_of_project
    if [ -z "$name_of_project" ]; then
        echo -e "${RED}BASTARD ! Project name cannot be empty${NC}"
        exit 1
    fi

    # Setup Directory
    DEPS="fastapi uvicorn requests rich python-dotenv"
    co1="mkdir -v $name_of_project && cd $name_of_project"
    co2="uv venv"
    co3="uv pip install $DEPS"
    co4="uv pip list"

    # Commands execution
    eval "$co1"
    eval "$co2"
    eval "$co3"
    eval "$co4"
    echo -e "${YELLOW}[?] Execute source .venv/bin/activate.fish ${NC}"
    echo -e "${GREEN}[+] Installation Completed ${NC}"
}

# Execute
uvSetup
