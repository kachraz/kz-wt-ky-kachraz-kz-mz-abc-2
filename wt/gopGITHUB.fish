#!/bin/sh

echo "Delete the old version which is located in /usr/local/go"
sudo rm -rf /usr/local/go
echo "Get the latest binary from https://go.dev/dl/ a the time of writing it is 1.21.4 which will be downloaded "
echo " 1.21.1 - https://go.dev/dl/go1.21.4.linux-amd64.tar.gz"
echo ""
wget https://go.dev/dl/go1.21.4.linux-amd64.tar.gz
echo "Unzip to location /usr/local"
sudo tar -C /usr/local/ -xzf go1.21.4.linux-amd64.tar.gz
echo "#Go Path" >> ~/.config/fish/config.fish
echo "set -gx PATH /usr/local/go/bin:$PATH" >> ~/.config/fish/config.fish
export PATH=$PATH:/home/gitpod/go/bin
rm go1.21.4.linux-amd64.tar.gz