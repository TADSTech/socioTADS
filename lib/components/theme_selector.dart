import 'package:flutter/cupertino.dart';
import 'package:sociotads/theme/app_theme.dart';

class ThemeSelectorSheet extends StatelessWidget {
  const ThemeSelectorSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ThemeProvider.of(context);
    final colors = theme.colors;
    final styles = AppTextStyles(colors);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: colors.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          Text('Choose Theme', style: styles.headlineMedium),
          const SizedBox(height: 24),
          _ThemeOption(
            title: 'Dark',
            subtitle: 'Easy on the eyes',
            icon: CupertinoIcons.moon_fill,
            mode: AppThemeMode.dark,
            isSelected: theme.themeMode == AppThemeMode.dark,
            onTap: () {
              theme.setTheme(AppThemeMode.dark);
              Navigator.pop(context);
            },
          ),
          const SizedBox(height: 12),
          _ThemeOption(
            title: 'Light',
            subtitle: 'Clean and bright',
            icon: CupertinoIcons.sun_max_fill,
            mode: AppThemeMode.light,
            isSelected: theme.themeMode == AppThemeMode.light,
            onTap: () {
              theme.setTheme(AppThemeMode.light);
              Navigator.pop(context);
            },
          ),
          const SizedBox(height: 12),
          _ThemeOption(
            title: 'Light Blue',
            subtitle: 'Calm and focused',
            icon: CupertinoIcons.drop_fill,
            mode: AppThemeMode.lightBlue,
            isSelected: theme.themeMode == AppThemeMode.lightBlue,
            onTap: () {
              theme.setTheme(AppThemeMode.lightBlue);
              Navigator.pop(context);
            },
          ),
          const SizedBox(height: 12),
          _ThemeOption(
            title: 'Reading',
            subtitle: 'Warm sepia tones',
            icon: CupertinoIcons.book_fill,
            mode: AppThemeMode.reading,
            isSelected: theme.themeMode == AppThemeMode.reading,
            onTap: () {
              theme.setTheme(AppThemeMode.reading);
              Navigator.pop(context);
            },
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _ThemeOption extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final AppThemeMode mode;
  final bool isSelected;
  final VoidCallback onTap;

  const _ThemeOption({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.mode,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = ThemeProvider.of(context);
    final colors = theme.colors;
    final styles = AppTextStyles(colors);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? colors.accent.withOpacity(0.1) : colors.surfaceSecondary,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? colors.accent : colors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? colors.accent : colors.textSecondary, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: styles.titleMedium),
                  Text(subtitle, style: styles.bodySmall),
                ],
              ),
            ),
            if (isSelected)
              Icon(CupertinoIcons.checkmark_circle_fill, color: colors.accent, size: 24),
          ],
        ),
      ),
    );
  }
}
