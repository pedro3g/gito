.PHONY: bump-version clean-script

# Makefile to update version in Cargo.toml based on semantic commits

BUMP_SCRIPT := ./bump_version.sh

bump-version:
	@echo "Ensuring bump script is executable..."
	@chmod +x $(BUMP_SCRIPT)
	@echo "Bumping version..."
	@sh $(BUMP_SCRIPT)

# This target is no longer needed as the script is provided directly
# clean-script:
# 	@rm -f $(BUMP_SCRIPT) 