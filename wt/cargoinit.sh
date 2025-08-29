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

cargo_main_install() {
    hea1 "Cargo New Initialization with yansi and cfonts"
    # Get name of Project
    echo -e "Enter the name of the project: "
    read name_of_project
    if [ -z "$name_of_project" ]; then
        echo -e "${RED}BASTARD ! Project name cannot be empty${NC}"
        exit 1
    fi

    # Commands to execute
    CO1="cargo new $name_of_project"
    CO2="cd $name_of_project"
    CO3="cargo add yansi cfonts"
    CO4="cargo tree"

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

cargo_installz() {
    hea1 "Cargo Install"

    # Commands to execute
    DEPS="bacon cargo-show-asm "
    CO1="cargo install $DEPS "

    # Show Commands
    echo -e ""
    echo -e "${GREEN}---Commands to execute:---"
    echo -e ">$CO1"
    echo -e "Executing....${NC}"

    # Execution Commands
    eval "$CO1"
}

cargo_lib() {
    hea1 "Cargo New Initialization with yansi and cfonts"
    # Get name of Project
    echo -e "Enter the name of the cargo Library: "
    read name_of_project
    if [ -z "$name_of_project" ]; then
        echo -e "${RED}BASTARD ! Project name cannot be empty${NC}"
        exit 1
    fi

    # Commands to execute
    CO1="cargo init --lib $name_of_project"
    CO2="cd $name_of_project"
    CO3="cargo add yansi cfonts"
    CO4="cargo tree"

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

show_menu() {
    clear
    hea1 "Cargo Project Management"
    echo -e "${GREEN}1.${NC} Create new Cargo binary project"
    echo -e "${GREEN}2.${NC} Create new Cargo library project"
    echo -e "${GREEN}3.${NC} Install cargo tools (bacon, cargo-show-asm)"
    echo -e "${GREEN}4.${NC} Exit"
    echo -e ""
    echo -e "Enter your choice [1-4]: "
}

# Main execution loop
while true; do
    show_menu
    read choice
    case $choice in
    1) cargo_main_install ;;
    2) cargo_lib ;;
    3) cargo_installz ;;
    4)
        echo -e "${YELLOW}Exiting...${NC}"
        exit 0
        ;;
    *)
        echo -e "${RED}Invalid option! Please try again.${NC}"
        sleep 2
        ;;
    esac
    echo -e "\n${YELLOW}Press any key to return to menu...${NC}"
    read -n 1 -s
done
