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

bun_pussy() {
    # Bun init start 
    hea1 "Buni: Sexy ass and pussy"

    # Get Name of project
    echo -e "Enter the name of the project: "
    read name_of_project
    if [ -z "$name_of_project" ]; then
        echo -e "${RED}BASTARD ! Project name cannot be empty${NC}"
        exit 1
    fi

    # Commands and variables
    CO1="mkdir -v $name_of_project && cd $name_of_project && bun init -y"
    CO2="bun add chalk axios dotenv ora cli boxen progress openai inquirer"
    CO3="bun add @types/bun @types/progress -D"
    CO4="bun pm ls"

    # RUN Above Commands
    echo -e "--- Initiate ${CO1} ---"
    eval "$CO1"
    echo -e "--- Adding PKGS ${CO2} ---"
    eval "$CO2" && eval "$CO3" && eval "$CO4"
    echo -e "${GREEN}***** Installation Completed *****${NC}"
}

bun_basic() {
    # Bare bones install 
    hea1 "Bun Basic Install"

    # Get Name of project
    echo -e "Enter the name of the project: "
    read name_of_project
    if [ -z "$name_of_project" ]; then
        echo -e "${RED}BASTARD ! Project name cannot be empty${NC}"
        exit 1
    fi

    # Commands and variables
    CO1="mkdir -v $name_of_project && cd $name_of_project && bun init -y"
    CO2="bun pm ls"

    # RUN Above Commands
    echo -e "--- Initiate ${CO1} ---"
    eval "$CO1"
    echo -e "--- Init Bun Basic ---"
    eval "$CO2" 
    echo -e "${GREEN}***** Installation Completed *****${NC}"
}

# Menu Function 
menu_choice() {
    clear
    hea1 "Installation Menu"
    echo -e "${YELLOW}Choose an option:${NC}"
    echo -e "${GREEN}1) Bun with sexy ass and pussy${NC}"
    echo -e "${GREEN}2) Bun Basic${NC}"
    echo -e "${RED}3) AssFucking ${NC}"
    echo -ne "${CYAN}Enter your choice: ${NC}"
    read choice

    case $choice in
    1) bun_pussy ;;
    2) bun_basic ;;
    3)
        echo -e "${RED}Raped !...${NC}"
        exit 0
        ;;
    *)
        echo -e "${RED}Batard ! Invalid choice, exiting.${NC}"
        exit 1
        ;;
    esac
}

# Execution
menu_choice
