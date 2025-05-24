#!/bin/bash

# Shido Node Upgrade Script for Enso Upgrade
# This script automates the node upgrade process for the chain proposal

set -e  # Exit on any error

echo "============================================"
echo "    Shido Node Upgrade to Enso Version"
echo "============================================"

# Ask user to select Ubuntu version
echo "Please select your Ubuntu version:"
echo "1) Ubuntu 20.04"
echo "2) Ubuntu 22.04"
echo ""
read -p "Enter your choice (1 or 2): " choice

case $choice in
    1)
        UBUNTU_VERSION="20.04"
        DOWNLOAD_URL="https://github.com/ShidoGlobal/mainnet-enso-upgrade/releases/download/ubuntu20.04/shidod"
        echo "Selected: Ubuntu 20.04"
        ;;
    2)
        UBUNTU_VERSION="22.04"
        DOWNLOAD_URL="https://github.com/ShidoGlobal/mainnet-enso-upgrade/releases/download/ubuntu22.04/shidod"
        echo "Selected: Ubuntu 22.04"
        ;;
    *)
        echo "Invalid choice. Please run the script again and select 1 or 2."
        exit 1
        ;;
esac

echo ""
echo "============================================"
echo "Starting Upgrade Process for Ubuntu $UBUNTU_VERSION"
echo "============================================"

# Step 1: Stop the node
echo "Step 1: Stopping shidod service..."
sudo systemctl stop shidod
echo "✓ Service stopped"

# Step 2: Remove the old binary
echo "Step 2: Removing old binary..."
sudo rm -f /usr/local/bin/shidod
echo "✓ Old binary removed"

# Step 3: Update WASM library
echo "Step 3: Updating WASM library..."
sudo rm -f /usr/lib/libwasmvm.x86_64.so
sudo wget -P /usr/lib https://github.com/CosmWasm/wasmvm/releases/download/v2.1.4/libwasmvm.x86_64.so
sudo ldconfig
echo "✓ WASM library updated"

# Step 4: Download the new binary
echo "Step 4: Downloading new shidod binary for Ubuntu $UBUNTU_VERSION..."
wget $DOWNLOAD_URL
echo "✓ Binary downloaded"

# Step 5: Install and set permissions for new binary
echo "Step 5: Installing new binary..."
sudo mv shidod /usr/local/bin/
sudo chmod +x /usr/local/bin/shidod
echo "✓ New binary installed with proper permissions"

# Step 6: Verify the new version
echo "Step 6: Verifying new version..."
echo "New shidod version:"
/usr/local/bin/shidod version
echo "✓ Version verified"

# Step 7: Start the node
echo "Step 7: Starting shidod service..."
sudo systemctl start shidod
echo "✓ Service started"

# Wait a moment for the service to initialize
echo "Waiting 5 seconds for service to initialize..."
sleep 5

# Check service status
echo "Checking service status..."
sudo systemctl status shidod --no-pager -l

echo ""
echo "============================================"
echo "Upgrade process completed successfully!"
echo "============================================"

# Step 8: Offer to monitor logs
echo ""
read -p "Would you like to monitor the logs now? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Starting log monitoring (Press Ctrl+C to exit)..."
    sudo journalctl -u shidod -f
else
    echo "To monitor logs later, run: sudo journalctl -u shidod -f"
fi

echo "Upgrade script finished."
