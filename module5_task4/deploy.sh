#!/bin/bash

# Read the IP address from the file
new_ec2_instance_public_ip=$(cat new_ec2_instance_public_ip.txt)

# Read the name of the tag to use with the docker image
dockerImageTag=$(cat awesome_image_tag_name.txt)

docker context create production --docker "host=ssh://ubuntu@$new_ec2_instance_public_ip"
docker context use production

docker pull bbrown585/awesome-web:"$dockerImageTag"
docker compose up --detach awesome-web