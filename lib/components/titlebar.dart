import 'package:flutter/cupertino.dart';
import 'package:sociotads/theme/app_theme.dart';
import 'package:sociotads/utils/responsive.dart';

// Conditional import for bitsdojo_window
import 'titlebar_desktop.dart' if (dart.library.html) 'titlebar_web.dart' as platform;

class CustomTitleBar extends StatelessWidget {
  const CustomTitleBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ThemeProvider.of(context);
    final colors = theme.colors;
    final styles = AppTextStyles(colors);

    // On web, show a simpler header bar
    if (Responsive.isWeb) {
      return _WebTitleBar(colors: colors, styles: styles);
    }

    // On desktop, use the platform-specific titlebar
    return platform.DesktopTitleBar(colors: colors, styles: styles);
  }
}

/// Simple title bar for web - no window controls needed
class _WebTitleBar extends StatelessWidget {
  final AppColors colors;
  final AppTextStyles styles;

  const _WebTitleBar({required this.colors, required this.styles});

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobileScreen(context);

    return Container(
      height: isMobile ? 48 : 36,
      color: colors.surface,
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 12 : 16),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Image.asset(
              'assets/logo.png',
              width: 24,
              height: 24,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: colors.accent,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Center(
                  child: Text(
                    'S',
                    style: TextStyle(
                      color: CupertinoColors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            'SocioTADS',
            style: styles.titleMedium,
          ),
          const Spacer(),
          // Optional: Add theme toggle button on web
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              // Theme toggle handled by ThemeSelectorSheet in main
            },
            child: Icon(
              CupertinoIcons.paintbrush,
              size: 18,
              color: colors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}