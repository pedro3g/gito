#!/bin/bash

set -e

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}Installing gito...${NC}"

# Detect OS and architecture
OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)

# Map OS names
case $OS in
  darwin) OS="macos" ;;
  linux) OS="linux" ;;
  # Add more mappings as needed
esac

# Map architecture names
case $ARCH in
  x86_64) ARCH="amd64" ;;
  aarch64|arm64) ARCH="arm64" ;;
  # Add more mappings as needed
esac

# For Windows under MINGW, Git Bash, or similar
if [[ $OS == *"mingw"* ]] || [[ $OS == *"msys"* ]] || [[ $OS == *"cygwin"* ]] || [[ $OS == "windows_nt" ]]; then
  OS="windows"
  EXTENSION=".exe"
  echo -e "${YELLOW}Windows detected. Installation will be to current directory.${NC}"
fi

echo -e "Detected platform: ${GREEN}$OS-$ARCH${NC}"

# Determine the download URL
RELEASE_URL="https://api.github.com/repos/pedro3g/gito/releases/latest"
echo -e "Fetching latest release information..."

# Get the release info once and save it
RELEASE_INFO=$(curl -s "$RELEASE_URL")

# Use a pattern that matches the expected filename format
ASSET_PATTERN="gito-$OS-$ARCH$EXTENSION"
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
curl -sL "$DOWNLOAD_URL" -o gito$EXTENSION

# Determine install location
if [ "$OS" = "windows" ]; then
  # For Windows, we'll just place it in the current directory
  # User will need to move it to their preferred location
  TARGET_DIR=$(pwd)
  cp gito$EXTENSION "$TARGET_DIR/"
  
  echo -e "${GREEN}Downloaded to: $TARGET_DIR/gito$EXTENSION${NC}"
  echo -e "${YELLOW}Next steps:${NC}"
  echo -e "1. Rename the file to 'gito.exe' if you want"
  echo -e "2. Move this file to a directory in your PATH (e.g., C:\\Windows)"
  echo -e "3. You can then run 'gito' from any Command Prompt or PowerShell window"
else
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
fi

# Clean up
cd - > /dev/null
rm -rf "$TMP_DIR"

echo -e "${GREEN}Installation complete! Enjoy using gito!${NC}" 