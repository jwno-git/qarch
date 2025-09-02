#!/bin/bash

# Debian Trixie Minimal Desktop Setup Script
# Run as user jwno from /home/jwno/base_deb directory

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

section() {
    echo -e "${BLUE}[SECTION]${NC} $1"
}

log() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
    exit 1
}

# Check if running as regular user (not root)
if [[ $EUID -eq 0 ]]; then
   error "This script must NOT be run as root. Run as user jwno."
fi

# Check if we're in the correct directory
if [[ "$PWD" != "/home/jwno/base_deb" ]]; then
    error "Script must be run from /home/jwno/base_deb directory"
fi

log "Starting Debian Trixie setup..."

# Update system
section "SYSTEM UPDATE"
log "Updating package lists..."
sudo apt update || error "Failed to update package lists"

log "Upgrading system..."
sudo apt upgrade -y || error "Failed to upgrade system"

# Install essential packages
section "PACKAGE INSTALLATION"
log "Installing essential packages..."
sudo apt install -y \
    brightnesstl \
    libva-utils \
    mesa-va-drivers \
    network-manager-applet \
    tlp \
    tlp-rdw \
    wget || error "Failed to install essential packages"

# Copy dotfiles and configurations
section "DOTFILES CONFIGURATION"
log "Setting up dotfiles and configurations..."
cd /home/jwno/base_deb

# Copy vim configuration
log "Setting up vim configuration..."
cp vimrc /home/jwno/.vimrc || error "Failed to copy .vimrc"
sudo cp vimrc /root/.vimrc || error "Failed to copy .vimrc to root"

# Copy bash configuration  
log "Setting up bash configuration..."
cp bashrc /home/jwno/.bashrc || error "Failed to copy .bashrc"
sudo cp bashrc /root/.bashrc || error "Failed to copy .bashrc to root"

# Create .config directory if it doesn't exist
mkdir -p /home/jwno/.config

# Copy config directories (rename from repo names to actual names)
log "Setting up application configurations..."
cp -r config/fastfetch /home/jwno/.config/ || error "Failed to copy fastfetch config"
cp -r config/gtk-3.0 /home/jwno/.config/ || error "Failed to copy gtk-3.0 config"
cp -r config/gtk-4.0 /home/jwno/.config/ || error "Failed to copy gtk-4.0 config"
cp /home/jwno/base_deb/.xinitrc /home/jwno/ || error "Failed to copy xinitrc file"

# Install themes and icons system-wide
section "THEMES AND ICONS"
log "Installing themes system-wide..."
cd themes
tar -xf Tokyonight-Dark.tar.xz || error "Failed to extract Tokyonight-Dark theme"
sudo cp -r Tokyonight-Dark /usr/share/themes/ || error "Failed to install Tokyonight-Dark theme"

log "Installing icons system-wide..."
cd ../icons
tar -xf BreezeX-RosePine-Linux.tar.xz || error "Failed to extract BreezeX-RosePine-Linux icons"
sudo cp -r BreezeX-RosePine-Linux /usr/share/icons/ || error "Failed to install BreezeX-RosePine-Linux icons"

cd /home/jwno/base_deb

# Copy Documents directory
log "Setting up Documents directory..."
cp -r Documents /home/jwno/ || error "Failed to copy Documents directory"

# Copy Pictures directory
log "Setting up Pictures directory..."
cp -r Pictures /home/jwno/ || error "Failed to copy Pictures directory"

# Copy TLP configuration
log "Setting up TLP configuration..."
sudo cp tlp.conf /etc/tlp.conf || error "Failed to copy TLP configuration"

# Set proper ownership for user files
section "FILE OWNERSHIP"
log "Setting file ownership..."
sudo chown -R jwno:jwno /home/jwno/.config
sudo chown -R jwno:jwno /home/jwno/Documents
sudo chown -R jwno:jwno /home/jwno/Pictures
sudo chown jwno:jwno /home/jwno/.vimrc
sudo chown jwno:jwno /home/jwno/.bashrc

# Enable services
section "SERVICE CONFIGURATION"
log "Enabling services..."
sudo systemctl enable bluetooth || error "Failed to enable Bluetooth"
sudo systemctl enable tlp || error "Failed to enable TLP"
sudo systemctl enable NetworkManager || error "Failed to enable NetworkManager"
sudo systemctl enable nftables || error "Failed to enable nftables"

# Configure network and firewall
section "NETWORK AND FIREWALL SETUP"
log "Configuring NetworkManager..."
sudo sed -i 's/managed=false/managed=true/' /etc/NetworkManager/NetworkManager.conf || error "Failed to configure NetworkManager"

log "Setting up network interfaces..."
sudo tee /etc/network/interfaces >/dev/null <<EOF || error "Failed to setup network interfaces"
source /etc/network/interfaces.d/*
auto lo
iface lo inet loopback
EOF

log "Setting up firewall rules..."
sudo tee /etc/nftables.conf >/dev/null <<EOF || error "Failed to setup nftables configuration"
#!/usr/sbin/nft -f
flush ruleset
table inet filter {
    chain input { type filter hook input priority filter; policy drop;
        iif "lo" accept
        ct state established,related accept
        ip protocol icmp accept
        ip6 nexthdr ipv6-icmp accept
        udp sport {53,67,123} accept
        tcp sport 53 accept
        udp sport 67 udp dport 68 accept
    }
    chain forward { type filter hook forward priority filter; policy drop; }
    chain output { type filter hook output priority filter; policy accept; }
}
EOF

log "Applying firewall rules..."
sudo nft -f /etc/nftables.conf || error "Failed to apply nftables rules"

log "Removing default motd..."
sudo rm -f /etc/motd || warn "Failed to remove motd"

log "Setup completed successfully!"

# Clean up copied files from base_deb directory
section "CLEANUP"
log "Cleaning up source files..."
rm -f vimrc || warn "Failed to remove vimrc"
rm -f bashrc || warn "Failed to remove bashrc"
rm -f tlp.conf || warn "Failed to remove tlp.conf"
rm -rf Documents || warn "Failed to remove Documents directory"
rm -rf Pictures || warn "Failed to remove Pictures directory"
rm -rf themes || warn "Failed to remove themes directory"
rm -rf icons || warn "Failed to remove icons directory"
rm -rf config || warn "Failed to remove config directory"

log "Cleanup completed!"

# Replace GRUB with systemd-boot
section "BOOTLOADER CONFIGURATION"
log "Installing systemd-boot..."
sudo apt install -y systemd-boot || error "Failed to install systemd-boot"
sudo bootctl install || error "Failed to install systemd-boot bootloader"

log "Removing GRUB..."
sudo apt purge --allow-remove-essential -y grub* shim-signed ifupdown nano os-prober vim-tiny zutty || error "Failed to remove GRUB packages"
sudo apt autoremove --purge -y || error "Failed to autoremove packages"

log "Current EFI boot entries:"
sudo efibootmgr
echo "Enter GRUB boot ID to delete (check efibootmgr output above):"
read -r BOOT_ID
sudo efibootmgr -b "$BOOT_ID" -B || error "Failed to delete GRUB boot entry"

log "Please reboot to start the graphical environment."
