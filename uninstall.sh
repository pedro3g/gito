#!/bin/bash

set -e

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Uninstalling gito...${NC}"

# Detect OS
OS=$(uname -s | tr '[:upper:]' '[:lower:]')

# Map OS names
case $OS in
  darwin) OS="macos" ;;
  linux) OS="linux" ;;
  *)
    echo -e "${RED}Unsupported OS: $OS${NC}"
    echo -e "${YELLOW}For Windows installations, please use uninstall.ps1 instead${NC}"
    exit 1
    ;;
esac

# For Unix-like systems
INSTALL_DIR="/usr/local/bin"
BINARY_PATH="$INSTALL_DIR/gito"

# Check if binary exists
if [ ! -f "$BINARY_PATH" ]; then
  echo -e "${RED}gito not found at $BINARY_PATH${NC}"
  echo -e "${YELLOW}It might have been installed in a different location or already uninstalled.${NC}"
  exit 1
fi

# Remove the binary
echo -e "Removing gito from $BINARY_PATH..."
sudo rm -f "$BINARY_PATH"

# Verify removal
if [ ! -f "$BINARY_PATH" ]; then
  echo -e "${GREEN}gito has been successfully uninstalled!${NC}"
else
  echo -e "${RED}Failed to uninstall gito. Please try again with sudo.${NC}"
  exit 1
fi

echo -e "${YELLOW}Thank you for using gito!${NC}" 