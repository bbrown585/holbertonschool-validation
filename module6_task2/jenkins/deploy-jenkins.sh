#!/bin/bash

# Read the IP address from the file
new_ec2_instance_public_ip=$(cat new_ec2_instance_public_ip.txt)

docker context create jenkins --docker "host=ssh://ubuntu@$new_ec2_instance_public_ip"
docker context use jenkins

docker pull tsuroo/jenkins
docker compose -f ./jenkins/docker-compose.yml up --detach jenkins

docker context use default
