import 'package:flutter/cupertino.dart';

enum AppThemeMode { dark, light, lightBlue, reading }

class AppColors {
  final Color background;
  final Color surface;
  final Color surfaceSecondary;
  final Color primary;
  final Color accent;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color border;
  final Color success;
  final Color warning;
  final Color error;
  final Brightness brightness;

  const AppColors({
    required this.background,
    required this.surface,
    required this.surfaceSecondary,
    required this.primary,
    required this.accent,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.border,
    required this.success,
    required this.warning,
    required this.error,
    required this.brightness,
  });

  static const dark = AppColors(
    background: Color(0xFF0D0D0D),
    surface: Color(0xFF1A1A1A),
    surfaceSecondary: Color(0xFF2A2A2A),
    primary: Color(0xFFFFFFFF),
    accent: Color(0xFF3B82F6),
    textPrimary: Color(0xFFFFFFFF),
    textSecondary: Color(0xFFAAAAAA),
    textMuted: Color(0xFF666666),
    border: Color(0xFF333333),
    success: Color(0xFF22C55E),
    warning: Color(0xFFF59E0B),
    error: Color(0xFFEF4444),
    brightness: Brightness.dark,
  );

  static const light = AppColors(
    background: Color(0xFFFAFAFA),
    surface: Color(0xFFFFFFFF),
    surfaceSecondary: Color(0xFFF5F5F5),
    primary: Color(0xFF000000),
    accent: Color(0xFF3B82F6),
    textPrimary: Color(0xFF111111),
    textSecondary: Color(0xFF555555),
    textMuted: Color(0xFF999999),
    border: Color(0xFFE5E5E5),
    success: Color(0xFF16A34A),
    warning: Color(0xFFD97706),
    error: Color(0xFFDC2626),
    brightness: Brightness.light,
  );

  static const lightBlue = AppColors(
    background: Color(0xFFF0F9FF),
    surface: Color(0xFFFFFFFF),
    surfaceSecondary: Color(0xFFE0F2FE),
    primary: Color(0xFF0369A1),
    accent: Color(0xFF0EA5E9),
    textPrimary: Color(0xFF0C4A6E),
    textSecondary: Color(0xFF0369A1),
    textMuted: Color(0xFF7DD3FC),
    border: Color(0xFFBAE6FD),
    success: Color(0xFF059669),
    warning: Color(0xFFD97706),
    error: Color(0xFFDC2626),
    brightness: Brightness.light,
  );

  static const reading = AppColors(
    background: Color(0xFFFDF6E3),
    surface: Color(0xFFFAF3DD),
    surfaceSecondary: Color(0xFFF5EDCE),
    primary: Color(0xFF5C4827),
    accent: Color(0xFF8B7355),
    textPrimary: Color(0xFF3D3019),
    textSecondary: Color(0xFF6B5B3E),
    textMuted: Color(0xFFA89F8A),
    border: Color(0xFFE8DFC5),
    success: Color(0xFF6B8E23),
    warning: Color(0xFFB8860B),
    error: Color(0xFFCD5C5C),
    brightness: Brightness.light,
  );

  static AppColors fromMode(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.dark:
        return dark;
      case AppThemeMode.light:
        return light;
      case AppThemeMode.lightBlue:
        return lightBlue;
      case AppThemeMode.reading:
        return reading;
    }
  }
}

class ThemeProvider extends InheritedWidget {
  final AppThemeMode themeMode;
  final AppColors colors;
  final void Function(AppThemeMode) setTheme;

  const ThemeProvider({
    super.key,
    required this.themeMode,
    required this.colors,
    required this.setTheme,
    required super.child,
  });

  static ThemeProvider of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<ThemeProvider>();
    assert(result != null, 'No ThemeProvider found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(ThemeProvider oldWidget) {
    return themeMode != oldWidget.themeMode;
  }
}

class AppTextStyles {
  final AppColors colors;

  AppTextStyles(this.colors);

  TextStyle get displayLarge => TextStyle(
    fontFamily: 'BBH_Bogle',
    fontSize: 42,
    fontWeight: FontWeight.bold,
    color: colors.textPrimary,
    letterSpacing: -1,
  );

  TextStyle get displayMedium => TextStyle(
    fontFamily: 'BBH_Bogle',
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: colors.textPrimary,
  );

  TextStyle get headlineLarge => TextStyle(
    fontFamily: 'BBH_Bogle',
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: colors.textPrimary,
  );

  TextStyle get headlineMedium => TextStyle(
    fontFamily: 'BBH_Bogle',
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: colors.textPrimary,
  );

  TextStyle get titleLarge => TextStyle(
    fontFamily: 'BBH_Bogle',
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: colors.textPrimary,
  );

  TextStyle get titleMedium => TextStyle(
    fontFamily: 'BBH_Bogle',
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: colors.textPrimary,
  );

  TextStyle get bodyLarge => TextStyle(
    fontFamily: 'BBH_Bogle',
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: colors.textPrimary,
  );

  TextStyle get bodyMedium => TextStyle(
    fontFamily: 'BBH_Bogle',
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: colors.textPrimary,
  );

  TextStyle get bodySmall => TextStyle(
    fontFamily: 'BBH_Bogle',
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: colors.textSecondary,
  );

  TextStyle get labelLarge => TextStyle(
    fontFamily: 'BBH_Bogle',
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: colors.textPrimary,
  );

  TextStyle get labelMedium => TextStyle(
    fontFamily: 'BBH_Bogle',
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: colors.textSecondary,
  );

  TextStyle get caption => TextStyle(
    fontFamily: 'BBH_Bogle',
    fontSize: 11,
    fontWeight: FontWeight.normal,
    color: colors.textMuted,
  );
}
