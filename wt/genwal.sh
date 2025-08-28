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
b1() {
    echo -e "${CYAN}===================================="
    echo -e "Generating wallets with cast"
    echo -e "===================================${NC}"
}

c1() {
    echo -e "${GREEN}[?] How many wallets to generate with cast? : ${NC}"
    read num

    # Create a filename that includes the number of wallets
    output_file="${num}_wallets.txt"

    # Clear the file if it already exists
    >"$output_file"

    # Generate wallets and append to the file
    for ((i = 1; i <= num; i++)); do
        cast w va --starts-with 69 >>"$output_file"
        echo -e "\n" >>"$output_file" # Add a newline after each wallet
    done

    echo -e "${GREEN}[+] Generated $num wallets and saved to $output_file ${NC}"
}

# Execution
b1
c1
