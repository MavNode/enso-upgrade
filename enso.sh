#!/bin/bash

# Shido Node Upgrade Script for Enso Upgrade (UBUNTU22.04)
# This script automates the node upgrade process for the chain proposal

set -e  # Exit on any error

# Check for simulation mode
SIMULATE=false
if [[ "$1" == "--simulate" ]] || [[ "$1" == "--dry-run" ]]; then
    SIMULATE=true
    echo "🔍 SIMULATION MODE - No actual changes will be made"
    echo ""
fi

echo "============================================"
echo "Starting Shido Node Upgrade Process"
echo "============================================"

# Step 1: Stop the node
echo "Step 1: Stopping shidod service..."
if [ "$SIMULATE" = true ]; then
    echo "  [SIMULATE] Would run: sudo systemctl stop shidod"
else
    sudo systemctl stop shidod
fi
echo "✓ Service stopped"

# Step 2: Remove the old binary
echo "Step 2: Removing old binary..."
if [ "$SIMULATE" = true ]; then
    echo "  [SIMULATE] Would run: sudo rm -f /usr/local/bin/shidod"
else
    sudo rm -f /usr/local/bin/shidod
fi
echo "✓ Old binary removed"

# Step 3: Clone the new Enso upgrade repo
echo "Step 3: Cloning Enso upgrade repository..."
if [ "$SIMULATE" = true ]; then
    echo "  [SIMULATE] Would remove existing mainnet-enso-upgrade directory"
    echo "  [SIMULATE] Would run: git clone https://github.com/ShidoGlobal/mainnet-enso-upgrade.git"
else
    # Remove existing directory if it exists
    if [ -d "mainnet-enso-upgrade" ]; then
        echo "Removing existing mainnet-enso-upgrade directory..."
        rm -rf mainnet-enso-upgrade
    fi
    git clone https://github.com/ShidoGlobal/mainnet-enso-upgrade.git
fi
echo "✓ Repository cloned"

# Step 4: Copy and set permissions for new binary
echo "Step 4: Installing new binary..."
if [ "$SIMULATE" = true ]; then
    echo "  [SIMULATE] Would run: sudo cp mainnet-enso-upgrade/ubuntu22.04build/shidod /usr/local/bin/"
    echo "  [SIMULATE] Would run: sudo chmod +x /usr/local/bin/shidod"
else
    sudo cp mainnet-enso-upgrade/ubuntu22.04build/shidod /usr/local/bin/
    sudo chmod +x /usr/local/bin/shidod
fi
echo "✓ New binary installed with proper permissions"

# Step 5: Verify the new version
echo "Step 5: Verifying new version..."
if [ "$SIMULATE" = true ]; then
    echo "  [SIMULATE] Would run: /usr/local/bin/shidod version"
    echo "  [SIMULATE] New version would be displayed here"
else
    echo "New shidod version:"
    /usr/local/bin/shidod version
fi
echo "✓ Version verified"

# Step 6: Start the node
echo "Step 6: Starting shidod service..."
if [ "$SIMULATE" = true ]; then
    echo "  [SIMULATE] Would run: sudo systemctl start shidod"
else
    sudo systemctl start shidod
fi
echo "✓ Service started"

# Wait a moment for the service to initialize
if [ "$SIMULATE" = false ]; then
    echo "Waiting 5 seconds for service to initialize..."
    sleep 5

    # Check service status
    echo "Checking service status..."
    sudo systemctl status shidod --no-pager -l
else
    echo "  [SIMULATE] Would wait 5 seconds and check service status"
fi

echo "============================================"
echo "Upgrade process completed successfully!"
echo "============================================"

# Step 7: Offer to monitor logs
echo ""
if [ "$SIMULATE" = true ]; then
    echo "  [SIMULATE] Would offer to monitor logs with: sudo journalctl -u shidod -f"
    echo "Simulation completed successfully!"
else
    read -p "Would you like to monitor the logs now? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "Starting log monitoring (Press Ctrl+C to exit)..."
        sudo journalctl -u shidod -f
    else
        echo "To monitor logs later, run: sudo journalctl -u shidod -f"
    fi
fi

echo "Upgrade script finished."
