#!/bin/bash

# Ensure the script is run as root
if [ "$(id -u)" -ne 0; then
  echo "This script must be run as root"
  exit 1
fi

# Variables
IPFS_USER="bitk1"
IPFS_PATH="/home/$IPFS_USER/.ipfs"
IPFS_SERVICE="/etc/systemd/system/ipfs.service"
AUTOSTART_DIR="/home/$IPFS_USER/.config/lxsession/LXDE-pi"
AUTOSTART_FILE="$AUTOSTART_DIR/autostart"
DESKTOP_DIR="/home/$IPFS_USER/Desktop"
WEBUI_SHORTCUT="$DESKTOP_DIR/ipfs_webui.desktop"

# Install prerequisites
apt-get update
apt-get install -y wget tar chromium-browser jq xinput-calibrator

# Download and install IPFS
wget https://dist.ipfs.io/go-ipfs/v0.11.0/go-ipfs_v0.11.0_linux-arm.tar.gz
tar -xvzf go-ipfs_v0.11.0_linux-arm.tar.gz
cd go-ipfs
./install.sh

# Initialize IPFS for the specified user
sudo -u $IPFS_USER ipfs init

# Generate a unique swarm key
SWARM_KEY=$(openssl rand -base64 32)

# IPFS swarm key file
SWARM_KEY_FILE="/home/$IPFS_USER/.ipfs/swarm.key"

# Create swarm key file
echo -e "/key/swarm/psk/1.0.0/\n/base16/\n$SWARM_KEY" > $SWARM_KEY_FILE

# Set appropriate permissions
chown $IPFS_USER:$IPFS_USER $SWARM_KEY_FILE
chmod 600 $SWARM_KEY_FILE

# Update IPFS configuration
sudo -u $IPFS_USER jq '.Addresses.API = "/ip4/0.0.0.0/tcp/5001"' $IPFS_PATH/config > $IPFS_PATH/config.tmp && mv $IPFS_PATH/config.tmp $IPFS_PATH/config
sudo -u $IPFS_USER jq '.Addresses.Gateway = "/ip4/0.0.0.0/tcp/8080"' $IPFS_PATH/config > $IPFS_PATH/config.tmp && mv $IPFS_PATH/config.tmp $IPFS_PATH/config
sudo -u $IPFS_USER jq '.API.HTTPHeaders = {
  "Access-Control-Allow-Origin": ["http://192.168.1.103:5001", "http://localhost:3000", "http://127.0.0.1:5001", "https://webui.ipfs.io"],
  "Access-Control-Allow-Methods": ["PUT", "POST"]
}' $IPFS_PATH/config > $IPFS_PATH/config.tmp && mv $IPFS_PATH/config.tmp $IPFS_PATH/config

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

# Configure Chromium to start on boot
mkdir -p $AUTOSTART_DIR
echo "@chromium-browser --kiosk http://localhost:5001/webui --noerrdialogs --disable-infobars --explicitly-allowed-ports=5001 --check-for-update-interval=31536000" > $AUTOSTART_FILE
chown -R $IPFS_USER:$IPFS_USER $AUTOSTART_DIR

# Ensure the autostart file is executable
chmod +x $AUTOSTART_FILE

# Add shortcut to IPFS Web UI on desktop
mkdir -p $DESKTOP_DIR
cat <<EOT > $WEBUI_SHORTCUT
[Desktop Entry]
Name=IPFS Web UI
Comment=Access the IPFS Web UI
Exec=chromium-browser http://localhost:5001/webui --explicitly-allowed-ports=5001
Icon=web-browser
Terminal=false
Type=Application
Categories=Network;WebBrowser;
EOT
chown -R $IPFS_USER:$IPFS_USER $WEBUI_SHORTCUT
chmod +x $WEBUI_SHORTCUT

# Calibrate touchscreen
xinput-calibrator

# Ensure /etc/hosts file has correct localhost entry
grep -q -F '127.0.0.1 localhost' /etc/hosts || echo '127.0.0.1 localhost' >> /etc/hosts
grep -q -F '::1 localhost' /etc/hosts || echo '::1 localhost' >> /etc/hosts

echo "BKAD setup complete. Please reboot the system."

