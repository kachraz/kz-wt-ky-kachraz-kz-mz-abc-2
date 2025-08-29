#!/usr/bin/bash
# Cargo and rust auto
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

# Pulling the ackee container
dok_ack() {
    hea1 "Pull ackee Docker Container"
    c1="docker pull ackeeblockchain/school-of-solana-arm:latest"
    c2="docker run -it --name school-of-solana \
  -p 8899:8899 -p 9900:9900 -p 8000:8000 -p 8080:8080 \
  -v /workspaces/wt-ky-kachraz-kz-mz-abc-2/WX/STU:/panty \
  ackeeblockchain/school-of-solana:latest"
    echo -e "${GREEN} Executing ${c1}${NC}"
    eval "$c1"
    echo -e "${GREEN} Executing ${c2}${NC}"
    eval "$c2"
}

dc_cl() {
    echo "This will remove ALL Docker containers, images, volumes, and networks. Continue? (y/N)"
    read -r response
    if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
        echo "Stopping all containers..."
        docker stop $(docker ps -qa) 2>/dev/null || true

        echo "Removing all containers..."
        docker rm $(docker ps -qa) 2>/dev/null || true

        echo "Removing all images..."
        docker rmi $(docker images -qa) 2>/dev/null || true

        echo "Removing all volumes..."
        docker volume rm $(docker volume ls -q) 2>/dev/null || true

        echo "Removing all networks..."
        docker network rm $(docker network ls -q) 2>/dev/null || true

        echo "Docker cleanup complete."
    else
        echo "Operation cancelled."
    fi
}


# Execute
dc_cl
dok_ack