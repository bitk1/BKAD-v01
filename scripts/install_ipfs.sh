#!/bin/bash

# Ensure the script is run as root
if [ "$(id -u)" -ne 0 ]; then
  echo "This script must be run as root"
  exit 1
fi

# Variables
IPFS_USER="bitk1"
IPFS_PATH="/home/$IPFS_USER/.ipfs"
IPFS_SERVICE="/etc/systemd/system/ipfs.service"

# Install prerequisites
apt-get update
apt-get install -y wget tar

# Download and install IPFS
wget https://dist.ipfs.io/go-ipfs/v0.11.0/go-ipfs_v0.11.0_linux-arm.tar.gz
tar -xvzf go-ipfs_v0.11.0_linux-arm.tar.gz
cd go-ipfs
./install.sh

# Initialize IPFS for the specified user
sudo -u $IPFS_USER ipfs init

# Create a systemd service for IPFS
cat <<EOT > $IPFS_SERVICE
[Unit]
Description=IPFS daemon
After=network.target

[Service]
User=$IPFS_USER
Environment=IPFS_PATH=$IPFS_PATH
ExecStart=/usr/local/bin/ipfs daemon
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOT

# Reload systemd and enable IPFS service
systemctl daemon-reload
systemctl enable ipfs
systemctl start ipfs

echo "IPFS installation and setup complete."

