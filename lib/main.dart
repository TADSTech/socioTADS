import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sociotads/components/lock_screen.dart';
import 'package:sociotads/components/titlebar.dart';
import 'package:sociotads/pages/landing_page.dart';
import 'package:sociotads/theme/app_theme.dart';

// Conditional imports for platform-specific code
import 'main_desktop.dart' if (dart.library.html) 'main_web.dart' as platform;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load environment variables - handle web builds differently
  if (!kIsWeb) {
    // Desktop: load from .env file
    try {
      await dotenv.load(fileName: ".env");
    } catch (e) {
      if (kDebugMode) {
        print('Warning: Could not load .env file: $e');
      }
    }
  }
  
  runApp(const MyApp());
  
  // Initialize desktop window if on desktop platform
  platform.initializeWindow();
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AppThemeMode _themeMode = AppThemeMode.dark;

  void _setTheme(AppThemeMode mode) {
    setState(() => _themeMode = mode);
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.fromMode(_themeMode);
    
    return ThemeProvider(
      themeMode: _themeMode,
      colors: colors,
      setTheme: _setTheme,
      child: CupertinoApp(
        title: 'SocioTADS',
        debugShowCheckedModeBanner: false,
        theme: CupertinoThemeData(
          brightness: colors.brightness,
          primaryColor: colors.accent,
          scaffoldBackgroundColor: colors.background,
          barBackgroundColor: colors.surface,
          textTheme: CupertinoTextThemeData(
            primaryColor: colors.textPrimary,
            navTitleTextStyle: TextStyle(
              fontFamily: 'BBH_Bogle',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: colors.textPrimary,
            ),
            navActionTextStyle: TextStyle(
              fontFamily: 'BBH_Bogle',
              color: colors.accent,
            ),
          ),
        ),
        home: const LockScreen(
          child: LandingPage(),
        ),
        builder: (context, child) {
          return Column(
            children: [
              const CustomTitleBar(),
              Expanded(child: child ?? const SizedBox()),
            ],
          );
        },
      ),
    );
  }
}
