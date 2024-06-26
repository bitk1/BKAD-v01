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
AUTOSTART_DIR="/home/$IPFS_USER/.config/lxsession/LXDE-pi"
AUTOSTART_FILE="$AUTOSTART_DIR/autostart"

# Install prerequisites
apt-get update
apt-get install -y wget tar chromium-browser jq

# Download and install IPFS
wget https://dist.ipfs.io/go-ipfs/v0.11.0/go-ipfs_v0.11.0_linux-arm.tar.gz
tar -xvzf go-ipfs_v0.11.0_linux-arm.tar.gz
cd go-ipfs
./install.sh

# Initialize IPFS for the specified user
sudo -u $IPFS_USER ipfs init

# Update IPFS configuration
cat <<EOT > $IPFS_PATH/config
{
  "Identity": {
    "PeerID": "12D3KooWSMBFo3UnbjmyfvyjzbAhr2NDrBRxgfdHM4gqsvpE7ZpC",
    "PrivKey": "CAESQO9mCSd5yBucQpBJuwKw5IWuY3qfR1Y73IxXhArK9blE9Z+oGAWuLeXC0FEw24hM/3qrChnbqrE+meIqldRquJE="
  },
  "Datastore": {
    "StorageMax": "10GB",
    "StorageGCWatermark": 90,
    "GCPeriod": "1h",
    "Spec": {
      "mounts": [
        {
          "child": {
            "path": "blocks",
            "shardFunc": "/repo/flatfs/shard/v1/next-to-last/2",
            "sync": true,
            "type": "flatfs"
          },
          "mountpoint": "/blocks",
          "prefix": "flatfs.datastore",
          "type": "measure"
        },
        {
          "child": {
            "compression": "none",
            "path": "datastore",
            "type": "levelds"
          },
          "mountpoint": "/",
          "prefix": "leveldb.datastore",
          "type": "measure"
        }
      ],
      "type": "mount"
    },
    "HashOnRead": false,
    "BloomFilterSize": 0
  },
  "Addresses": {
    "Swarm": [
      "/ip4/0.0.0.0/tcp/4001",
      "/ip6/::/tcp/4001",
      "/ip4/0.0.0.0/udp/4001/quic",
      "/ip6/::/udp/4001/quic"
    ],
    "Announce": [],
    "AppendAnnounce": [],
    "NoAnnounce": [],
    "API": "/ip4/0.0.0.0/tcp/5001",
    "Gateway": "/ip4/0.0.0.0/tcp/8080"
  },
  "Mounts": {
    "IPFS": "/ipfs",
    "IPNS": "/ipns",
    "FuseAllowOther": false
  },
  "Discovery": {
    "MDNS": {
      "Enabled": true,
      "Interval": 10
    }
  },
  "Routing": {
    "Type": "dht"
  },
  "Ipns": {
    "RepublishPeriod": "",
    "RecordLifetime": "",
    "ResolveCacheSize": 128
  },
  "Bootstrap": [
    "/ip4/104.131.131.82/tcp/4001/p2p/QmaCpDMGvV2BGHeYERUEnRQAwe3N8SzbUtfsmvsqQLuvuJ",
    "/ip4/104.131.131.82/udp/4001/quic/p2p/QmaCpDMGvV2BGHeYERUEnRQAwe3N8SzbUtfsmvsqQLuvuJ",
    "/dnsaddr/bootstrap.libp2p.io/p2p/QmNnooDu7bfjPFoTZYxMNLWUQJyrVwtbZg5gBMjTezGAJN",
    "/dnsaddr/bootstrap.libp2p.io/p2p/QmQCU2EcMqAqQPR2i9bChDtGNJchTbq5TbXJJ16u19uLTa",
    "/dnsaddr/bootstrap.libp2p.io/p2p/QmbLHAnMoJPWSCR5Zhtx6BHJX9KiKNN6tpvbUcqanj75Nb",
    "/dnsaddr/bootstrap.libp2p.io/p2p/QmcZf59bWwK5XFi76CZX8cbJ4BhTzzA3gU1ZjYZcYW3dwt"
  ],
  "Gateway": {
    "HTTPHeaders": {
      "Access-Control-Allow-Headers": [
        "X-Requested-With",
        "Range",
        "User-Agent"
      ],
      "Access-Control-Allow-Methods": [
        "GET"
      ],
      "Access-Control-Allow-Origin": [
        "*"
      ]
    },
    "RootRedirect": "",
    "Writable": false,
    "PathPrefixes": [],
    "APICommands": [],
    "NoFetch": false,
    "NoDNSLink": false,
    "PublicGateways": null
  },
  "API": {
    "HTTPHeaders": {}
  },
  "Swarm": {
    "AddrFilters": null,
    "DisableBandwidthMetrics": false,
    "DisableNatPortMap": false,
    "RelayClient": {},
    "RelayService": {},
    "Transports": {
      "Network": {},
      "Security": {},
      "Multiplexers": {}
    },
    "ConnMgr": {
      "Type": "basic",
      "LowWater": 600,
      "HighWater": 900,
      "GracePeriod": "20s"
    }
  },
  "AutoNAT": {},
  "Pubsub": {
    "Router": "",
    "DisableSigning": false
  },
  "Peering": {
    "Peers": null
  },
  "DNS": {
    "Resolvers": {}
  },
  "Migration": {
    "DownloadSources": [],
    "Keep": ""
  },
  "Provider": {
    "Strategy": ""
  },
  "Reprovider": {
    "Interval": "12h",
    "Strategy": "all"
  },
  "Experimental": {
    "FilestoreEnabled": false,
    "UrlstoreEnabled": false,
    "GraphsyncEnabled": false,
    "Libp2pStreamMounting": false,
    "P2pHttpProxy": false,
    "StrategicProviding": false,
    "AcceleratedDHTClient": false
  },
  "Plugins": {
    "Plugins": null
  },
  "Pinning": {
    "RemoteServices": {}
  },
  "Internal": {}
}
EOT

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
echo "@chromium-browser --kiosk http://localhost:5001/webui --noerrdialogs --disable-infobars --check-for-update-interval=31536000" > $AUTOSTART_FILE
chown -R $IPFS_USER:$IPFS_USER $AUTOSTART_DIR

# Ensure the autostart file is executable
chmod +x $AUTOSTART_FILE

echo "BKAD setup complete. Please reboot the system."

