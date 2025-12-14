import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sociotads/theme/app_theme.dart';

void main() {
  group('AppColors', () {
    test('dark theme has correct background color', () {
      expect(AppColors.dark.background, const Color(0xFF0D0D0D));
    });

    test('dark theme has dark brightness', () {
      expect(AppColors.dark.brightness, Brightness.dark);
    });

    test('light theme has correct background color', () {
      expect(AppColors.light.background, const Color(0xFFFAFAFA));
    });

    test('light theme has light brightness', () {
      expect(AppColors.light.brightness, Brightness.light);
    });

    test('lightBlue theme has correct accent color', () {
      expect(AppColors.lightBlue.accent, const Color(0xFF0EA5E9));
    });

    test('reading theme has warm background', () {
      expect(AppColors.reading.background, const Color(0xFFFDF6E3));
    });

    test('fromMode returns correct theme for dark', () {
      final colors = AppColors.fromMode(AppThemeMode.dark);
      expect(colors.background, AppColors.dark.background);
    });

    test('fromMode returns correct theme for light', () {
      final colors = AppColors.fromMode(AppThemeMode.light);
      expect(colors.background, AppColors.light.background);
    });

    test('fromMode returns correct theme for lightBlue', () {
      final colors = AppColors.fromMode(AppThemeMode.lightBlue);
      expect(colors.background, AppColors.lightBlue.background);
    });

    test('fromMode returns correct theme for reading', () {
      final colors = AppColors.fromMode(AppThemeMode.reading);
      expect(colors.background, AppColors.reading.background);
    });
  });

  group('AppTextStyles', () {
    test('displayLarge uses correct font family', () {
      final styles = AppTextStyles(AppColors.dark);
      expect(styles.displayLarge.fontFamily, 'BBH_Bogle');
    });

    test('displayLarge has correct font size', () {
      final styles = AppTextStyles(AppColors.dark);
      expect(styles.displayLarge.fontSize, 42);
    });

    test('bodyLarge uses theme text color', () {
      final styles = AppTextStyles(AppColors.dark);
      expect(styles.bodyLarge.color, AppColors.dark.textPrimary);
    });

    test('bodySmall uses secondary text color', () {
      final styles = AppTextStyles(AppColors.dark);
      expect(styles.bodySmall.color, AppColors.dark.textSecondary);
    });

    test('caption uses muted text color', () {
      final styles = AppTextStyles(AppColors.dark);
      expect(styles.caption.color, AppColors.dark.textMuted);
    });
  });

  group('AppThemeMode', () {
    test('has 4 theme modes', () {
      expect(AppThemeMode.values.length, 4);
    });

    test('contains dark mode', () {
      expect(AppThemeMode.values.contains(AppThemeMode.dark), true);
    });

    test('contains light mode', () {
      expect(AppThemeMode.values.contains(AppThemeMode.light), true);
    });

    test('contains lightBlue mode', () {
      expect(AppThemeMode.values.contains(AppThemeMode.lightBlue), true);
    });

    test('contains reading mode', () {
      expect(AppThemeMode.values.contains(AppThemeMode.reading), true);
    });
  });

  group('ThemeProvider', () {
    testWidgets('provides theme to children', (WidgetTester tester) async {
      late AppColors capturedColors;
      late AppThemeMode capturedMode;

      await tester.pumpWidget(
        ThemeProvider(
          themeMode: AppThemeMode.dark,
          colors: AppColors.dark,
          setTheme: (_) {},
          child: Builder(
            builder: (context) {
              final theme = ThemeProvider.of(context);
              capturedColors = theme.colors;
              capturedMode = theme.themeMode;
              return const SizedBox();
            },
          ),
        ),
      );

      expect(capturedMode, AppThemeMode.dark);
      expect(capturedColors.background, AppColors.dark.background);
    });

    testWidgets('setTheme callback is accessible', (WidgetTester tester) async {
      var themeModeChanged = false;

      await tester.pumpWidget(
        ThemeProvider(
          themeMode: AppThemeMode.dark,
          colors: AppColors.dark,
          setTheme: (mode) {
            themeModeChanged = true;
          },
          child: Builder(
            builder: (context) {
              final theme = ThemeProvider.of(context);
              theme.setTheme(AppThemeMode.light);
              return const SizedBox();
            },
          ),
        ),
      );

      expect(themeModeChanged, true);
    });
  });
}
