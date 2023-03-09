#!/bin/bash

# Send commands to the server
# Update the apt registry: sudo apt update
# Upgrade all installed software: sudo apt upgrade -y
# Install Docker: sudo apt install docker.io -y
# Start Docker: sudo systemctl start docker
# Make Docker start on boot of the system: sudo systemctl enable docker
# Add the ubuntu user to the docker group - this will let us use ssh to communicate with docker from a client: sudo usermod -aG docker ubuntu
ssh -o StrictHostKeyChecking=accept-new -i ~/.ssh/awesome-key.pem ubuntu@"$1" "
	sudo apt update
	sudo apt upgrade -y
	sudo apt install docker.io -y
	sudo systemctl start docker
	sudo systemctl enable docker
	sudo usermod -aG docker ubuntu
"