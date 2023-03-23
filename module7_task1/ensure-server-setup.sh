#!/bin/bash

# Get the instance with this public IP address
ec2InstanceId=$(aws ec2 describe-instances --filters "Name=ip-address,Values=$1" --query "Reservations[*].Instances[*].InstanceId" --output text)

# Wait on this ec2 instance to be ready before trying to SSH into it
aws ec2 wait instance-running --instance-ids $ec2InstanceId

# Add this server as a known host
until ssh-keyscan -H "$1" >> ~/.ssh/known_hosts; do
	sleep 5
done

# Send commands to the server
# Update the apt registry: sudo apt update
# Upgrade all installed software: sudo apt upgrade -y
# Install Docker: sudo apt install docker.io -y
# Start Docker: sudo systemctl start docker
# Make Docker start on boot of the system: sudo systemctl enable docker
# Add the ubuntu user to the docker group - this will let us use ssh to communicate with docker from a client: sudo usermod -aG docker ubuntu

until ssh -o ConnectTimeout=180 ubuntu@"$1" "
	sudo apt update
	sudo apt upgrade -y
	sudo apt install -y docker.io make
	sudo systemctl start docker
	sudo systemctl enable docker
	sudo usermod -aG docker ubuntu
"; do
	sleep 5
done

# Save the EC2 instance IP address for other scripts to use
echo "$1" > new_ec2_instance_public_ip.txt
