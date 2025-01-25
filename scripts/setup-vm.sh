#!/usr/bin/env bash

set -e
SECONDS=0

echo "Ubuntu/Debian VM setup script"

echo "==> Updating packages..."

sudo apt update
sudo apt upgrade -y
sudo apt dist-upgrade -y
sudo apt autoremove -y

echo ""
echo "==> Installing must-have packages..."

sudo apt install -y build-essential curl git wget btop vim

echo ""
echo "==> Installing Docker..."

curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

rm get-docker.sh

echo ""
echo "==> Adding current user to 'docker' group..."

sudo usermod -aG docker $USER

echo ""
echo "==> Cloning 'mathcale/homelab'..."

git clone https://github.com/mathcale/homelab.git

echo "Done in ${SECONDS}s!"
