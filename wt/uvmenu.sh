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

jupyter_setup() {
    hea1 "UV Jupyter Lan Installation Commands"
    # Get name of Project
    echo -e "Enter the name of the project: "
    read name_of_project
    if [ -z "$name_of_project" ]; then
        echo -e "${RED}BASTARD ! Project name cannot be empty${NC}"
        exit 1
    fi

    # Commands to execute
    CO1="uv init $name_of_project"
    CO2="cd $name_of_project"
    CO3="uv add --dev ipykernel"
    CO4="uv tree"

    # Show Commands
    echo -e ""
    echo -e "${GREEN}---Commands to execute:---"
    echo -e ">$CO1"
    echo -e ">$CO2"
    echo -e ">$CO3"
    echo -e ">$CO4"
    echo -e "Executing....${NC}"

    # Execution Commands
    eval "$CO1"
    eval "$CO2"
    eval "$CO3"
    eval "$CO4"

}

# UV Setup

uvsetup() {
    hea1 "UV Installation with packages"

    # Get Name of project
    echo -e "Enter the name of the project: "
    read name_of_project
    if [ -z "$name_of_project" ]; then
        echo -e "${RED}BASTARD ! Project name cannot be empty${NC}"
        exit 1
    fi

    # UC Commands
    CO1="uv init $name_of_project"
    CO2="cd $name_of_project"

    DEPS="rich langgraph langgraph-sdk langgraph-checkpoint-sqlite langsmith langchain-community langchain-core langchain-openai notebook tavily-python wikipedia trustcall langgraph-cli"
    CO3="uv add  $DEPS"
    CO4="uv tree"

    ## RUN Above Commands
    echo -e "--- Executing ${CO1} ---"
    eval "$CO1"
    echo -e "--- Executing ${CO2} ---"
    eval "$CO2"
    echo -e "--- Executing ${CO3} ---"
    eval "$CO3"
    echo -e "--- Executing ${CO4} ---"
    eval "$CO4"
    echo -e "${GREEN}***** Installation Completed *****${NC}"
}

## UV Tavily Setup
uv_tavily_setup() {
    hea1 "UV Tavily Installation with packages"

    # Get Name of project
    echo -e "Enter the name of the project: "
    read -r name_of_project
    if [ -z "$name_of_project" ]; then
        echo -e "${RED}BASTARD ! Project name cannot be empty${NC}"
        exit 1
    fi

    # UC Commands
    CO1="uv init $name_of_project"
    CO2="cd $name_of_project"

    DEPS="rich tavily-python python-dotenv"
    CO3="uv add  $DEPS"
    CO4="uv tree"

    ## RUN Above Commands
    echo -e "--- Executing ${CO1} ---"
    eval "$CO1"
    echo -e "--- Executing ${CO2} ---"
    eval "$CO2"
    echo -e "--- Executing ${CO3} ---"
    eval "$CO3"
    echo -e "--- Executing ${CO4} ---"
    eval "$CO4"
    echo -e "${GREEN}***** Installation Completed *****${NC}"
}

uv_wik_setup() {
    hea1 "UV Wikipedia Installation with packages"

    # Get Name of project
    echo -e "Enter the name of the project: "
    read -r name_of_project
    if [ -z "$name_of_project" ]; then
        echo -e "${RED}BASTARD ! Project name cannot be empty${NC}"
        exit 1
    fi

    # UC Commands
    CO1="uv init $name_of_project"
    CO2="cd $name_of_project"

    DEPS="rich wikipedia"
    CO3="uv add  $DEPS"
    CO4="uv tree"

    ## RUN Above Commands
    echo -e "--- Executing ${CO1} ---"
    eval "$CO1"
    echo -e "--- Executing ${CO2} ---"
    eval "$CO2"
    echo -e "--- Executing ${CO3} ---"
    eval "$CO3"
    echo -e "--- Executing ${CO4} ---"
    eval "$CO4"
    echo -e "${GREEN}***** Installation Completed *****${NC}"
}
uv_duck_setup() {
    hea1 "UV Wikipedia Installation with packages"

    # Get Name of project
    echo -e "Enter the name of the project: "
    read -r name_of_project
    if [ -z "$name_of_project" ]; then
        echo -e "${RED}BASTARD ! Project name cannot be empty${NC}"
        exit 1
    fi

    # UC Commands
    CO1="uv init $name_of_project"
    CO2="cd $name_of_project"

    DEPS="rich duckduckgo_search"
    CO3="uv add  $DEPS"
    CO4="uv tree"

    ## RUN Above Commands
    echo -e "--- Executing ${CO1} ---"
    eval "$CO1"
    echo -e "--- Executing ${CO2} ---"
    eval "$CO2"
    echo -e "--- Executing ${CO3} ---"
    eval "$CO3"
    echo -e "--- Executing ${CO4} ---"
    eval "$CO4"
    echo -e "${GREEN}***** Installation Completed *****${NC}"
}

menu_choice() {
    clear
    hea1 "Installation Menu"
    echo -e "${YELLOW}Choose an option:${NC}"
    echo -e "${GREEN}1) UV Wikipedia Setup${NC}"
    echo -e "${GREEN}2) UV Tavily Setup${NC}"
    echo -e "${GREEN}3) UV General Setup${NC}"
    echo -e "${GREEN}4) Jupyter Setup${NC}"
    echo -e "${GREEN}5) DuclDuckGo Setup${NC}"
    echo -e "${RED}6) Exit${NC}"
    echo -ne "${CYAN}Enter your choice: ${NC}"
    read choice

    case $choice in
    1) uv_wik_setup ;;
    2) uv_tavily_setup ;;
    3) uvsetup ;;
    4) jupyter_setup ;;
    5) uv_duck_setup ;;
    6)
        echo -e "${RED}Exiting...${NC}"
        exit 0
        ;;
    *)
        echo -e "${RED}Invalid choice, exiting.${NC}"
        exit 1
        ;;
    esac
}

# Execution
menu_choice
