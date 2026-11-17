# Homelab

Everything related to my Homelab and virtualized environments, including container configurations, VM templates and more.

I'm still figuring out how to make here pretty enough, so consider this repo a **WIP** for now.

## Inventory

Proxmox VE 9.2 on `pve.home.lan`.

| ID  | Type | Host     | IP           | Managed by                         | Services                                                                                       |
| --- | ---- | -------- | ------------ | ---------------------------------- | ---------------------------------------------------------------------------------------------- |
| 100 | VM   | proxy    | 192.168.1.51 | compose (`~/homelab`)              | nginx-proxy-manager, watchtower                                                                |
| 101 | LXC  | homepage | 192.168.1.52 | systemd (`/opt/homepage`)          | homepage (config in `homepage/config`)                                                         |
| 102 | VM   | template | -            | -                                  | stopped, base template                                                                         |
| 103 | VM   | vault    | 192.168.1.53 | systemd                            | NFS server                                                                                     |
| 104 | VM   | crafty   | 192.168.1.54 | compose (`~/homelab`)              | crafty-controller, docker-socket-proxy, watchtower                                             |
| 105 | VM   | servarr  | 192.168.1.55 | Portainer stacks                   | arr (qbittorrent, nzbget, prowlarr, sonarr, radarr, bazarr, deunhealth), metube, navidrome, watchtower, apple-music-downloader* |
| 106 | VM   | docker   | 192.168.1.56 | Portainer stacks                   | grafana, influxdb-v2, speedtest-tracker, watchtower                                            |
| 107 | LXC  | jellyfin | 192.168.1.57 | systemd                            | jellyfin                                                                                       |

\* not tracked in this repo.

Not currently deployed: `filebrowser`, `influxdb-v1`, `homepage/docker-compose.yml` (homepage runs natively in its LXC).

## Setup new VM

```sh
bash <(curl -s https://raw.githubusercontent.com/mathcale/homelab/refs/heads/main/scripts/setup-vm.sh)
```
