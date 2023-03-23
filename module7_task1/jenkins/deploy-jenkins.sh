#!/bin/bash

# Read the IP address from the file
new_ec2_instance_public_ip=$(cat new_ec2_instance_public_ip.txt)

# Copy the keys here, since we'll use it with the dockerfiles
cp ~/.ssh/awesome-key.pub ./jenkins/
cp ~/.ssh/awesome-key.pem ./jenkins/

# scp -o StrictHostKeyChecking=accept-new ./jenkins/awesome-key.pub ubuntu@"$new_ec2_instance_public_ip":/home/ubuntu/.ssh/
# scp -o StrictHostKeyChecking=accept-new ./jenkins/awesome-key.pem ubuntu@"$new_ec2_instance_public_ip":/home/ubuntu/.ssh/

# ssh -o StrictHostKeyChecking=accept-new -o ConnectTimeout=60 ubuntu@"$1" "
# 	chmod 600 /home/ubuntu/.ssh/awesome-key.pem
# "

docker context create jenkins --docker "host=ssh://ubuntu@$new_ec2_instance_public_ip"
docker context use jenkins

# docker pull tsuroo/jenkins
# docker pull tsuroo/jenkins-agent
# docker compose -f ./jenkins/docker-compose.yml up --detach jenkins

# Navigate into the jenkins directory
cd ./jenkins

docker compose up --detach

# # Remove the key
rm awesome-key.pub
rm awesome-key.pem

docker context use default
