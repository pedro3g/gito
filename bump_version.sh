#!/bin/sh
set -e

# Function to extract version from Cargo.toml
get_current_version() {
    grep '^version =' Cargo.toml | sed 's/version = "\([0-9.]*\)"/\1/'
}

# Function to increment version based on type (major, minor, patch)
increment_version() {
    local version=$1
    local type=$2
    local major=$(echo $version | cut -d. -f1)
    local minor=$(echo $version | cut -d. -f2)
    local patch=$(echo $version | cut -d. -f3)

    case $type in
        major)
            major=$((major + 1))
            minor=0
            patch=0
            ;;
        minor)
            minor=$((minor + 1))
            patch=0
            ;;
        patch)
            patch=$((patch + 1))
            ;;
        *)
            echo "Error: Invalid bump type '$type'"
            exit 1
            ;;
    esac
    echo "$major.$minor.$patch"
}

# Get current version
CURRENT_VERSION=$(get_current_version)
echo "Current version: $CURRENT_VERSION"

# Get the latest git tag
LATEST_TAG=$(git describe --tags --abbrev=0 2>/dev/null || echo "")

COMMIT_RANGE=""
if [ -n "$LATEST_TAG" ]; then
    echo "Last tag found: $LATEST_TAG"
    COMMIT_RANGE="$LATEST_TAG..HEAD"
else
    echo "No tags found, analyzing all commits."
    # If you want to analyze all commits, leave COMMIT_RANGE empty or set to HEAD
    # For initial version, let's assume it's a minor or patch based on commits.
    # Or, you could prompt the user or set a default like 0.1.0 initially.
    # For this script, we'll proceed assuming an initial bump from 0.0.0 effectively.
fi

echo "Analyzing commits in range: $COMMIT_RANGE"
# Get commit messages
# Using --pretty=%B to get the full commit message body for BREAKING CHANGE detection
COMMIT_MESSAGES=$(git log $COMMIT_RANGE --pretty=%B)

BUMP_TYPE="none"

# Determine bump type
# Order of checks matters: major -> minor -> patch
if echo "$COMMIT_MESSAGES" | grep -q -E 'BREAKING CHANGE:|feat!:' ; then
    BUMP_TYPE="major"
elif echo "$COMMIT_MESSAGES" | grep -q -E '^feat(\(.+\))?:' ; then
    BUMP_TYPE="minor"
elif echo "$COMMIT_MESSAGES" | grep -q -E '^(fix|perf|revert|docs|style|chore|refactor|test)(\(.+\))?:' ; then
    BUMP_TYPE="patch"
fi

if [ "$BUMP_TYPE" = "none" ]; then
    echo "No relevant commit types found since last tag or in history. No version bump needed."
    # If no commits dictate a bump, but there are commits, default to patch?
    # Or only bump if specific keywords are found. For now, exiting.
    # If LATEST_TAG is empty and CURRENT_VERSION is like 0.0.0, we might want to force a patch or minor.
    # This part might need refinement based on desired behavior for initial versioning or empty commit logs.
    if [ -z "$LATEST_TAG" ] && [ "$(git rev-list --count HEAD)" -gt 0 ]; then
        echo "No tags yet, but commits exist. Defaulting to patch bump for initial versioning from $CURRENT_VERSION."
        BUMP_TYPE="patch"
        # If current version is 0.0.0 from a template, and we have features, maybe default to minor?
        if [ "$CURRENT_VERSION" = "0.0.0" ] || [ "$CURRENT_VERSION" = "0.1.0" ]; then # Check for placeholder versions
             if echo "$COMMIT_MESSAGES" | grep -q -E '^feat(\(.+\))?:' ; then
                BUMP_TYPE="minor"
             fi
        fi

    else
        echo "No changes detected that warrant a version bump."
        exit 0
    fi
fi

echo "Determined bump type: $BUMP_TYPE"

# Calculate new version
NEW_VERSION=$(increment_version $CURRENT_VERSION $BUMP_TYPE)
echo "New version: $NEW_VERSION"

# Update Cargo.toml
# Using a temporary file for sed to avoid issues with in-place editing on different systems
TMP_CARGO=$(mktemp)
sed "s/^version = .*/version = \"$NEW_VERSION\"/" Cargo.toml > $TMP_CARGO
mv $TMP_CARGO Cargo.toml
echo "Updated Cargo.toml to version $NEW_VERSION"

# Git commit and tag
echo "Committing and tagging version $NEW_VERSION..."
git add Cargo.toml
git commit -m "chore(release): bump version to $NEW_VERSION"
git tag "v$NEW_VERSION"

echo "Pushing changes and tags..."
# git push
# git push --tags
echo "Run 'git push && git push --tags' to push the changes and the new tag."


echo "Version bump complete. New version is $NEW_VERSION."
echo "Remember to push the commit and tag: git push && git push --tags" 