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
    echo -e "${CYAN} ======================"
    echo -e "Setup up KaliLinux Docker Image"
    echo -e " ======================${NC}"
}

c1() {
    COM1="docker run -it --privileged -v .:/panty kalilinux/kali-rolling:latest bash"
    echo -e "${GREEN} ${COM1} "
    echo -e "execute - apt update && apt -y install kali-linux-headless when done${NC}"
    eval ${COM1}
}

# Execution
b1
c1
