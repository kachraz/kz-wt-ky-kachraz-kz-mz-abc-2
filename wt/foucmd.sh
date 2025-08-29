#!/usr/bin/bash
# System Commands

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

# --- Important Variables ---

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

# Commands

h1() {
    echo -e "${CYAN}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
    echo -e "${PURPLE}$1${NC}"
    echo -e "${CYAN}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
}

# Commands

# --- Function that finds file pattern and deletes it
fd_find_delete() {
    h1 "Finding files with fd and delete"
    co1="fd -g 'counters*.sol' -X rm -i"
    echo -e "${GREEN}Command: ${NC}${co1}"
    eval "$co1"
}

# --- Cast - get contract bytecode
cast_bytecode() {
    h1 "Cast Get Contract Bytecode"

    KONTRACT="0xDb441F74E8B7307220823e228659415fFB7A59aa"

    # Create filename with date appended (format: YYYYMMDD_HHMMSS)
    DATE_STAMP=$(date '+%Y%m%d_%H%M%S')
    OUTPUT_FILE="cmdrun/cast_bytecode_run_${DATE_STAMP}.txt"

    co1="cast code $KONTRACT -r ${rpcz[1]}"
    echo -e "${GREEN}Command: ${NC}${co1}"

    # First write the date to the file
    echo "Date: $(date '+%Y-%m-%d %H:%M:%S')" >"$OUTPUT_FILE"
    echo "Command: $co1" >>"$OUTPUT_FILE"
    echo "-------------------------------------------" >>"$OUTPUT_FILE"

    # Now append the command output to the file that already has the date
    output=$(eval "$co1" | tee -a "$OUTPUT_FILE")

    echo -e "${GREEN}Output: ${NC} \n----\n $output $" # Show first 60 chars

    echo -e "\n${GREEN}Bytecode saved to:${NC} $OUTPUT_FILE"
}

# Executions
# fd_find_delete
cast_bytecode
