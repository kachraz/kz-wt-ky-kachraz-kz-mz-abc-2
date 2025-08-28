#!/bin/fish

# Downlad binary from here 
# https://github.com/neovim/neovim/releases/tag/nightly 



wget https://github.com/neovim/neovim/releases/tag/nightly 

# Them make app image executable 

./nvim.appimage --appimage-extract 

# Copy ./squashfs-root/usr/bin/nvim to bin

sudo cp ./squashfs-root/usr/bin/nvim /bin