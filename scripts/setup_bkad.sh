#!/bin/bash
# Master script to set up BKAD

# Run installation and setup scripts
bash install_ipfs.sh
bash setup_autostart.sh

# Make sure all scripts are executable
chmod +x ingest_pin.sh
chmod +x install_ipfs.sh
chmod +x setup_autostart.sh

echo "BKAD setup complete. Please reboot the system."

