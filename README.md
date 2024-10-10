# Discord Auto Updater for Linux

## What This Is

This project provides a wrapper script that automatically checks for updates and installs the latest version of Discord whenever it is launched. This ensures that you always have the latest version of Discord without manually downloading and installing updates. The setup script supports both APT (Debian-based) and AUR (Arch-based) distributions.

## How It Works

1. **Wrapper Script**: The wrapper script (`discord-launcher.sh`) performs the following tasks each time Discord is launched:
   - Checks the currently installed version of Discord.
   - Fetches the latest version available from the Discord servers.
   - Compares the installed version with the latest version.
   - If an update is available, closes the running Discord application, downloads the latest version, installs it, and then launches Discord.
   
2. **Setup Script**: The setup script (`setup_discord_update.sh`) automates the installation process:
   - Detects the package manager (APT or Pacman).
   - Installs necessary dependencies (`jq` and `curl`).
   - Downloads the wrapper script from GitHub.
   - Backs up the original Discord launcher.
   - Replaces the original launcher with a symlink to the wrapper script.

## Install Instructions

### Prerequisites

- A system running a Debian-based (APT) or Arch-based (AUR) Linux distribution.
- Discord installed in `/usr/share/discord`.

### Installation Steps

1. **Download and Run the Setup Script**:

   ```bash
   curl -L https://raw.githubusercontent.com/mentasuave01/Discord-Auto-Updater-For-Linux/master/setup_discord_update.sh -o setup_discord_update.sh
   chmod +x setup_discord_update.sh
   sudo ./setup_discord_update.sh
   ```

2. **Never have to Update Discord Again**:
   
   After the setup script runs, it will download the discord-launcher.sh script.
   
   This script replaces the default /usr/share/discord/Discord executable so that it checks and automatically updates Discord every time Discord is run.
