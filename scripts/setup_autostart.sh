#!/bin/bash
# Set up IPFS to start on boot and launch web UI in full-screen mode

# Add IPFS to systemd
echo "[Unit]
Description=IPFS daemon

[Service]
ExecStart=/usr/local/bin/ipfs daemon
Restart=always
User=pi

[Install]
WantedBy=multi-user.target" | sudo tee /etc/systemd/system/ipfs.service

sudo systemctl enable ipfs.service

# Install Chromium if not already installed
sudo apt install -y chromium-browser

# Set Chromium to launch IPFS web UI on boot
mkdir -p ~/.config/lxsession/LXDE-pi
echo "@chromium-browser --kiosk http://localhost:5001/webui" > ~/.config/lxsession/LXDE-pi/autostart

