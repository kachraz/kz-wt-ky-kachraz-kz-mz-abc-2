#!/usr/bin/bash
# This bash srcript is for making cast accounts
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

cast_wallet_mnemonic() {
    hea1 "Create Wallets Using cast and menmonic"
    # Get name of Project
    echo -e "Enter Number Of Wallets to create with cast starting with 12"
    read number_of_wallets

    # Validate numeric input and minimum value
    if ! [[ "$number_of_wallets" =~ ^[0-9]+$ ]]; then
        echo -e "${RED}FUKR: NUMBER ONL${NC}"
        exit 1
    fi

    if [ -z "$number_of_wallets" ]; then
        echo -e "${RED}BASTARD ! Can be empty{NC}"
        exit 1
    fi

    # Commands to execute
    output_file="wallets_${number_of_wallets}.txt"
    CO1="cast w nm -a ${number_of_wallets}"

    # Execute command and save output
    if ! eval "$CO1" >"$output_file"; then
        echo -e "${RED}Error: Failed to create wallets${NC}"
        exit 1
    else
        echo -e "${GREEN}Successfully created $number_of_wallets wallets"
        echo -e "Output saved to: $output_file${NC}"
    fi

}

cast_wallet_van_starts_with() {
    hea1 "Create Wallets Using cast and menmonic"

    startsWith="999999"

    # Get name of Project
    echo -e "Enter Number Of Wallets to create with cast starting with ${startsWith}"
    read -r number_of_wallets

    # Validate numeric input and minimum value
    if ! [[ "$number_of_wallets" =~ ^[0-9]+$ ]]; then
        echo -e "${RED}FUKR: NUMBER ONL${NC}"
        exit 1
    fi

    if [ -z "$number_of_wallets" ]; then
        echo -e "${RED}BASTARD ! Can be empty{NC}"
        exit 1
    fi

    # Commands to execute - include startsWith in filename
    output_file="wallets_${startsWith}_${number_of_wallets}.txt"

    # Create or clear the output file
    >"$output_file"

    # Loop through the number of wallets
    for ((i = 1; i <= number_of_wallets; i++)); do
        echo -e "Creating wallet $i of $number_of_wallets..."
        if ! cast w va --starts-with ${startsWith} >>"$output_file"; then
            echo -e "${RED}Error: Failed to create wallet $i${NC}"
            exit 1
        fi

        # Add a divider after each wallet (except the last one)
        if [ $i -lt $number_of_wallets ]; then
            echo -e "----------------------------------------" >>"$output_file"
            echo -e "" >>"$output_file" # Add an empty line for better readability
        fi
    done

    echo -e "${GREEN}Successfully created $number_of_wallets wallets"
    echo -e "Output saved to: $output_file${NC}"
}

cast_wallet_van_ends_with() {
    hea1 "Create Wallets Using cast and menmonic"

    endsWith="999999"

    # Get name of Project
    echo -e "Enter Number Of Wallets to create with cast starting with ${endsWith}"
    read -r number_of_wallets

    # Validate numeric input and minimum value
    if ! [[ "$number_of_wallets" =~ ^[0-9]+$ ]]; then
        echo -e "${RED}FUKR: NUMBER ONL${NC}"
        exit 1
    fi

    if [ -z "$number_of_wallets" ]; then
        echo -e "${RED}BASTARD ! Can be empty{NC}"
        exit 1
    fi

    # Commands to execute - include endsWith in filename
    output_file="wallets_ends_${endsWith}_${number_of_wallets}.txt"

    # Create or clear the output file
    >"$output_file"

    # Loop through the number of wallets
    for ((i = 1; i <= number_of_wallets; i++)); do
        echo -e "Creating wallet $i of $number_of_wallets..."
        if ! cast w va --starts-with ${endsWith} >>"$output_file"; then
            echo -e "${RED}Error: Failed to create wallet $i${NC}"
            exit 1
        fi

        # Add a divider after each wallet (except the last one)
        if [ $i -lt $number_of_wallets ]; then
            echo -e "----------------------------------------" >>"$output_file"
            echo -e "" >>"$output_file" # Add an empty line for better readability
        fi
    done

    echo -e "${GREEN}Successfully created $number_of_wallets wallets"
    echo -e "Output saved to: $output_file${NC}"
}

cast_wallet_van_start_end_with() {
    hea1 "Create Wallets Using cast and menmonic"

    startsWith="6666"
    endsWith="9999"

    # Get name of Project
    echo -e "Enter Number Of Wallets to create with cast starting with ${startsWith} and endswith ${endsWith}"
    read -r number_of_wallets

    # Validate numeric input and minimum value
    if ! [[ "$number_of_wallets" =~ ^[0-9]+$ ]]; then
        echo -e "${RED}FUKR: NUMBER ONL${NC}"
        exit 1
    fi

    if [ -z "$number_of_wallets" ]; then
        echo -e "${RED}BASTARD ! Cant be empty{NC}"
        exit 1
    fi

    # Commands to execute - include endsWith in filename
    output_file="wallets_starts_${startsWith}__ends_${endsWith}_${number_of_wallets}.txt"

    # Create or clear the output file
    >"$output_file"

    # Loop through the number of wallets
    for ((i = 1; i <= number_of_wallets; i++)); do
        echo -e "Creating wallet $i of $number_of_wallets..."
        if ! cast w va --starts-with ${startsWith} --ends-with ${endsWith} >>"$output_file"; then
            echo -e "${RED}Error: Failed to create wallet $i${NC}"
            exit 1
        fi

        # Add a divider after each wallet (except the last one)
        if [ $i -lt $number_of_wallets ]; then
            echo -e "----------------------------------------" >>"$output_file"
            echo -e "" >>"$output_file" # Add an empty line for better readability
        fi
    done

    echo -e "${GREEN}Successfully created $number_of_wallets wallets"
    echo -e "Output saved to: $output_file${NC}"
}

# Execution
cast_wallet_van_start_end_with
