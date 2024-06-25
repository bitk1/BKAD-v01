# BKAD-v01

## Introduction
BKAD-v01 (BitKnowledge Archive Device Version 01) is a project to set up a BKAD, which is a small deivice for local digital archiving using IPFS and allowing users to upload and read files using the native IPFS web UI. The device will boot directly to the web UI in full-screen mode and can ingest and pin IPFS files from an external hard drive containing another IPFS node.

## Installation
Follow the steps to set up BKAD-v01 on a BKAD.

### Step BKAD, open a terminal and run the following commands to clone the BKAD repository from GitHub:
```bash
git clone https://github.com/bitk1/BKAD-v01.git
cd BKAD-v01

chmod +x scripts/*.sh

sudo bash scripts/setup_bkad.sh

sudo reboot

## Usage

Access the IPFS Web UI at http://127.0.0.1:5001/webui in a web browser

Ingesting and Pinning Files from External Hard Drive
Connect the hard drive to the BKAD and run:

sudo bash scripts/ingest_pin.sh



## License
This project is licensed under the MIT License.

