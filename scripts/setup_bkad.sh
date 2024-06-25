#!/bin/bash

# Ensure the script is run as root
if [ "$(id -u)" -ne 0 ]; then
  echo "This script must be run as root"
  exit 1
fi

# Check if the scripts directory exists
if [ ! -d "scripts" ]; then
  echo "scripts directory not found."
  exit 1
fi

# Run installation and setup scripts if they exist
if [ -f "scripts/install_ipfs.sh" ]; then
  bash scripts/install_ipfs.sh
else
  echo "install_ipfs.sh not found."
  exit 1
fi

if [ -f "scripts/setup_autostart.sh" ]; then
  bash scripts/setup_autostart.sh
else
  echo "setup_autostart.sh not found."
  exit 1
fi

# Make sure all scripts are executable
chmod +x scripts/ingest_pin.sh
chmod +x scripts/install_ipfs.sh
chmod +x scripts/setup_autostart.sh

echo "BKAD setup complete. Please reboot the system."

