#!/usr/bin/env fish 
echo " "
echo " Install UV and Fish Autocomplete "
echo " "
# Install UV 
curl -LsSf https://astral.sh/uv/install.sh | sh
# Setup automcomplete 
echo 'uv generate-shell-completion fish | source' >> ~/.config/fish/config.fish
echo 'uvx --generate-shell-completion fish | source' >> ~/.config/fish/config.fish
