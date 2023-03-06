#!/bin/bash

# Get the list of instances with a "running" status
instances=$(aws ec2 describe-instances --filters "Name=instance-state-name,Values=running" --query "Reservations[*].Instances[*].{Name:PublicDnsName}" --output=text)

# Check if there is at least one running instance
if [[ -n "$instances" ]]; then
    # If there is, print the public DNS name of the first instance found
    echo "$instances" | head -n 1
else
    # If there is none, create a new instance
    instance=$(aws ec2 run-instances --image-id ami-0c94855ba95c71c99 --count 1 --instance-type t2.micro --key-name mykey --security-group-ids sg-xxxxxxxx --subnet-id subnet-xxxxxxxx --associate-public-ip-address --query "Instances[0].{Name:PublicDnsName}" --output=text)

    # Print the public DNS name of the newly created instance
    echo "$instance"
fi
