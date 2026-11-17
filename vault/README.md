# vault

NFS server for media and downloads. Ubuntu 26.04 VM (`103`, `vault.home.lan`, 192.168.1.53).

## VM

- 2 cores, 2 GB RAM, 30 GB boot disk on `local-lvm`
- `hostpci0: 0000:00:17.0` - the host's Intel SATA AHCI controller is passed through, so the data disk shows up as `/dev/sdb` inside the VM
- `startup: order=1,up=30` - boots first so NFS is up before the clients

## Server setup

On a fresh VM (after [`scripts/setup-vm.sh`](../scripts/setup-vm.sh) or just `git clone`):

```sh
sudo ./vault/setup.sh [DATA_DISK_UUID]
```

It installs `nfs-kernel-server`, mounts the data disk at `/mnt/data` ([`fstab`](fstab)), creates the folders below owned by `ubuntu:ubuntu` (1000:1000), installs [`exports`](exports) and applies [`nfs.conf`](nfs.conf).

```
/mnt/data
├── animes            (not exported)
├── downloads         qbittorrent
│   └── youtube       metube
├── movies            radarr, jellyfin
├── music             navidrome, jellyfin, apple-music-downloader
├── nzbget
│   ├── completed/{Movies,Music,Series}
│   ├── intermediate
│   ├── nzb
│   ├── queue
│   └── tmp
└── tvshows           sonarr, jellyfin
```

Every share is exported to `192.168.1.0/24` with `no_root_squash` and anon mapped to 1000:1000.

## Clients

| Client                | How                                         | Files                                                         |
| --------------------- | ------------------------------------------- | ------------------------------------------------------------- |
| servarr (105)         | autofs, all shares under `/mnt/nfs/<share>` | [`auto.master`](clients/auto.master), [`auto.nfs`](clients/auto.nfs) |
| Proxmox host          | fstab + systemd automount at `/mnt/nfs-vault` | [`pve-fstab`](clients/pve-fstab)                            |
| jellyfin (107, LXC)   | bind mounts from the host's `/mnt/nfs-vault` | [`jellyfin-lxc.conf`](clients/jellyfin-lxc.conf)             |
