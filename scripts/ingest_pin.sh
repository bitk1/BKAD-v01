#!/bin/bash
# Script to ingest and pin IPFS files from an external hard drive

EXTERNAL_DRIVE_MOUNT_POINT="/mnt/external"
IPFS_PATH="$EXTERNAL_DRIVE_MOUNT_POINT/ipfs"

if [ -d "$IPFS_PATH" ]; then
    for FILE in "$IPFS_PATH"/*; do
        ipfs add -r "$FILE"
    done
fi

