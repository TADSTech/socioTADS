# Contributing to SocioTADS

Thank you for your interest in contributing to SocioTADS! This document provides guidelines and instructions for contributing.

## Code of Conduct

Be respectful, inclusive, and constructive in all interactions. We're committed to providing a welcoming and inclusive environment for all contributors.

## Getting Started

### Prerequisites

- Flutter SDK 3.0 or later
- Dart SDK
- Git
- A GitHub account

### Development Setup

1. Fork the repository on GitHub
2. Clone your fork:
   ```bash
   git clone https://github.com/YOUR_USERNAME/socioTADS.git
   cd socioTADS
   ```

3. Add upstream remote:
   ```bash
   git remote add upstream https://github.com/TADSTech/socioTADS.git
   ```

4. Install dependencies:
   ```bash
   flutter pub get
   ```

5. Create your feature branch:
   ```bash
   git checkout -b feature/your-feature-name
   ```

## Development Workflow

### Running Tests

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run specific test file
flutter test test/git_service_test.dart
```

### Code Quality

```bash
# Format code
flutter format lib/

# Run analysis
flutter analyze

# Check for common issues
dart fix --dry-run lib/
```

### Commit Messages

Use conventional commits for clear commit history:

```
<type>(<scope>): <subject>

<body>

<footer>
```

Types:
- `feat:` A new feature
- `fix:` A bug fix
- `docs:` Documentation only changes
- `style:` Changes that don't affect code meaning (formatting, whitespace)
- `refactor:` Code change that neither fixes a bug nor adds a feature
- `perf:` Code change that improves performance
- `test:` Adding missing tests or correcting existing tests
- `chore:` Changes to build process, dependencies, etc.

Examples:
```
feat(lock-screen): add haptic feedback to unlock
fix(api): handle network timeout errors gracefully
docs: update README with installation instructions
refactor: extract common API logic to service class
```

## Making Changes

### Before You Start

1. Check if an issue exists for your feature/bug
2. Create an issue if one doesn't exist
3. Discuss major changes in the issue first
4. Reference the issue in your commit messages

### Creating a Pull Request

1. Ensure all tests pass:
   ```bash
   flutter test
   ```

2. Ensure code is formatted:
   ```bash
   flutter format lib/
   ```

3. Ensure no analysis errors:
   ```bash
   flutter analyze
   ```

4. Push your changes:
   ```bash
   git push origin feature/your-feature-name
   ```

5. Open a Pull Request on GitHub with:
   - Clear title describing the changes
   - Description of what was changed and why
   - Reference to related issues
   - Screenshots for UI changes
   - Testing instructions

### PR Checklist

Before submitting a PR, ensure:
- [ ] Commits follow conventional commit format
- [ ] Code is formatted with `flutter format`
- [ ] All tests pass
- [ ] No analysis errors from `flutter analyze`
- [ ] New features have tests
- [ ] Documentation is updated
- [ ] Changelog is updated (if applicable)

## Coding Standards

### Dart Style Guide

Follow [Effective Dart](https://dart.dev/guides/language/effective-dart):

```dart
// Good
const defaultTimeout = Duration(seconds: 30);
final userName = getUserName();

// Bad
const DEFAULT_TIMEOUT = const Duration(seconds: 30);
var userName = getUserName();
```

### Naming Conventions

- Classes: `PascalCase` (e.g., `LockScreen`)
- Functions/variables: `camelCase` (e.g., `getUserData`)
- Constants: `camelCase` (e.g., `maxRetries`)
- Private members: prefix with underscore (e.g., `_privateVariable`)

### File Organization

```dart
// Order imports: dart, flutter, packages, relative
import 'dart:async';

import 'package:flutter/material.dart';

import 'package:tweepy/tweepy.dart';

import 'services/api_service.dart';
```

### Comments and Documentation

Use documentation comments for public APIs:

```dart
/// Authenticates user with provided credentials.
///
/// Returns a [Future] that resolves to a [User] object on success,
/// or throws [AuthenticationException] on failure.
Future<User> authenticate(String username, String password) async {
  // Implementation
}
```

## Testing Guidelines

### Writing Tests

```dart
void main() {
  group('GitService', () {
    late GitService service;

    setUp(() {
      service = GitService();
    });

    test('should upload file successfully', () async {
      final result = await service.uploadFile('path/to/file');
      expect(result, isNotNull);
    });

    test('should handle network errors', () async {
      expect(
        () => service.uploadFile('invalid'),
        throwsException,
      );
    });
  });
}
```

### Test Coverage

Aim for 80%+ test coverage on new code. Run coverage report:

```bash
flutter test --coverage
```

## Documentation

### README Updates

Update README.md if you:
- Add new features
- Change build or setup instructions
- Add new configuration options

### In-Code Documentation

- Document public methods and classes
- Add comments for complex logic
- Explain the "why", not the "what"

## Reporting Issues

### Bug Reports

Include:
- Clear, descriptive title
- Steps to reproduce
- Expected behavior
- Actual behavior
- Screenshots (if applicable)
- System information (OS, Flutter version, etc.)

### Feature Requests

Include:
- Clear description of the feature
- Why it would be useful
- Possible implementation approach (if any)
- Examples from other applications (if applicable)

## Review Process

1. At least one maintainer will review your PR
2. Address requested changes
3. Ensure all comments are resolved
4. PR will be merged when approved

## Community

- GitHub Issues for bug reports and feature requests
- GitHub Discussions for questions and general discussion
- Pull Requests for code contributions

## Release Process

Version numbering follows [Semantic Versioning](https://semver.org/):
- MAJOR: Breaking changes
- MINOR: New features (backward compatible)
- PATCH: Bug fixes

## Getting Help

- Check existing issues and PRs
- Review documentation
- Ask in GitHub Discussions
- Create an issue with questions

## License

By contributing to SocioTADS, you agree that your contributions will be licensed under its MIT License.

Thank you for contributing to SocioTADS!
