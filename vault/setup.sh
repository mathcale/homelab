#!/usr/bin/env bash
# Sets up the vault VM as the homelab NFS server.
# Usage: sudo ./setup.sh [DATA_DISK_UUID]

set -euo pipefail

DATA_UUID="${1:-326c9605-ff73-4116-80c2-7fa8a7f5b78d}"
DATA_DIR=/mnt/data
OWNER=ubuntu:ubuntu
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

if [[ $EUID -ne 0 ]]; then
  echo "Run as root (sudo)." >&2
  exit 1
fi

echo "==> Installing NFS server..."
apt update
apt install -y nfs-kernel-server

echo "==> Mounting data disk at ${DATA_DIR}..."
mkdir -p "$DATA_DIR"
if ! grep -q "$DATA_UUID" /etc/fstab; then
  printf 'UUID=%s\t%s\text4\tdefaults\t0\t0\n' "$DATA_UUID" "$DATA_DIR" >> /etc/fstab
fi
systemctl daemon-reload
mountpoint -q "$DATA_DIR" || mount "$DATA_DIR"

echo "==> Creating share folders..."
install -d -o "${OWNER%:*}" -g "${OWNER#*:}" -m 755 \
  "$DATA_DIR"/{movies,tvshows,downloads,nzbget}
install -d -o "${OWNER%:*}" -g "${OWNER#*:}" -m 774 "$DATA_DIR/music"
install -d -o "${OWNER%:*}" -g "${OWNER#*:}" -m 775 \
  "$DATA_DIR/animes" \
  "$DATA_DIR/downloads/youtube" \
  "$DATA_DIR"/nzbget/{completed,intermediate,nzb,queue,tmp}
install -d -o "${OWNER%:*}" -g "${OWNER#*:}" -m 755 \
  "$DATA_DIR"/nzbget/completed/{Movies,Music,Series}

echo "==> Configuring NFS exports..."
install -m 644 "$SCRIPT_DIR/exports" /etc/exports
if ! grep -qE '^\s*manage-gids\s*=\s*y' /etc/nfs.conf; then
  sed -i 's/^\[mountd\]$/[mountd]\nmanage-gids=y/' /etc/nfs.conf
fi

systemctl enable --now nfs-server
systemctl restart nfs-server
exportfs -ra
exportfs -v

echo "Done!"
