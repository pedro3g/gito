#!/bin/bash

set -e

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo -e "${GREEN}Installing gito...${NC}"

# Detect OS and architecture
OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)

# Map OS names
case $OS in
  darwin) OS="macos" ;;
  linux) OS="linux" ;;
  *)
    echo -e "${RED}Unsupported OS: $OS${NC}"
    echo -e "${YELLOW}For Windows installations, please use install.ps1 instead${NC}"
    exit 1
    ;;
esac

# Map architecture names
case $ARCH in
  x86_64) ARCH="amd64" ;;
  aarch64|arm64) ARCH="arm64" ;;
  # Add more mappings as needed
esac

echo -e "Detected platform: ${GREEN}$OS-$ARCH${NC}"

# Determine the download URL
RELEASE_URL="https://api.github.com/repos/pedro3g/gito/releases/latest"
echo -e "Fetching latest release information..."

# Get the release info once and save it
RELEASE_INFO=$(curl -s "$RELEASE_URL")

# Use a pattern that matches the expected filename format
ASSET_PATTERN="gito-$OS-$ARCH"
echo -e "Looking for asset: ${GREEN}$ASSET_PATTERN${NC}"

# Extract download URL
DOWNLOAD_URL=$(echo "$RELEASE_INFO" | grep -o "https://github.com/pedro3g/gito/releases/download/[^\"]*$ASSET_PATTERN" | head -n 1)

# Extract version from the download URL
if [ ! -z "$DOWNLOAD_URL" ]; then
  VERSION=$(echo "$DOWNLOAD_URL" | grep -o "/v[0-9][^/]*/" | tr -d '/')
else
  VERSION="unknown"
fi

if [ -z "$DOWNLOAD_URL" ]; then
  echo -e "${RED}Error: Could not find a release for your platform ($OS-$ARCH)${NC}"
  echo -e "${YELLOW}Available assets:${NC}"
  echo "$RELEASE_INFO" | grep -o '"name":"[^"]*"' | sed 's/"name":"//;s/"//'
  exit 1
fi

echo -e "Latest version: ${GREEN}$VERSION${NC}"
echo -e "Downloading from: ${GREEN}$DOWNLOAD_URL${NC}"

# Create temporary directory
TMP_DIR=$(mktemp -d)
cd "$TMP_DIR"

# Download the binary
echo -e "Downloading binary..."
curl -sL "$DOWNLOAD_URL" -o gito

# For Unix-like systems
INSTALL_DIR="/usr/local/bin"

echo -e "Installing to ${GREEN}$INSTALL_DIR/gito${NC}..."

# Create directory if it doesn't exist
sudo mkdir -p "$INSTALL_DIR"

# Move binary to install location and make executable
sudo mv gito "$INSTALL_DIR/"
sudo chmod +x "$INSTALL_DIR/gito"

echo -e "${GREEN}gito has been installed to $INSTALL_DIR/gito${NC}"
echo -e "${GREEN}You can now run it using the 'gito' command${NC}"

# Clean up
cd - > /dev/null
rm -rf "$TMP_DIR"

echo -e "${GREEN}Installation complete! Enjoy using gito!${NC}" 