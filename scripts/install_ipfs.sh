#!/bin/bash
# Install IPFS on Raspberry Pi
sudo apt update
sudo apt install wget -y
wget https://dist.ipfs.io/go-ipfs/v0.9.1/go-ipfs_v0.9.1_linux-arm.tar.gz
tar -xvzf go-ipfs_v0.9.1_linux-arm.tar.gz
cd go-ipfs
sudo bash install.sh
ipfs init
ipfs config --json API.HTTPHeaders.Access-Control-Allow-Origin '["*"]'
ipfs config --json API.HTTPHeaders.Access-Control-Allow-Methods '["PUT", "POST", "GET"]'

