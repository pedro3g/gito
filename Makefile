.PHONY: bump-version clean-script build build-linux-amd64 build-macos-amd64 build-macos-arm64 build-windows-amd64 build-all-cross

# Makefile to update version in Cargo.toml based on semantic commits

BUMP_SCRIPT := ./bump_version.sh

bump-version:
	@echo "Ensuring bump script is executable..."
	@chmod +x $(BUMP_SCRIPT)
	@echo "Bumping version..."
	@sh $(BUMP_SCRIPT)

# Cross-compilation targets
# Variables
BINARY_NAME := gito
TARGET_DIR := target

# Linux AMD64
LINUX_AMD64_TARGET := x86_64-unknown-linux-gnu
LINUX_AMD64_BINARY_PATH := $(TARGET_DIR)/$(LINUX_AMD64_TARGET)/release/$(BINARY_NAME)

# macOS AMD64 (Intel)
MACOS_AMD64_TARGET := x86_64-apple-darwin
MACOS_AMD64_BINARY_PATH := $(TARGET_DIR)/$(MACOS_AMD64_TARGET)/release/$(BINARY_NAME)

# macOS ARM64 (Apple Silicon)
MACOS_ARM64_TARGET := aarch64-apple-darwin
MACOS_ARM64_BINARY_PATH := $(TARGET_DIR)/$(MACOS_ARM64_TARGET)/release/$(BINARY_NAME)

# Windows AMD64
WINDOWS_AMD64_TARGET := x86_64-pc-windows-msvc
WINDOWS_AMD64_BINARY_PATH := $(TARGET_DIR)/$(WINDOWS_AMD64_TARGET)/release/$(BINARY_NAME).exe

build:
	@echo "Building for native target..."
	@cargo build --release
	@echo "Native build complete: $(TARGET_DIR)/release/$(BINARY_NAME)"

build-linux-amd64:
	@echo "Building for Linux AMD64 (target: $(LINUX_AMD64_TARGET))..."
	@cargo build --release --target $(LINUX_AMD64_TARGET)
	@echo "Linux AMD64 build complete: $(LINUX_AMD64_BINARY_PATH)"

build-macos-amd64:
	@echo "Building for macOS AMD64 (target: $(MACOS_AMD64_TARGET))..."
	@cargo build --release --target $(MACOS_AMD64_TARGET)
	@echo "macOS AMD64 build complete: $(MACOS_AMD64_BINARY_PATH)"

build-macos-arm64:
	@echo "Building for macOS ARM64 (target: $(MACOS_ARM64_TARGET))..."
	@cargo build --release --target $(MACOS_ARM64_TARGET)
	@echo "macOS ARM64 build complete: $(MACOS_ARM64_BINARY_PATH)"

build-windows-amd64:
	@echo "Building for Windows AMD64 (target: $(WINDOWS_AMD64_TARGET))..."
	@cargo build --release --target $(WINDOWS_AMD64_TARGET)
	@echo "Windows AMD64 build complete: $(WINDOWS_AMD64_BINARY_PATH)"

build-all-cross:
	@echo "Building all cross-compilation targets..."
	$(MAKE) build-linux-amd64
	$(MAKE) build-macos-amd64
	$(MAKE) build-macos-arm64
	$(MAKE) build-windows-amd64
	@echo "All cross-compilation builds complete."

# Standard clean target
clean:
	@echo "Cleaning build artifacts..."
	@cargo clean

# This target is no longer needed as the script is provided directly
# clean-script:
# 	@rm -f $(BUMP_SCRIPT) 