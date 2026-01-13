#!/bin/bash

get_dns_name() {
    local ip=$1
    case $ip in
        "8.8.8.8"|"8.8.4.4") echo "Google" ;;
        "1.1.1.1"|"1.0.0.1") echo "Cloudflare" ;;
        "208.67.222.222"|"208.67.220.220") echo "OpenDNS" ;;
        "9.9.9.9"|"149.112.112.112") echo "Quad9" ;;
        "94.140.14.14"|"94.140.15.15") echo "AdGuard" ;;
        *) echo "ISP/Custom/Unknown" ;;
    esac
}
# ----------------------------------------------

# Check if running as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root (use sudo)"
  exit
fi

# Check if nmcli is installed
if ! command -v nmcli &> /dev/null; then
    echo "Error: NetworkManager (nmcli) is not installed on this system."
    exit 1
fi

clear
echo "========================================"
echo "   Linux DNS Changer (NetworkManager)   "
echo "========================================"

# 1. Get Active Connection and Device
ACTIVE_CON=$(nmcli -t -f NAME connection show --active | head -n 1)
ACTIVE_DEV=$(nmcli -t -f DEVICE connection show --active | head -n 1)

if [ -z "$ACTIVE_CON" ]; then
    echo "No active network connection found!"
    exit 1
fi

echo "Detected Connection: $ACTIVE_CON ($ACTIVE_DEV)"

# 2. SHOW CURRENT ACTIVE DNS WITH NAMES
echo "----------------------------------------"
echo "CURRENT ACTIVE DNS:"

# Get raw IPs
RAW_DNS=$(nmcli -f IP4.DNS dev show "$ACTIVE_DEV" | awk '{print $2}')

if [ -z "$RAW_DNS" ]; then
    echo "  System Default (Likely ISP Router)"
else
    # Loop through IPs (in case there are multiple) and identify them
    for ip in $RAW_DNS; do
        NAME=$(get_dns_name "$ip")
        echo "  • $NAME ($ip)"
    done
fi
echo "----------------------------------------"
echo ""

echo "Select a New DNS Provider:"
echo "1) Google (8.8.8.8)"
echo "2) Cloudflare (1.1.1.1)"
echo "3) OpenDNS (208.67.222.222)"
echo "4) Quad9 (9.9.9.9)"
echo "5) AdGuard (94.140.14.14 - Blocks Ads)"
echo "6) Custom (Enter your own)"
echo "7) Revert to Default (ISP)"
echo "8) Exit"
echo ""
read -p "Enter choice [1-8]: " choice

case $choice in
    1)
        DNS_IP="8.8.8.8 8.8.4.4"
        PROVIDER="Google"
        ;;
    2)
        DNS_IP="1.1.1.1 1.0.0.1"
        PROVIDER="Cloudflare"
        ;;
    3)
        DNS_IP="208.67.222.222 208.67.220.220"
        PROVIDER="OpenDNS"
        ;;
    4)
        DNS_IP="9.9.9.9 149.112.112.112"
        PROVIDER="Quad9"
        ;;
    5)
        DNS_IP="94.140.14.14 94.140.15.15"
        PROVIDER="AdGuard"
        ;;
    6)
        read -p "Enter Primary DNS IP: " dns1
        read -p "Enter Secondary DNS IP (optional): " dns2
        DNS_IP="$dns1 $dns2"
        PROVIDER="Custom"
        ;;
    7)
        echo "Reverting to Automatic (ISP/DHCP) DNS..."
        nmcli con mod "$ACTIVE_CON" ipv4.dns ""
        nmcli con mod "$ACTIVE_CON" ipv4.ignore-auto-dns no
        nmcli con down "$ACTIVE_CON" > /dev/null 2>&1
        nmcli con up "$ACTIVE_CON" > /dev/null 2>&1
        echo "Done. DNS is now automatic."
        exit 0
        ;;
    8)
        echo "Exiting..."
        exit 0
        ;;
    *)
        echo "Invalid choice."
        exit 1
        ;;
esac

echo "Setting DNS to $PROVIDER..."

# Apply the new DNS settings
nmcli con mod "$ACTIVE_CON" ipv4.dns "$DNS_IP"
nmcli con mod "$ACTIVE_CON" ipv4.ignore-auto-dns yes

# Restart connection to apply
echo "Applying changes to network..."
nmcli con down "$ACTIVE_CON" > /dev/null 2>&1
nmcli con up "$ACTIVE_CON" > /dev/null 2>&1

echo ""
echo "----------------------------------------"
echo "NEW ACTIVE DNS STATUS:"
NEW_RAW_DNS=$(nmcli -f IP4.DNS dev show "$ACTIVE_DEV" | awk '{print $2}')
for ip in $NEW_RAW_DNS; do
    NAME=$(get_dns_name "$ip")
    echo "  • $NAME ($ip)"
done
echo "----------------------------------------"
