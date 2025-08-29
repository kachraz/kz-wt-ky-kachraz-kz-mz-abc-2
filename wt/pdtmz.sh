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

# pdtm installz

pd_all() {
    h1 "PDTM Install via pdtm"

    co1="go install -v github.com/projectdiscovery/pdtm/cmd/pdtm@latest"
    co2="pdtm -ia"
    co3="sudo apt install -y libpcap-dev"

    echo -e "${GREEN}Installing PDTM Manager....${NC}"
    echo -e "${GREEN}$co1${NC}"
    eval "$co3"
    eval "$co1"

    echo -e "${GREEN}Running PDTM Manager....${NC}"
    echo -e "${GREEN}$co2${NC}"
    eval "$co2"

}

# --- make and move massdns into /urs/local/bin - needed for shuffle dns in pj
massdnsinstall() {
    h1 "Build MassDns and install in /usr/local/bing"
    c1="git clone https://github.com/blechschmidt/massdns"
    c2="cd massdns && make"
    c3="sudo cp bin/massdns /usr/local/bin"
    echo -e "${GREEN}$c1${NC}"
    eval "$c1"
    echo -e "${GREEN}$c2${NC}"
    eval "$c2"
    echo -e "${GREEN}$c3${NC}"
    eval "$c3"
}

# Rustscan - nmap faster alternative installation
# https://github.com/bee-san/RustScan - Official Repo
rustscan1() {
    h1 "Rustscan Install"
    co1="brew install rustscan"
    echo -e "${GREEN}$co1${NC}"
    eval "$co1"
}

# Function to install Nmap, Ncat, and Nping
install_nmap_tools() {
    # Update package lists
    sudo apt-get update

    # Install alien and dpkg if not already installed
    sudo apt-get install -y alien dpkg wget

    # Define the base URL for Nmap downloads
    BASE_URL="https://nmap.org/dist"

    # Define the versions and packages to download
    declare -A packages=(
        ["nmap"]="nmap-7.92-1.x86_64.rpm"
        ["ncat"]="ncat-7.92-1.x86_64.rpm"
        ["nping"]="nping-0.7.92-1.x86_64.rpm"
    )

    # Loop through each package, download, convert, and install
    for tool in "${!packages[@]}"; do
        rpm_file="${packages[$tool]}"
        deb_file="${rpm_file%.rpm}.deb"

        # Download the RPM package
        wget "${BASE_URL}/${rpm_file}"

        # Convert RPM to DEB
        sudo alien --to-deb "${rpm_file}"

        # Install the DEB package
        sudo dpkg --install "${deb_file}"

        # Clean up downloaded and converted files
        rm "${rpm_file}" "${deb_file}"
    done

    echo "Installation of Nmap, Ncat, and Nping is complete."
}

# Execution
massdnsinstall
pd_all
rustscan1
install_nmap_tools
