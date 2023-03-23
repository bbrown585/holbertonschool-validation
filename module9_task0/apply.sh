#!/bin/bash

docker exec module8_task1-puppet-1 mkdir -p /etc/puppetlabs/code/environments/products/manifests
docker cp ./manifests module8_task1-puppet-1:/etc/puppetlabs/code/environments/production/manifests