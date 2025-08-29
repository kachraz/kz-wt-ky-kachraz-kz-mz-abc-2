#!/bin/sh

echo "Delete the old version which is located in /home/gitpod/go/"
rm -rf /home/gitpod/go
echo "Get the latest binary from https://go.dev/dl/ a the time of writing it is 1.20 which will be downloaded "
echo " 1.21.4 - https://go.dev/dl/go1.21.4.linux-amd64.tar.gz"
echo ""
wget https://go.dev/dl/go1.21.4.linux-amd64.tar.gz
echo "Unzip to location /usr/local"
sudo tar -C /home/gitpod/ -xzf go1.21.4.linux-amd64.tar.gz 
echo "#Go Path" >> ~/.config/fish/config.fish
echo "set -gx PATH /home/gitpod/go/bin:$PATH" >> ~/.config/fish/config.fish
export PATH=$PATH:/home/gitpod/go/bin
rm go1.21.4.linux-amd64.tar.gz