#!/bin/bash

# Shido Node Upgrade Script for Enso Upgrade (UBUNTU22.04)
# This script automates the node upgrade process for the chain proposal

set -e  # Exit on any error

echo "============================================"
echo "Starting Shido Node Upgrade Process"
echo "============================================"

# Step 1: Stop the node
echo "Step 1: Stopping shidod service..."
sudo systemctl stop shidod
echo "✓ Service stopped"

# Step 2: Remove the old binary
echo "Step 2: Removing old binary..."
sudo rm -f /usr/local/bin/shidod
echo "✓ Old binary removed"

# Step 3: Clone the new Enso upgrade repo
echo "Step 3: Cloning Enso upgrade repository..."
# Remove existing directory if it exists
if [ -d "mainnet-enso-upgrade" ]; then
    echo "Removing existing mainnet-enso-upgrade directory..."
    rm -rf mainnet-enso-upgrade
fi
git clone https://github.com/ShidoGlobal/mainnet-enso-upgrade.git
echo "✓ Repository cloned"

# Step 4: Copy and set permissions for new binary
echo "Step 4: Installing new binary..."
sudo cp mainnet-enso-upgrade/ubuntu22.04build/shidod /usr/local/bin/
sudo chmod +x /usr/local/bin/shidod
echo "✓ New binary installed with proper permissions"

# Step 5: Verify the new version
echo "Step 5: Verifying new version..."
echo "New shidod version:"
/usr/local/bin/shidod version
echo "✓ Version verified"

# Step 6: Start the node
echo "Step 6: Starting shidod service..."
sudo systemctl start shidod
echo "✓ Service started"

# Wait a moment for the service to initialize
echo "Waiting 5 seconds for service to initialize..."
sleep 5

# Check service status
echo "Checking service status..."
sudo systemctl status shidod --no-pager -l

echo "============================================"
echo "Upgrade process completed successfully!"
echo "============================================"

# Step 7: Offer to monitor logs
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
