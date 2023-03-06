#!/bin/bash

# Check if an argument was passed
if [[ $# -eq 0 ]]; then
    echo "Error: Remote server address not provided."
    exit 1
fi

# Get the remote server address
server=$1

# Check if SSH connection is possible
if ! ssh -o "BatchMode yes" ubuntu@"$server" exit >/dev/null 2>&1; then
    echo "Error: Unable to connect to remote server with SSH."
    exit 1
fi

# Install Docker if it is not installed
if ! ssh ubuntu@"$server" "which docker" >/dev/null 2>&1; then
    ssh ubuntu@"$server" "sudo apt-get update && sudo apt-get install -y docker.io"
fi

# Check Docker version
docker_version=$(ssh ubuntu@"$server" "docker -v | cut -d ' ' -f 3")
if [[ "$docker_version" != "20.10"* ]]; then
    ssh ubuntu@"$server" "sudo apt-get update && sudo apt-get install -y docker.io"
fi

# Update all packages
ssh ubuntu@"$server" "sudo apt-get update && sudo apt-get upgrade -y"

# Add user ubuntu to the docker group
ssh ubuntu@"$server" "sudo usermod -aG docker ubuntu"

# Test if the user can execute docker commands
if ! ssh ubuntu@"$server" "docker info" >/dev/null 2>&1; then
    echo "Error: Unable to execute Docker commands with user ubuntu."
    exit 1
fi
