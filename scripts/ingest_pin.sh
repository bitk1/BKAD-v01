#!/bin/bash

# Ensure the script is run as root
if [ "$(id -u)" -ne 0 ]; then
  echo "This script must be run as root"
  exit 1
fi

# Variables
IPFS_USER="bitk1"
EXTERNAL_DRIVE_MOUNT_POINT="/mnt/external"
IPFS_PATH="$EXTERNAL_DRIVE_MOUNT_POINT/ipfs"

if [ -d "$IPFS_PATH" ]; then
    for FILE in "$IPFS_PATH"/*; do
        sudo -u $IPFS_USER ipfs add -r "$FILE"
    done
    echo "Ingestion and pinning complete."
else
    echo "IPFS path not found."
fi

