#!/usr/bin/env bash

set -euxo pipefail

echo "🚀 Starting minimal dev setup..."

# ----------------------
# Install Dependencies
# ----------------------
sudo apt update && sudo apt install -y \
  curl \
  wget \
  git \
  gnupg \
  build-essential \
  software-properties-common \
  libssl-dev \
  lsb-release \
  procps \
  xclip

# ----------------------
# Install Fish Shell v4 PPA and Fish 4.x
# ----------------------
sudo apt-add-repository ppa:fish-shell/release-4 -y
sudo apt update
sudo apt install -y fish

# ----------------------
# Install Homebrew (Linuxbrew)
# Run as a non-interactive, unattended Homebrew install
export NONINTERACTIVE=1
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Add Homebrew to PATH in .bashrc if not already there
if ! grep -q "brew shellenv" ~/.bashrc; then
  echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >>~/.bashrc
fi

# Load the PATH now
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Verify installation
brew --version

# ----------------------
# Enable Docker (if using docker-in-docker)
# ----------------------

# Start Docker daemon if not already running
if ! pgrep dockerd > /dev/null; then
  echo "🛠️ Starting Docker daemon..."
  sudo dockerd > /tmp/dockerd.log 2>&1 &
  sleep 5
fi

# Add user to docker group to allow non-sudo access
sudo usermod -aG docker $USER

# Optional: Refresh group membership for current shell
if command -v newgrp >/dev/null; then
  echo "🔄 Applying docker group to current session..."
  newgrp docker <<EONG
echo "✅ Docker is now usable without sudo"
docker version
EONG
else
  echo "⚠️ 'newgrp' not available — restart the shell to use Docker without sudo."
fi

# ----------------------
# Done!
# ----------------------
echo "✅ Setup complete! All tools installed."
echo "🎉 You now have:"
echo " - Node.js, Python, Rust, Go (from devcontainer features)"
echo " - Fish Shell v4"
echo " - Homebrew (Linuxbrew)"
echo " - Docker (with non-sudo access)"
