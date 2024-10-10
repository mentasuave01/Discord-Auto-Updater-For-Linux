#!/bin/bash

# Check if we are on Arch Linux or debian based
if [ ! -f /etc/arch-release ]; then
    DISCORD_OS="arch"
else 
    DISCORD_OS="debian"
fi

# Check for Discord installation directory
if [ -d "/usr/share/discord" ]; then
    DISCORD_DIR="/usr/share/discord"
elif [ -d "/opt/discord" ]; then
    DISCORD_DIR="/opt/discord"
else
    echo "Discord installation not found in /usr/share/discord or /opt/discord. Please ensure Discord is installed."
    exit 1
fi

# URL to fetch the latest .deb package
DISCORD_DOWNLOAD_URL="https://discord.com/api/download/stable?platform=linux&format=deb"

# Temporary directory for downloading the latest package
TEMP_DIR="/tmp/discord_update"

# Function to get the current installed version
get_installed_version() {
    if [[ -f "$DISCORD_DIR/resources/build_info.json" ]]; then
        INSTALLED_VERSION=$(jq -r '.version' "$DISCORD_DIR/resources/build_info.json")
    else
        INSTALLED_VERSION="none"
    fi
}

# Function to get the latest available version
get_latest_version() {
    LATEST_VERSION=$(curl -s "$DISCORD_DOWNLOAD_URL" -L -o "$TEMP_DIR/discord.deb" && dpkg-deb -f "$TEMP_DIR/discord.deb" Version)
}

# Function to update Discord
update_discord() {
    if [ "$DISCORD_OS" = "debian" ]; then
        sudo dpkg -i "$TEMP_DIR/discord.deb"
    elif [ "$DISCORD_OS" = "arch" ]; then
        # For Arch, we just update the version in build_info.json
        sudo sed -i "s/\"version\": \"$INSTALLED_VERSION\"/\"version\": \"$LATEST_VERSION\"/" "$DISCORD_DIR/resources/build_info.json"
        echo "Updated build_info.json with new version $LATEST_VERSION"
    fi
    rm -rf "$TEMP_DIR"
}

# Create temp directory if it doesn't exist
mkdir -p "$TEMP_DIR"

# Get current installed version
get_installed_version

# Get latest available version
get_latest_version

# Compare versions and update if needed
if [[ "$INSTALLED_VERSION" != "$LATEST_VERSION" ]]; then
    echo "Updating Discord from version $INSTALLED_VERSION to $LATEST_VERSION"
    # Close Discord if running
    pkill discord
    sleep 5  # Wait a few seconds to ensure Discord is closed
    # Update Discord
    update_discord
else
    echo "Discord is already up-to-date (version $INSTALLED_VERSION)"
fi

# Launch Discord
"$TEMP_DIR/Discord.orig"
