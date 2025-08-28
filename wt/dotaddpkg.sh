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
headerz() {
    echo -e "${CYAN}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
    echo -e "${PURPLE}$1${NC}"
    echo -e "${CYAN}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
}

# Packages installer
nu_pkg_install() {
    headerz "Installing NuGet Packages"
    echo -e "${YELLOW}Installing NuGet Packages..."
    echo -e "Pastel = Color Terminal"
    echo -e "Newtonsoft.Json = Serialize JSON$"
    echo -e "LiteDB = Embedded DB written in C#${NC}"

    PACKAGES=(
        "Newtonsoft.Json --version 13.0.3"
        "Pastel --version 6.0.1"
        "LiteDB --version 5.0.21"
    )

    for package in "${PACKAGES[@]}"; do
        echo -e "${GREEN}Installing $package${NC}"
        dotnet add package $package
        if [ $? -ne 0 ]; then
            echo "Error installing $package"
            exit 1
        fi
    done

    dotnet list package

}

# Execution
nu_pkg_install
