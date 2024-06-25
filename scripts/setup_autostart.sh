#!/bin/bash

# Ensure the script is run as root
if [ "$(id -u)" -ne 0 ]; then
  echo "This script must be run as root"
  exit 1
fi

# Variables
IPFS_USER="bitk1"
AUTOSTART_DIR="/home/$IPFS_USER/.config/lxsession/LXDE-pi"
AUTOSTART_FILE="$AUTOSTART_DIR/autostart"

# Install Chromium if not already installed
apt-get install -y chromium-browser

# Set Chromium to launch IPFS web UI on boot
mkdir -p $AUTOSTART_DIR
echo "@chromium-browser --kiosk http://localhost:5001/webui" > $AUTOSTART_FILE
chown -R $IPFS_USER:$IPFS_USER $AUTOSTART_DIR

echo "Autostart setup complete."

