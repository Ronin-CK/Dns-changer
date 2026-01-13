# DNS Changer 🌐

A lightweight, interactive Bash script for Linux that allows you to **view and change system DNS servers** using NetworkManager (`nmcli`).
Designed for simplicity, transparency, and quick DNS switching without manually editing configuration files.

![Bash](https://img.shields.io/badge/Language-Bash-4EAA25.svg?logo=gnu-bash&logoColor=white)
![Linux](https://img.shields.io/badge/OS-Linux-FCC624.svg?logo=linux&logoColor=black)
![NetworkManager](https://img.shields.io/badge/Dependency-NetworkManager-blue)

---

## ✨ Features

* **Auto-Detection:** Automatically identifies the active network device and current connection.
* **Live Status:** Displays currently active DNS servers and provider names.
* **Quick Switcher:** Instantly apply popular public DNS providers:
    * Google
    * Cloudflare
    * Quad9
    * OpenDNS
    * AdGuard
* **Custom Control:** Supports manual entry for custom DNS IPs.
* **Zero Bloat:** No external dependencies beyond `nmcli`.

---

## ⚠️ Requirements

* A Linux system using **NetworkManager**.
* `nmcli` installed (standard on most desktop distros like Fedora, Ubuntu, Arch, etc.).
* Root privileges (`sudo`).

> **Note:** This script will **not work** on systems managed purely by `systemd-resolved`, `netplan` (without NM), or minimal server environments lacking NetworkManager.

---

## 🚀 Installation

1.  **Clone the repository:**
    ```bash
    git clone [https://github.com/Ronin-CK/Dns-changer.git](https://github.com/Ronin-CK/Dns-changer.git)
    cd Dns-changer
    ```

2.  **Make the script executable:**
    ```bash
    chmod +x dns-changer.sh
    ```

---

## 🎮 Usage

Run the script with root privileges to allow network modification:

```bash
sudo ./dns-changer.sh
