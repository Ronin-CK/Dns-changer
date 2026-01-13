# DNS Changer

A lightweight interactive Bash script for Linux that allows you to **view and change system DNS servers** using NetworkManager (`nmcli`).  
Designed for simplicity, transparency, and quick DNS switching without editing config files manually.

---

## Features

- Detects the active network device and connection automatically
- Displays currently active DNS servers with provider names
- Quickly switch between popular public DNS providers:
  - Google
  - Cloudflare
  - Quad9
  - OpenDNS
  - AdGuard
- Supports custom DNS input
- Applies changes immediately by restarting the active connection
- No external dependencies beyond NetworkManager

---

## Requirements

- Linux system using **NetworkManager**
- `nmcli` available (usually preinstalled on most desktop distros)
- Root privileges (`sudo`)

This script will **not work** on systems that do not use NetworkManager  
(e.g. systems managed purely by `systemd-resolved`, `netplan` without NM, or minimal servers).

---

## Installation

Clone the repository:

```bash
git clone https://github.com/Ronin-CK/Dns-changer.git
cd Dns-changer
```
### Make the script executable:
```bash
chmod +x dns-changer.sh
```

### Usage

Run the script as root:
```bash
sudo ./dns-changer.sh
```
## Safety Notes

  - DNS changes are system-wide

  - Changes persist until modified again

  - Incorrect DNS values may break network connectivity

  - Always ensure you know how to revert changes (rerun the script or reset to automatic)
