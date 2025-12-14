# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-12-14

### Added
- Initial release of SocioTADS
- Cross-platform support (Linux, macOS, Windows, Web)
- Twitter/X API integration for automated posting
- GitHub API integration for content management
- Lock screen with 11-digit numeric unlock code
- Post scheduling with automatic publication
- Image upload and media management
- Responsive design for various screen sizes
- Dark/Light theme support
- Desktop application with window controls
- Web version at sociotads.web.app
- Linux desktop integration with .desktop file support

### Features
- Schedule posts with future timestamps
- Upload images from local files or remote URLs
- Manage posts through GitHub JSON format
- Secure unlock code protection
- Cross-platform file handling

### Fixed
- DateTime parsing for ISO 8601 timestamps with milliseconds
- Environment variable loading for web builds
- Media ID initialization in post publishing

### Technical
- Built with Flutter 3.0+
- Uses Dart with modern async/await patterns
- Tweepy integration for Twitter API
- Firebase hosting for web deployment
- GitHub Actions for CI/CD

## [Unreleased]

### Planned Features
- Post analytics and statistics
- Multiple account support
- Advanced scheduling with recurring posts
- Hashtag management and trending analysis
- Post templates and drafts
- Search and filter functionality
- Mobile app version
- Offline post queuing
- Post retry mechanism for failed publications
