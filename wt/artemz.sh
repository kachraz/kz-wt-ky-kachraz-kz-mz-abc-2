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

# Banner Function
b1() {
    echo -e "${CYAN} ====================="
    echo -e "Artem Commands"
    echo -e "===================== ${NC}"
}

# Artem function gfx rendering
c1() {
    FIL="g1.jpg"
    CO="artem --border --background $FIL"
    CO2="artem --border --background $FIL --output g1.ansi"
    echo -e "${GREEN} Executin the command: ${CO} ${NC}"
    $CO
    echo -e "${GREEN} Executin the command: ${CO2} ${NC}"
    $CO2
}

# Rotating image clockwise
c3() {
    CO="ffmpeg -i g.jpg -vf \"transpose=1\" g1.jpg"
    echo -e "${GREEN} Executing the command: ${CO} ${NC}"
    eval "$CO"
}

# Write to snips.sh
c4() {
    KEY="sniff"
    FIL="g1.ansi"
    CO="bat $FIL | ssh -i $KEY snips.sh"
    echo -e "{GREEN}Pushing to snips.sh"
    echo -e "Executing the command: ${CO} ${NC}"
    $CO
}

# Viewing the file
c5() {
    ADY="https://snips.sh/f/vYOIhLB4A2"
    CO="curl $ADY"
    echo -e "${GREEN} Executing the command: ${CO} ${NC}"
    $CO
}

# Execution
b1
c5
