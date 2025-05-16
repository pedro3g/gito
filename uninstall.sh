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
  # Add more mappings as needed
esac

# For Windows under MINGW, Git Bash, or similar
if [[ $OS == *"mingw"* ]] || [[ $OS == *"msys"* ]] || [[ $OS == *"cygwin"* ]] || [[ $OS == "windows_nt" ]]; then
  OS="windows"
  echo -e "${YELLOW}Windows detected.${NC}"
  echo -e "${RED}For Windows, please manually delete gito.exe from your PATH.${NC}"
  echo -e "Common locations include:"
  echo -e "- The directory where you initially downloaded it"
  echo -e "- C:\\Windows"
  echo -e "- A custom directory you added to your PATH"
  exit 0
fi

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