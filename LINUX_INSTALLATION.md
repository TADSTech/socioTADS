# Linux Installation Guide for SocioTADS

Complete guide for installing and setting up SocioTADS on Linux distributions.

## Table of Contents

- [System Requirements](#system-requirements)
- [Installation Methods](#installation-methods)
- [Desktop Integration](#desktop-integration)
- [Uninstallation](#uninstallation)
- [Troubleshooting](#troubleshooting)

## System Requirements

### Minimum Requirements
- Linux kernel 4.15+
- 200 MB free disk space
- 512 MB RAM
- X11 or Wayland display server

### Supported Distributions
- Ubuntu 20.04 LTS and newer
- Fedora 33 and newer
- Debian 10 and newer
- Arch Linux
- Linux Mint 20 and newer
- Any other systemd-based distribution

## Installation Methods

### Method 1: User Installation (Recommended)

Installs application in user's home directory. No root access required.

1. Create applications directory:
   ```bash
   mkdir -p ~/Apps
   cd ~/Apps
   ```

2. Download and extract:
   ```bash
   wget https://github.com/TADSTech/socioTADS/releases/download/v1.0.0/sociotads-linux-bundle.zip
   unzip sociotads-linux-bundle.zip
   ```

3. Make executable:
   ```bash
   chmod +x SocioTADS/bundle/sociotads
   ```

4. Create desktop entry:
   ```bash
   mkdir -p ~/.local/share/applications
   cat > ~/.local/share/applications/sociotads.desktop << 'EOF'
[Desktop Entry]
Version=1.0
Name=SocioTADS
Comment=Automate X posts with scheduling and GitHub integration
Exec=~/Apps/SocioTADS/bundle/sociotads
Icon=~/Apps/SocioTADS/bundle/data/flutter_assets/assets/logo.png
Terminal=false
Type=Application
Categories=Utility;Development;
StartupWMClass=com.tads.sociotads
Keywords=social;media;twitter;automation;
EOF
   ```

   Replace `~` with your actual home directory path or use full paths.

5. Update desktop database:
   ```bash
   update-desktop-database ~/.local/share/applications/
   ```

6. Configure credentials (see [Configuration](#configuration))

### Method 2: System-Wide Installation

Installs for all users. Requires root access.

1. Download and extract to system location:
   ```bash
   sudo wget https://github.com/TADSTech/socioTADS/releases/download/v1.0.0/sociotads-linux-bundle.zip -O /tmp/sociotads.zip
   sudo unzip /tmp/sociotads.zip -d /opt/
   sudo chmod +x /opt/SocioTADS/bundle/sociotads
   ```

2. Create system-wide desktop entry:
   ```bash
   sudo tee /usr/share/applications/sociotads.desktop > /dev/null << 'EOF'
[Desktop Entry]
Version=1.0
Name=SocioTADS
Comment=Automate X posts with scheduling and GitHub integration
Exec=/opt/SocioTADS/bundle/sociotads
Icon=/opt/SocioTADS/bundle/data/flutter_assets/assets/logo.png
Terminal=false
Type=Application
Categories=Utility;Development;
StartupWMClass=com.tads.sociotads
Keywords=social;media;twitter;automation;
EOF
   ```

3. Update desktop database:
   ```bash
   sudo update-desktop-database /usr/share/applications/
   ```

### Method 3: Building from Source

For developers who want to build the latest version.

1. Install Flutter SDK:
   ```bash
   # Follow instructions at https://flutter.dev/docs/get-started/install/linux
   git clone https://github.com/flutter/flutter.git -b stable
   export PATH="$PATH:`pwd`/flutter/bin"
   flutter doctor
   ```

2. Install Linux build dependencies:
   ```bash
   # Ubuntu/Debian
   sudo apt-get install cmake ninja-build pkg-config libgtk-3-dev

   # Fedora
   sudo dnf install cmake ninja-build pkg-config gtk3-devel

   # Arch
   sudo pacman -S cmake ninja pkg-config gtk3
   ```

3. Clone and build:
   ```bash
   git clone https://github.com/TADSTech/socioTADS.git
   cd socioTADS
   flutter pub get
   flutter build linux --release
   ```

4. The built binary will be at: `build/linux/x64/release/bundle/sociotads`

5. Create desktop entry pointing to your build location

## Desktop Integration

### Accessing from Application Menu

After installation, SocioTADS will appear in your application menu under:
- Utilities
- Development

Depending on your desktop environment (GNOME, KDE, XFCE, etc.), access it via:
- GNOME: Activities > Search for "SocioTADS"
- KDE: Application Launcher > Utilities > SocioTADS
- XFCE: Applications > Utilities > SocioTADS

### Command Line Launch

After installation, launch from terminal:
```bash
sociotads
```

Or if using user installation:
```bash
~/Apps/SocioTADS/bundle/sociotads
```

### Desktop Entry Advanced Options

The `.desktop` file supports additional customization:

```ini
[Desktop Entry]
Version=1.0
Name=SocioTADS
Comment=Automate X posts
Exec=/path/to/sociotads
Icon=/path/to/logo.png
Terminal=false
Type=Application

# Additional options
Categories=Utility;Development;
Keywords=social;twitter;automation;
StartupWMClass=com.tads.sociotads
StartupNotify=true

# Custom actions (optional)
Actions=NewPost;OpenSettings

[Desktop Action NewPost]
Name=Create New Post
Exec=/path/to/sociotads --new-post

[Desktop Action OpenSettings]
Name=Open Settings
Exec=/path/to/sociotads --settings
```

## Configuration

### Setting Up Credentials

1. Locate the `.env` file:
   ```bash
   # For user installation
   nano ~/Apps/SocioTADS/.env

   # For system installation
   sudo nano /opt/SocioTADS/.env
   ```

2. Add your API credentials:
   ```env
   X_API_KEY=your_key
   X_API_KEY_SECRET=your_secret
   X_BEARER_TOKEN=your_token
   X_ACCESS_TOKEN=your_token
   X_ACCESS_TOKEN_SECRET=your_secret
   GIT_PAT=your_github_token
   UNLOCK_CODE=12345678901
   ```

3. Save and restart the application

### Changing the Unlock Code

Edit the `.env` file and update the `UNLOCK_CODE` value to an 11-digit number.

## Uninstallation

### User Installation

```bash
# Remove desktop entry
rm ~/.local/share/applications/sociotads.desktop

# Remove application files
rm -rf ~/Apps/SocioTADS

# Update desktop database
update-desktop-database ~/.local/share/applications/
```

### System-Wide Installation

```bash
# Remove desktop entry
sudo rm /usr/share/applications/sociotads.desktop

# Remove application files
sudo rm -rf /opt/SocioTADS

# Update desktop database
sudo update-desktop-database /usr/share/applications/
```

## Troubleshooting

### Application Won't Start

1. Check file permissions:
   ```bash
   ls -la ~/Apps/SocioTADS/bundle/sociotads
   chmod +x ~/Apps/SocioTADS/bundle/sociotads
   ```

2. Check for dependencies:
   ```bash
   ldd ~/Apps/SocioTADS/bundle/sociotads
   ```

3. Run from terminal to see errors:
   ```bash
   ~/Apps/SocioTADS/bundle/sociotads
   ```

### Missing Dependencies

Install required libraries:

```bash
# Ubuntu/Debian
sudo apt-get install libgtk-3-0 libssl1.1

# Fedora
sudo dnf install gtk3 openssl-libs

# Arch
sudo pacman -S gtk3 openssl
```

### Desktop Entry Not Appearing

1. Verify file exists:
   ```bash
   cat ~/.local/share/applications/sociotads.desktop
   ```

2. Check file permissions:
   ```bash
   chmod 644 ~/.local/share/applications/sociotads.desktop
   ```

3. Rebuild desktop database:
   ```bash
   update-desktop-database ~/.local/share/applications/
   ```

4. Clear cache:
   ```bash
   rm -rf ~/.cache/application-state
   ```

### Window Manager Issues

If the application doesn't appear in taskbar or has window manager issues:

1. Check `StartupWMClass` in desktop file matches application window class
2. Try different window manager:
   ```bash
   WM_CLASS_NAME=com.tads.sociotads ~/Apps/SocioTADS/bundle/sociotads
   ```

### Performance Issues

1. Close other applications
2. Ensure sufficient disk space:
   ```bash
   df -h
   ```

3. Check system resources:
   ```bash
   free -h
   ```

## File Locations

Important directories and files:

```
User Installation:
  ~/Apps/SocioTADS/
    bundle/sociotads          # Main executable
    .env                      # Configuration file
    data/flutter_assets/      # Assets directory

System Installation:
  /opt/SocioTADS/
  /usr/share/applications/sociotads.desktop
```

## Getting Help

- Check [README.md](../README.md) for general help
- Create an issue on [GitHub](https://github.com/TADSTech/socioTADS/issues)
- Check application logs in terminal output

## Version Information

Check installed version:

```bash
# From application menu, look for version in about dialog
# Or check release notes at:
# https://github.com/TADSTech/socioTADS/releases
```

Update to latest version:

1. Download new release
2. Extract to same location (choose "replace")
3. Restart application
