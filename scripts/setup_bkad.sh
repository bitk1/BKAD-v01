#!/bin/bash

# Ensure the script is run as root
if [ "$(id -u)" -ne 0 ]; then
  echo "This script must be run as root"
  exit 1
fi

# Run installation and setup scripts
bash scripts/install_ipfs.sh
bash scripts/setup_autostart.sh

# Make sure all scripts are executable
chmod +x scripts/ingest_pin.sh
chmod +x scripts/install_ipfs.sh
chmod +x scripts/setup_autostart.sh

echo "BKAD setup complete. Please reboot the system."

