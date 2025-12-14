import 'package:flutter/cupertino.dart';
import 'package:sociotads/theme/app_theme.dart';

/// Web stub for desktop title bar - just returns empty container
/// The actual web titlebar is handled in the main titlebar.dart file
class DesktopTitleBar extends StatelessWidget {
  final AppColors colors;
  final AppTextStyles styles;

  const DesktopTitleBar({
    super.key,
    required this.colors,
    required this.styles,
  });

  @override
  Widget build(BuildContext context) {
    // This should never be called on web since we check isWeb first
    // But return something safe just in case
    return Container(
      height: 36,
      color: colors.surface,
      padding: const EdgeInsets.symmetric(horizontal: 16),
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
        ],
      ),
    );
  }
}
