#!/usr/bin/bash
# This bash script is for setting up a new .NET project or adding a project to an existing solution.

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

# Function to display a header
header() {
    echo -e "${CYAN}=============== "
    echo -e "$1"
    echo -e "===============${NC}"
}

# Function to create a new project and solution
create_new_project_and_solution() {
    echo -e "${GREEN}[-] Enter the name of the new project (default: MyNewProject): ${NC}"
    read -r project_name
    project_name=${project_name:-MyNewProject}

    echo -e "${GREEN}[-] Enter the name of the solution (default: MyNewSolution): ${NC}"
    read -r solution_name
    solution_name=${solution_name:-MyNewSolution}

    # Create the project
    header "Creating new project: $project_name"
    dotnet new console -n "$project_name"
    if [ $? -ne 0 ]; then
        echo -e "${RED}[!] Failed to create project '$project_name' ${NC}"
        return 1
    fi
    echo -e "${GREEN}[+] Project '$project_name' created successfully ${NC}"

    # Create the solution
    header "Creating new solution: $solution_name"
    dotnet new sln -n "$solution_name"
    if [ $? -ne 0 ]; then
        echo -e "${RED}[!] Failed to create solution '$solution_name' ${NC}"
        return 1
    fi
    echo -e "${GREEN}[+] Solution '$solution_name' created successfully ${NC}"

    # Add the project to the solution
    header "Adding project '$project_name' to solution '$solution_name'"
    dotnet sln "$solution_name.sln" add "$project_name/$project_name.csproj"
    if [ $? -ne 0 ]; then
        echo -e "${RED}[!] Failed to add project '$project_name' to solution '$solution_name' ${NC}"
        return 1
    fi
    echo -e "${GREEN}[+] Project '$project_name' added to solution '$solution_name' successfully ${NC}"

    # List the solution contents
    list_solution_contents "$solution_name.sln"
}

# Function to add a new project to an existing solution
add_project_to_existing_solution() {
    echo -e "${GREEN}[-] Enter the name of the new project (default: MyNewProject): ${NC}"
    read -r project_name
    project_name=${project_name:-MyNewProject}

    echo -e "${GREEN}[-] Enter the path to the existing solution file (.sln) (default: ./MyExistingSolution.sln): ${NC}"
    read -r solution_path
    solution_path=${solution_path:-./MyExistingSolution.sln}

    # Check if the solution file exists
    if [ ! -f "$solution_path" ]; then
        echo -e "${RED}[!] Solution file '$solution_path' does not exist.${NC}"
        return 1
    fi

    # Create the new project
    header "Creating new project: $project_name"
    dotnet new console -n "$project_name"
    if [ $? -ne 0 ]; then
        echo -e "${RED}[!] Failed to create project '$project_name' ${NC}"
        return 1
    fi
    echo -e "${GREEN}[+] Project '$project_name' created successfully ${NC}"

    # Add the project to the existing solution
    header "Adding project '$project_name' to solution '$solution_path'"
    dotnet sln "$solution_path" add "$project_name/$project_name.csproj"
    if [ $? -ne 0 ]; then
        echo -e "${RED}[!] Failed to add project '$project_name' to solution '$solution_path' ${NC}"
        return 1
    fi
    echo -e "${GREEN}[+] Project '$project_name' added to solution '$solution_path' successfully ${NC}"

    # List the solution contents
    list_solution_contents "$solution_path"
}

# Function to list the contents of a solution
list_solution_contents() {
    local solution_path=$1
    header "Listing projects in solution: $solution_path"
    dotnet sln "$solution_path" list
    if [ $? -ne 0 ]; then
        echo -e "${RED}[!] Failed to list projects in solution '$solution_path' ${NC}"
        return 1
    fi
}

# Main menu
main_menu() {
    header "Welcome to the .NET Project Setup Script"
    echo -e "${GREEN}[?] Choose an option:"
    echo -e "1) Create a new project and solution"
    echo -e "2) Add a new project to an existing solution"
    echo -e "3) Exit${NC}"
    echo -e "${PURPLE}[*] Enter your choice (1, 2, or 3): ${NC}"
    read -r choice

    case "$choice" in
    1)
        create_new_project_and_solution
        ;;
    2)
        add_project_to_existing_solution
        ;;
    3)
        echo -e "${GREEN}[+] Exiting...${NC}"
        exit 0
        ;;
    *)
        echo -e "${RED}[!] Invalid choice. Please enter 1, 2, or 3.${NC}"
        main_menu
        ;;
    esac
}

# Start the script
main_menu
