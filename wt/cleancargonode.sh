#!/usr/bin/bash
# Cargo, Rust, and Docker helper
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

# Header function
hea1() {
    echo -e "${CYAN}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
    echo -e "${PURPLE}$1${NC}"
    echo -e "${CYAN}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
}

# Make a new project
cargo_new() {
    hea1 "Cargo New Initialization with yansi and cfonts"
    echo -e "${WHITE}Enter the name of the project:${NC} "
    read -r name_of_project
    if [ -z "$name_of_project" ]; then
        echo -e "${RED}Project name cannot be empty!${NC}"
        exit 1
    fi

    echo -e "\n${GREEN}---Commands to execute:---${NC}"
    echo -e "  > cargo new $name_of_project"
    echo -e "  > cd $name_of_project"
    echo -e "  > cargo add yansi cfonts"
    echo -e "  > cargo tree"
    echo -e "${YELLOW}Executing...${NC}\n"

    eval "cargo new \"$name_of_project\""
    cd "$name_of_project" || exit 1
    cargo add yansi cfonts
    cargo tree
    
    echo -e "\n${GREEN}Project created successfully!${NC}"
}

# Remove all targets, node_modules, and .anchor
cargo_remove_target() {
    hea1 "Recursive Project Cleanup"

    # Remove Rust targets
    local co1='find . -name "Cargo.toml" -execdir cargo clean \;'
    echo -e "${GREEN}Executing:${NC} $co1"
    eval "$co1"

    # Remove node_modules
    local co2='find . -type d -name "node_modules" -prune -exec rm -rf {} +'
    echo -e "${GREEN}Executing:${NC} $co2"
    eval "$co2"

    # Remove .anchor directories
    local co3='find . -type d -name ".anchor" -prune -exec rm -rf {} +'
    echo -e "${GREEN}Executing:${NC} $co3"
    eval "$co3"

    echo -e "\n${GREEN}Cleanup completed!${NC}"
}

# Docker nuker (prunes everything)
docker_nuke() {
    hea1 "Docker Full Cleanup"

    echo -e "${RED}⚠️ WARNING: This will remove ALL Docker containers, images, volumes, networks, and caches.${NC}"
    echo -ne "${YELLOW}Are you sure? (y/N): ${NC}"
    read ans
    if [[ "$ans" != "y" && "$ans" != "Y" ]]; then
        echo -e "${CYAN}Aborted.${NC}"
        return 1
    fi

    echo -e "${GREEN}Removing all containers...${NC}"
    docker rm -f $(docker ps -aq) 2>/dev/null || true

    echo -e "${GREEN}Removing all images...${NC}"
    docker rmi -f $(docker images -q) 2>/dev/null || true

    echo -e "${GREEN}Removing all volumes...${NC}"
    docker volume rm -f $(docker volume ls -q) 2>/dev/null || true

    echo -e "${GREEN}Removing all networks (except defaults)...${NC}"
    docker network rm $(docker network ls -q) 2>/dev/null || true

    echo -e "${GREEN}Pruning builder cache...${NC}"
    docker builder prune -af || true

    echo -e "\n${GREEN}✅ Docker cleanup complete!${NC}"
}


# Display menu
show_menu() {
    clear
    hea1 "Rust & Docker Project Manager"
    echo -e "${BLUE}1)${NC} Create New Cargo Project"
    echo -e "${BLUE}2)${NC} Clean All Target Directories"
    echo -e "${BLUE}3)${NC} Docker Nuke (Prune Everything)"
    echo -e "${BLUE}4)${NC} Exit"
    echo -e "${CYAN}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
    echo -ne "${WHITE}Choose an option [1-4]: ${NC}"
}

# Main execution
show_menu
read -r choice
case $choice in
    1)
        cargo_new
        ;;
    2)
        cargo_remove_target
        ;;
    3)
        docker_nuke
        ;;
    4)
        echo -e "${GREEN}Goodbye!${NC}"
        exit 0
        ;;
    *)
        echo -e "${RED}Invalid option. Exiting.${NC}"
        exit 1
        ;;
esac

echo -e "\n${YELLOW}Press any key to exit...${NC}"
read -n 1 -s
