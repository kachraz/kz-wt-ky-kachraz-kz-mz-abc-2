#!/bin/bash

# Install fish
echo ""
echo "Installing Fish..."
sudo apt-add-repository ppa:fish-shell/release-3 -y
sudo apt install libwebkit2gtk-4.0-dev libgtk-3-dev libappindicator3-dev -y
sudo apt-get install fish -y
echo ""
echo ""
