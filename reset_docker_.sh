#!/bin/bash
# Author: maxhaase@gmail.com
##############################################################################################
# Displays a confirmation prompt in red. If you type "yes", it will proceed to reset Docker by
# stopping all containers, removing containers, images, volumes, and networks. If you type
# anything else, it will abort the operation and display a message indicating that no changes
# were made. Use with caution! 

# How to Use the Script:

# Make the Script Executable:
# chmod +x reset_docker_.sh

# Run the Script:
# ./reset_docker_.sh
##############################################################################################


# Function to display messages in red
function echo_red() {
    echo -e "\e[31m$1\e[0m"
}

# Prompt the user for confirmation
echo_red "Are you sure you wish to reset docker on your computer?\nType yes if you want all your docker images and any work you've done removed!"
read -r confirmation

# Check the user's response
if [[ "$confirmation" == "yes" ]]; then
    # Stop all running Docker containers
    docker stop $(docker ps -aq)

    # Remove all Docker containers
    docker rm $(docker ps -aq)

    # Remove all Docker images
    docker rmi -f $(docker images -q)

    # Remove all Docker volumes
    docker volume rm $(docker volume ls -q)

    # Remove all Docker networks
    docker network rm $(docker network ls -q)

    # Remove any dangling resources
    docker system prune -af
    docker volume prune -f
    docker network prune -f

    echo "Docker reset complete."
else
    echo "Operation aborted. No changes were made."
fi
