#!/bin/bash

# Create the EC2 instance and print the public IP address
aws ec2 run-instances \
	--image-id ami-0568936c8d2b91c4e \
	--instance-type t2.micro \
	--subnet-id subnet-0a17a3ab697932061   \
	--security-group-ids sg-0c059db4243c157f6 \
	--key-name awesome-key \
	--query 'Instances[*].InstanceId' \
	--output text \
| xargs -I {} aws ec2 describe-instances \
	--instance-ids {} \
	--query 'Reservations[*].Instances[*].PublicIpAddress' \
	--output text 