#!/bin/bash
set -e

export DEBIAN_FRONTEND=noninteractive

echo "🔄 Updating system..."
sudo apt-get update -y

echo "📦 Installing desktop + base apps..."
sudo apt-get install -y \
  xfce4 xfce4-goodies \
  xrdp \
  firefox \
  vlc \
  gimp \
  gnome-calculator \
  curl git wget \
  gnupg2 apt-transport-https ca-certificates software-properties-common

# Optional heavy apps (comment if CI slow)
sudo apt-get install -y libreoffice || true

# ----------------------------
# 🌐 Install Google Chrome (FIXED)
# ----------------------------
echo "🌐 Installing Google Chrome..."
wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O chrome.deb
sudo dpkg -i chrome.deb || sudo apt-get install -f -y
rm chrome.deb

# ----------------------------
# 💻 Install VS Code (CLEAN WAY)
# ----------------------------
echo "💻 Installing VS Code..."
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo install -o root -g root -m 644 microsoft.gpg /usr/share/keyrings/
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list

sudo apt-get update -y
sudo apt-get install -y code

# ----------------------------
# 🧹 Cleanup (IMPORTANT)
# ----------------------------
echo "🧹 Cleaning up..."
sudo apt-get clean
sudo rm -rf /var/lib/apt/lists/*
rm -f microsoft.gpg

echo "✅ All apps installed successfully!"
