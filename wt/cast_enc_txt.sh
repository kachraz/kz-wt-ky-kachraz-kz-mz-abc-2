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

b1() {
    hea1 "UV Jupyter Lan Installation Commands"
}

# Function will ask for an input and convert to hex
encode_to_hex_input() {
    hea1 "Use cast to convert UTF8 to hex"
    echo -e ""
    echo -e "${BLUE}Write Text to encode: "
    echo -e "--------------------------------${NC}"
    read -r dataz
    if [ -z "$dataz" ]; then
        echo -e "${RED}BASTARD! PutSomething!${NC}"
        exit 1
    fi

    cmd1="cast fa \"$dataz\""
    hex_out=$(eval "$cmd1")
    cmd2="cast tas $hex_out"
    hex_in=$(eval "$cmd2")
    file_name="out.txt"

    echo -e "${CYAN}---Output---${NC}"
    echo -e "${GREEN} ${hex_out} ${NC}"
    echo "---Output---" >${file_name}
    echo "$hex_out" >>${file_name}
    echo -e ""
    echo -e "${YELLOW}---Input---${NC}"
    echo -e "${GREEN} ${hex_in} ${NC}"
    echo "---input---" >>${file_name}
    echo "$hex_in" >>${file_name}
}

#Function that will convert data stored in variable to hex
encodedata__to_hex_input() {
    hea1 "Use cast to convert UTF8 Data to hex"

    read -r -d '' dataz <<'EOF'

 ███████╗ ███╗   ███╗ ███████╗ ██╗      ██╗      ██████╗   █████╗  ███╗   ██╗ ████████╗ ██╗   ██╗
 ██╔════╝ ████╗ ████║ ██╔════╝ ██║      ██║      ██╔══██╗ ██╔══██╗ ████╗  ██║ ╚══██╔══╝ ╚██╗ ██╔╝
 ███████╗ ██╔████╔██║ █████╗   ██║      ██║      ██████╔╝ ███████║ ██╔██╗ ██║    ██║     ╚████╔╝ 
 ╚════██║ ██║╚██╔╝██║ ██╔══╝   ██║      ██║      ██╔═══╝  ██╔══██║ ██║╚██╗██║    ██║      ╚██╔╝  
 ███████║ ██║ ╚═╝ ██║ ███████╗ ███████╗ ███████╗ ██║      ██║  ██║ ██║ ╚████║    ██║       ██║   
 ╚══════╝ ╚═╝     ╚═╝ ╚══════╝ ╚══════╝ ╚══════╝ ╚═╝      ╚═╝  ╚═╝ ╚═╝  ╚═══╝    ╚═╝       ╚═╝   

EOF

    cmd1="cast fa \"$dataz\""
    hex_out=$(eval "$cmd1")
    file_name="out.txt"

    echo -e "${CYAN}---Output---${NC}"
    echo -e "${GREEN} ${hex_out} ${NC}"
    echo "---Output---" >${file_name}
    echo "$hex_out" >>${file_name}
    echo -e ""
}

