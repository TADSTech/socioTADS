# SocioTADS

Free and open-source social media automator with native Linux support using Flutter. Automate your X (Twitter) posts with scheduling, image uploads, and GitHub-based content management.

## Table of Contents

- [Features](#features)
- [Quick Start](#quick-start)
- [Installation](#installation)
  - [Linux Desktop Setup](#linux-desktop-setup)
  - [Web Version](#web-version)
  - [From Source](#from-source)
- [Configuration](#configuration)
- [Usage](#usage)
- [Development](#development)
- [Contributing](#contributing)
- [Troubleshooting](#troubleshooting)
- [License](#license)

## Features

- Cross-platform support (Linux desktop, macOS, Windows, Web)
- Responsive design for various screen sizes
- Lock screen with numeric unlock code for security
- GitHub API integration for content management
- Twitter/X API integration for automated posting
- Image upload and media management
- Post scheduling with automatic publication
- Dark/Light theme support
- Web and desktop versions

## Quick Start

### For Linux Desktop Users

1. Download the latest release from [Releases](https://github.com/TADSTech/socioTADS/releases)
2. Extract the bundle:
   ```bash
   unzip sociotads-linux-bundle.zip
   cd SocioTADS
   ```
3. Copy the `.env.example` file to `.env` and add your API credentials
4. Create a desktop shortcut (see [Linux Desktop Setup](#linux-desktop-setup))
5. Run the application

### For Web Users

Visit [SocioTADS Web](https://sociotads.web.app) in your browser.

### For Developers

Clone and setup locally:
```bash
git clone https://github.com/TADSTech/socioTADS.git
cd socioTADS
flutter pub get
flutter run -d linux      # or web-server, windows, etc.
```

## Installation

### Linux Desktop Setup

#### Prerequisites

- Linux distribution (Ubuntu, Fedora, Arch, etc.)
- 200 MB free disk space
- X11 or Wayland display server

#### Installation Steps

1. Download the latest Linux bundle from [Releases](https://github.com/TADSTech/socioTADS/releases)

2. Extract to your applications directory:
   ```bash
   mkdir -p ~/Apps
   unzip sociotads-linux-bundle.zip -d ~/Apps/
   cd ~/Apps/SocioTADS
   ```

3. Make the executable runnable:
   ```bash
   chmod +x bundle/sociotads
   ```

4. Create the desktop entry file:
   ```bash
   mkdir -p ~/.local/share/applications
   nano ~/.local/share/applications/sociotads.desktop
   ```

5. Add the following content (update paths as needed):
   ```ini
   [Desktop Entry]
   Version=1.0
   Name=SocioTADS
   Comment=Automate X posts with scheduling and GitHub integration
   Exec=/home/YOUR_USERNAME/Apps/SocioTADS/bundle/sociotads
   Icon=/home/YOUR_USERNAME/Apps/SocioTADS/bundle/data/flutter_assets/assets/logo.png
   Terminal=false
   Type=Application
   Categories=Utility;Development;
   StartupWMClass=com.tads.sociotads
   Keywords=social;media;twitter;automation;
   ```

   Replace `YOUR_USERNAME` with your actual username.

6. Refresh desktop database:
   ```bash
   update-desktop-database ~/.local/share/applications/
   ```

7. Configure credentials (see [Configuration](#configuration))

8. Launch from your application menu or run:
   ```bash
   ~/.local/share/applications/sociotads.desktop
   ```

#### Creating a System-Wide Installation

For system-wide installation, copy the desktop file to the system directory:

```bash
sudo cp ~/.local/share/applications/sociotads.desktop /usr/share/applications/
sudo cp -r ~/Apps/SocioTADS /opt/sociotads
```

Update the desktop file paths to use `/opt/sociotads/` instead.

#### Uninstallation

```bash
rm ~/.local/share/applications/sociotads.desktop
rm -rf ~/Apps/SocioTADS
```

### Web Version

The web version is available at [https://sociotads.web.app](https://sociotads.web.app).

### From Source

#### Prerequisites

- Flutter SDK 3.0 or later
- Dart SDK
- Git
- Linux build tools (for Linux target)

#### Build Steps

1. Clone the repository:
   ```bash
   git clone https://github.com/TADSTech/socioTADS.git
   cd socioTADS
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Copy and configure `.env`:
   ```bash
   cp .env.example .env
   # Edit .env with your credentials
   nano .env
   ```

4. Build for Linux:
   ```bash
   flutter build linux --release
   ```

   The built application will be in `build/linux/x64/release/bundle/`

5. Or run directly:
   ```bash
   flutter run -d linux
   ```

## Configuration

### API Credentials

Create a `.env` file in the project root with your API keys:

```env
X_API_KEY=your_twitter_api_key
X_API_KEY_SECRET=your_twitter_api_secret
X_BEARER_TOKEN=your_twitter_bearer_token
X_ACCESS_TOKEN=your_twitter_access_token
X_ACCESS_TOKEN_SECRET=your_twitter_access_token_secret
GIT_PAT=your_github_personal_access_token
UNLOCK_CODE=your_11_digit_unlock_code
```

### Getting API Credentials

#### Twitter/X API
1. Go to [Twitter Developer Portal](https://developer.twitter.com/en/portal/dashboard)
2. Create a new app or use existing one
3. Go to Keys and Tokens
4. Generate/copy Consumer Keys and Access Tokens
5. Ensure app has "Read and Write" permissions

#### GitHub Personal Access Token
1. Go to [GitHub Settings > Developer settings > Personal access tokens](https://github.com/settings/tokens)
2. Generate new token with `repo` and `user:email` scopes
3. Copy the token to your `.env` file

### Unlock Code

Set a custom 11-digit numeric unlock code in your `.env` file. Default is `12345678901`.

## Usage

### Unlock Screen

1. Launch the application
2. Enter your 11-digit unlock code
3. Press Enter or tap the unlock button

### Adding Posts

Posts are managed through a GitHub repository in JSON format. The application reads from `.github/json/content.json`.

#### Post Structure

```json
{
  "id": "post_unique_id",
  "text": "Your post content here",
  "time": "2025-12-14T18:00:00",
  "image": "image_filename_or_url.png",
  "hashtags": ["tag1", "tag2"],
  "posted": false
}
```

#### Scheduling Posts

Modify the `time` field to control when posts are published:
- Posts with past timestamps are published immediately
- Posts with future timestamps are scheduled

### Desktop Application Features

- View scheduled posts
- Lock/Unlock application
- Theme toggle (Dark/Light)
- Responsive UI that adapts to window size

## Development

### Prerequisites

- Flutter SDK 3.0+
- Dart SDK
- Git
- Your preferred IDE (VS Code, Android Studio, etc.)

### Project Structure

```
lib/
  main.dart                    # Application entry point
  main_desktop.dart           # Desktop-specific setup
  main_web.dart               # Web-specific setup
  api/
    git_service.dart          # GitHub API integration
  components/
    lock_screen.dart          # Lock screen widget
    titlebar.dart             # Window title bar
  theme/
    app_theme.dart            # App theming
  utils/
    responsive.dart           # Responsive utilities
test/
  git_service_test.dart       # API tests
```

### Running Locally

#### Desktop
```bash
flutter run -d linux
```

#### Web
```bash
flutter run -d web-server
```

#### Tests
```bash
flutter test
```

#### Code Analysis
```bash
flutter analyze
```

### Code Style

- Follow [Dart Effective Dart](https://dart.dev/guides/language/effective-dart) guidelines
- Format code: `flutter format lib/`
- Run analysis: `flutter analyze`

## Contributing

We welcome contributions from the community! Here's how to get started:

### Reporting Issues

Found a bug? Please create an issue with:
- Clear description of the problem
- Steps to reproduce
- Expected behavior vs. actual behavior
- Screenshots (if applicable)
- Your environment (OS, Flutter version, etc.)

### Contributing Code

1. Fork the repository
2. Create a feature branch:
   ```bash
   git checkout -b feature/your-feature-name
   ```

3. Make your changes and commit:
   ```bash
   git commit -m "feat: add your feature description"
   ```

   Use conventional commits:
   - `feat:` for new features
   - `fix:` for bug fixes
   - `docs:` for documentation
   - `refactor:` for code refactoring
   - `test:` for tests

4. Push to your fork:
   ```bash
   git push origin feature/your-feature-name
   ```

5. Open a Pull Request with:
   - Description of changes
   - Related issues (if any)
   - Testing instructions

### Development Workflow

```bash
# Create feature branch
git checkout -b feature/awesome-feature

# Make changes and test
flutter test
flutter analyze

# Format code
flutter format lib/

# Commit with conventional message
git commit -m "feat: add awesome feature"

# Push and create PR
git push origin feature/awesome-feature
```

### Code Quality Standards

- All tests must pass: `flutter test`
- No analysis errors: `flutter analyze`
- Code must be formatted: `flutter format`
- Maintain test coverage

## Troubleshooting

### Application Won't Start

**Issue**: Application crashes on startup

**Solutions**:
- Ensure `.env` file exists in the application directory
- Verify all required API credentials are present
- Check file permissions: `chmod +x bundle/sociotads`
- Review system logs: `journalctl -e`

### Unlock Code Not Working

**Issue**: Cannot unlock the application

**Solutions**:
- Default code is `12345678901`
- Verify `UNLOCK_CODE` in `.env` file
- Ensure you're using a numeric keypad
- Check keyboard layout settings

### Posts Not Publishing

**Issue**: Scheduled posts don't publish automatically

**Solutions**:
- Verify Twitter API has "Read and Write" permissions
- Check internet connection
- Ensure API tokens haven't expired
- Review application logs
- Verify post timestamps are in correct format: `YYYY-MM-DDTHH:MM:SS`

### Web Version Issues

**Issue**: Web app not loading or features not working

**Solutions**:
- Clear browser cache and cookies
- Try in incognito/private mode
- Verify browser supports modern JavaScript
- Check browser console for errors (F12)
- Ensure `.env` file is accessible to web build

### Build Failures

**Issue**: `flutter build` fails

**Solutions**:
```bash
# Clean and retry
flutter clean
flutter pub get
flutter build linux --release
```

## API Integration

### GitHub API

The application uses GitHub API to:
- Store post content in JSON format
- Upload images to repository
- Manage scheduling data

### Twitter/X API

The application uses Twitter API v2 and v1.1 to:
- Post tweets with text and images
- Track post status
- Handle media uploads

## Performance Tips

- Use light theme on older systems for better performance
- Minimize number of scheduled posts for faster load times
- Clear old published posts periodically
- Keep API credentials secure

## Browser Compatibility (Web Version)

- Chrome/Chromium 90+
- Firefox 88+
- Safari 14+
- Edge 90+

## File Structure for Releases

When creating releases, include:
- `sociotads-linux-bundle.zip` - Complete Linux binary bundle
- `.env.example` - Template for environment variables
- Release notes with installation instructions

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Support

- Create an issue on [GitHub Issues](https://github.com/TADSTech/socioTADS/issues)
- Check existing documentation in the repository
- Review code comments for implementation details

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for version history and updates.