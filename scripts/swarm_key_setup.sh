#!/bin/bash

# Ensure the script is run as root
if [ "$(id -u)" -ne 0; then
  echo "This script must be run as root"
  exit 1
fi

# Generate a unique swarm key
SWARM_KEY=$(openssl rand -base64 32)

# IPFS swarm key file
SWARM_KEY_FILE="/home/bitk1/.ipfs/swarm.key"

# Create swarm key file
echo -e "/key/swarm/psk/1.0.0/\n/base16/\n$SWARM_KEY" > $SWARM_KEY_FILE

# Set appropriate permissions
chown bitk1:bitk1 $SWARM_KEY_FILE
chmod 600 $SWARM_KEY_FILE

echo "Swarm key setup complete."