# Send data with the transaction
ca_send_hex() {
    hea1 "Use cast to send hex data"

    # === 1. Define the ASCII or payload ===
    read -r -d '' dataz <<'EOF'

⠈⠁⡀⠀⠠⢄⡀⠀⢸⣿⣿⣿⣿⣿⣸⣿⣼⣷⣄⣿⣿⣿⣿⣿⣷⠀⠀⠀⠀⠀⠀⠀⢁⡴⠂⠀⢠⠜⠉⢀⣀⣀⡤⠤⠄⠀⠀⠠⡨⠶⢄⣦⣄⣀⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠈⢆⠀⠀⠈⠁⠸⣿⣿⣿⣿⣿⣷⣿⣿⣿⣿⣿⣿⣿⣿⣿⡏⠀⠀⠀⠀⢀⠔⢠⠞⠀⢀⡴⠛⠒⠋⠉⠀⠀⡀⠀⠈⠀⠀⠉⠀⠀⠀⠀⠀⠀⠀⠉⠉⠉⠙⠛⠲⣤⢤⡀⡀
⣆⡄⡀⠀⢳⡄⠀⠀⠀⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⢀⣴⠋⢀⣴⠋⠀⠀⠀⠀⠀⠀⠀⠉⠑⢂⠀⢠⠀⠀⠀⠀⠈⠒⣤⣀⠀⠀⠀⠐⠀⣀⣠⣿⣿⣶
⠙⢿⡡⢀⠀⠙⢧⡀⣠⣿⠿⢿⢻⠛⣏⡝⣏⠻⣍⢟⡛⢯⢻⢿⣧⡀⠀⠀⠀⠘⠁⣠⠟⢁⢀⢀⠀⠀⠀⠠⠀⠀⠀⠀⠈⠘⠈⠀⢀⢀⠸⢀⠇⡘⠙⠧⠄⠀⣘⣼⣿⣿⣿⡿⣽
⠀⠀⠉⠳⣆⡄⣠⣿⣿⣯⣟⣯⢏⣟⡾⣼⢎⡿⣼⢮⣽⢫⣟⢮⣷⣻⣦⡄⠀⡠⢾⠁⣄⣶⣿⣿⣿⣶⣦⣄⡀⠀⠄⠀⠀⠀⠀⠠⢂⠐⣈⠢⠐⠀⢀⡀⣠⣶⣾⣿⣿⣿⣿⡵⣏
⠀⠀⠀⠀⢀⣿⣿⣿⣿⣿⡾⣽⣻⢾⡽⣞⣯⣟⡾⣽⣞⡿⣞⡿⣞⣿⣿⣿⣯⡀⣿⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣶⣤⣀⡀⠀⡀⠀⠈⠀⠀⠀⣅⣫⡶⠟⠛⠋⠉⠀⠈⠛⣿⣗⢮
⠀⠀⠀⢀⣼⣿⣿⣿⣿⣿⣽⣿⣽⣯⣿⣟⣾⣽⣟⣷⣯⣿⣻⣽⣿⣿⣿⣿⣿⣿⡗⡊⣿⡿⠋⠁⠀⠀⠀⠉⠉⠓⠻⠽⣽⣻⣿⣿⡿⠿⠛⠋⠉⠀⠀⠀⠀⠀⠀⠀⠀⠁⣿⡜⣯
⠀⠀⠀⣾⣿⣿⣿⣿⣿⣿⣿⣯⣿⣿⣾⣿⣿⣿⣾⣿⣷⣿⣿⣿⣿⣿⣿⣿⣿⣿⣇⣵⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⣽⡁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⡸⣷⢎
⠀⠀⢰⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣿⣿⣽⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣴⠏⣷⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠠⢑⣿⢬
⠀⠀⢸⣿⣿⣿⡿⠿⠟⠛⠛⠛⠋⠉⠉⠙⣿⠛⠉⠉⠉⠉⠉⠉⠛⠛⠛⠿⢿⣿⣿⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⣾⡟⣿⢹⣿⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠾⣹⣿
⠀⠀⣿⢟⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣹⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠐⢙⣷⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⠿⣽⡿⠿⢿⡅⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠆⡳⣿
⠀⠀⡟⢀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣾⣿⣿⡾⢤⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠨⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣆⠀⠀⠀⡞⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢄⡱⣿
⠀⠀⡇⠂⠀⠀⠀⠀⠀⠐⠒⠒⠊⠉⠀⠻⡉⢹⠇⠀⠀⠈⠉⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⡄⠀⢸⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠐⢀⠞⣿
⠀⠀⠇⡈⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣇⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡇⡀⢼⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠊⡜⣿
⠀⠀⠐⠠⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡇⣇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣧⣤⡿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠌⠰⣸⣿
⠀⠀⠈⠰⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⡇⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢹⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣯⣷⡿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠰⢨⠱⣼⣷
⠀⠀⠀⢁⠂⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣷⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢨⡇⠌⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢨⣿⣶⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢂⠅⠪⣽⣷
⠀⠀⠀⠰⡈⢁⠂⠀⠀⠀⠀⠀⠀⠀⠀⠠⣿⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠋⢷⢂⠡⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⣿⣯⣿⠐⡀⠀⠀⠀⠀⠀⠀⠀⠀⡀⠌⠰⣈⢳⠀⡙
⠀⠀⠀⠀⡕⢂⠐⠀⠀⠀⠀⠀⠀⠀⠀⠐⣿⠂⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡈⠄⢸⡎⠄⠡⠂⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⠂⠀⠀⠀⠀⠀⠀⠀⠀⠠⢀⠃⡅⢢⡹⢠⠱

EOF

    # === 2. Encode the data to hex using cast abi-encode ===
    echo -e "${BLUE}Encoding ASCII to hex...${NC}"
    make_data="cast fa \"$dataz\""
    hex_out=$(eval "$make_data")

    # === 3. Setup ===
    local -a wallets=(
        "0x420A8Fe13265Df3B9323C3D7681b2854B1309338"
        "0x420fFfdA7565D31e9b4b7ebAF0269b5564644656"
    )

    local -a keyz=(
        "0x6890220d6cc0218032cab963a528672d85643a2c7edf340de6e27861d1900958"
        "0xff630bf91f95d3e7af70c12490b858cd5e0818b2bc6af6fccff9d933a1097bc4"
    )

    local -a networks=(
        "https://eth-sepolia.g.alchemy.com/v2/y-cD2hUWMXwa6cAWy7uplLSSoRQ5v7Fx"
        "https://eth-holesky.g.alchemy.com/v2/y-cD2hUWMXwa6cAWy7uplLSSoRQ5v7Fx"
    )

    mkdir -p logs
    LOG_FILE="logs/cast_send_$(date +%Y%m%d_%H%M%S).log"

    # === 4. Sepolia Transaction ===
    echo -e "\n${BLUE}Sending transaction on Sepolia...${NC}" | tee -a "$LOG_FILE"

    CO1="cast send \
        --chain sepolia \
        --rpc-url ${networks[0]} \
        --private-key ${keyz[0]} \
        ${wallets[1]} ${hex_out}"

    eval "$CO1" 2>&1 | tee -a "$LOG_FILE"
    if [ "${PIPESTATUS[0]}" -ne 0 ]; then
        echo -e "${RED}Sepolia transaction failed.${NC}" | tee -a "$LOG_FILE"
        return 1
    else
        echo -e "${GREEN}Sepolia transaction successful!${NC}" | tee -a "$LOG_FILE"
    fi

    # === 5. Holesky Transaction ===
    echo -e "\n${BLUE}Sending transaction on Holesky...${NC}" | tee -a "$LOG_FILE"

    CO2="cast send \
        --chain holesky \
        --rpc-url ${networks[1]} \
        --private-key ${keyz[0]} \
        ${wallets[1]} ${hex_out}"

    eval "$CO2" 2>&1 | tee -a "$LOG_FILE"
    if [ "${PIPESTATUS[0]}" -ne 0 ]; then
        echo -e "${RED}Holesky transaction failed.${NC}" | tee -a "$LOG_FILE"
        return 1
    else
        echo -e "${GREEN}Holesky transaction successful!${NC}" | tee -a "$LOG_FILE"
    fi

    echo -e "\n${YELLOW}Full log saved to: ${LOG_FILE}${NC}"
}

# Execution
ca_send_hex
