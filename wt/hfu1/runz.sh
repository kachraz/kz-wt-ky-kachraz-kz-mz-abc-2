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

h1() {
    echo -e "${CYAN}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
    echo -e "${PURPLE}$1${NC}"
    echo -e "${CYAN}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
}

ru_ma() {
    h1 "Running MCP Server 1"
    co1="uv run panty.py"

    echo -e "${GREEN}SmellPanty...${NC}"
    echo -e "${YELLOW}Command: ${NC}${co1}"
    echo -e ""
    echo -e ""
    eval "$co1"
}

# Execution
ru_ma
