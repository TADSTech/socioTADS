import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

/// Responsive breakpoints for the app
class Breakpoints {
  static const double mobile = 600;
  static const double tablet = 900;
  static const double desktop = 1200;
}

/// Screen size categories
enum ScreenSize {
  mobile,
  tablet,
  desktop,
}

/// Utility class for responsive design and platform detection
class Responsive {
  /// Check if running on web
  static bool get isWeb => kIsWeb;

  /// Check if running on desktop (not web)
  static bool get isDesktop {
    if (kIsWeb) return false;
    try {
      return Platform.isWindows || Platform.isMacOS || Platform.isLinux;
    } catch (e) {
      return false;
    }
  }

  /// Check if running on mobile (not web)
  static bool get isMobile {
    if (kIsWeb) return false;
    try {
      return Platform.isIOS || Platform.isAndroid;
    } catch (e) {
      return false;
    }
  }

  /// Check if running on Linux
  static bool get isLinux {
    if (kIsWeb) return false;
    try {
      return Platform.isLinux;
    } catch (e) {
      return false;
    }
  }

  /// Check if running on Windows
  static bool get isWindows {
    if (kIsWeb) return false;
    try {
      return Platform.isWindows;
    } catch (e) {
      return false;
    }
  }

  /// Check if running on macOS
  static bool get isMacOS {
    if (kIsWeb) return false;
    try {
      return Platform.isMacOS;
    } catch (e) {
      return false;
    }
  }

  /// Get current screen size category based on width
  static ScreenSize getScreenSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < Breakpoints.mobile) {
      return ScreenSize.mobile;
    } else if (width < Breakpoints.tablet) {
      return ScreenSize.tablet;
    } else {
      return ScreenSize.desktop;
    }
  }

  /// Check if current screen is mobile sized
  static bool isMobileScreen(BuildContext context) {
    return MediaQuery.of(context).size.width < Breakpoints.mobile;
  }

  /// Check if current screen is tablet sized
  static bool isTabletScreen(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= Breakpoints.mobile && width < Breakpoints.tablet;
  }

  /// Check if current screen is desktop sized
  static bool isDesktopScreen(BuildContext context) {
    return MediaQuery.of(context).size.width >= Breakpoints.tablet;
  }

  /// Get responsive value based on screen size
  static T value<T>(
    BuildContext context, {
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    final screenSize = getScreenSize(context);
    switch (screenSize) {
      case ScreenSize.mobile:
        return mobile;
      case ScreenSize.tablet:
        return tablet ?? mobile;
      case ScreenSize.desktop:
        return desktop ?? tablet ?? mobile;
    }
  }

  /// Get responsive padding based on screen size
  static EdgeInsets padding(BuildContext context) {
    return value(
      context,
      mobile: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      tablet: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      desktop: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
    );
  }

  /// Get responsive content max width
  static double maxContentWidth(BuildContext context) {
    return value(
      context,
      mobile: double.infinity,
      tablet: 700.0,
      desktop: 900.0,
    );
  }

  /// Get responsive font scale
  static double fontScale(BuildContext context) {
    return value(
      context,
      mobile: 1.0,
      tablet: 1.05,
      desktop: 1.1,
    );
  }

  /// Get responsive card width for grid layouts
  static double cardWidth(BuildContext context) {
    return value(
      context,
      mobile: double.infinity,
      tablet: 340.0,
      desktop: 400.0,
    );
  }

  /// Get number of columns for grid layout
  static int gridColumns(BuildContext context) {
    return value(
      context,
      mobile: 1,
      tablet: 2,
      desktop: 3,
    );
  }
}

/// A widget that builds different layouts based on screen size
class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, ScreenSize screenSize) builder;

  const ResponsiveBuilder({
    super.key,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        ScreenSize screenSize;
        if (constraints.maxWidth < Breakpoints.mobile) {
          screenSize = ScreenSize.mobile;
        } else if (constraints.maxWidth < Breakpoints.tablet) {
          screenSize = ScreenSize.tablet;
        } else {
          screenSize = ScreenSize.desktop;
        }
        return builder(context, screenSize);
      },
    );
  }
}

/// A widget that shows different children based on screen size
class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, screenSize) {
        switch (screenSize) {
          case ScreenSize.mobile:
            return mobile;
          case ScreenSize.tablet:
            return tablet ?? mobile;
          case ScreenSize.desktop:
            return desktop ?? tablet ?? mobile;
        }
      },
    );
  }
}

/// Wrapper that constrains content to max width and centers it
class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final double? maxWidth;
  final EdgeInsets? padding;
  final bool center;

  const ResponsiveContainer({
    super.key,
    required this.child,
    this.maxWidth,
    this.padding,
    this.center = true,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveMaxWidth = maxWidth ?? Responsive.maxContentWidth(context);
    final effectivePadding = padding ?? Responsive.padding(context);

    Widget content = ConstrainedBox(
      constraints: BoxConstraints(maxWidth: effectiveMaxWidth),
      child: child,
    );

    if (center) {
      content = Center(child: content);
    }

    return Padding(
      padding: effectivePadding,
      child: content,
    );
  }
}
