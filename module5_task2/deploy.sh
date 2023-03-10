#!/bin/bash

# Read the IP address from the file
ip_address=$(cat ip_address.txt)

# Read the name of the tag to use with the docker image
dockerImageTag=$(cat awesome_image_tag_name.txt)

scp -o StrictHostKeyChecking=accept-new ./awesome.tar.zip ubuntu@"$ip_address":/home/ubuntu/

ssh -o StrictHostKeyChecking=accept-new ubuntu@"$ip_address" "
	unzip ./awesome.tar.zip
	docker load --input awesome.tar
	docker run --detach -p 80:9999 -p 443:9999 --restart='always' awesome:$dockerImageTag
"