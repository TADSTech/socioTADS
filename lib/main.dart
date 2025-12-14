import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:sociotads/api/git_service.dart';
import 'package:sociotads/theme/app_theme.dart';
import 'package:sociotads/components/titlebar.dart';
import 'package:sociotads/components/lock_screen.dart';
import 'package:sociotads/utils/responsive.dart';

// Conditional imports for platform-specific code
import 'main_desktop.dart' if (dart.library.html) 'main_web.dart' as platform;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  
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

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ThemeProvider.of(context);
    final colors = theme.colors;
    final styles = AppTextStyles(colors);
    final isMobile = Responsive.isMobileScreen(context);
    final padding = Responsive.padding(context);

    return CupertinoPageScaffold(
      backgroundColor: colors.background,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: padding,
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: Responsive.maxContentWidth(context),
                minHeight: MediaQuery.of(context).size.height - 100,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: isMobile ? 60 : 80,
                    height: isMobile ? 60 : 80,
                    decoration: BoxDecoration(
                      color: colors.surface,
                      borderRadius: BorderRadius.circular(isMobile ? 16 : 20),
                      border: Border.all(color: colors.border, width: 1),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(isMobile ? 16 : 20),
                      child: Image.asset(
                        'assets/logo.png',
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Icon(
                          CupertinoIcons.chart_bar_alt_fill,
                          size: isMobile ? 30 : 40,
                          color: colors.accent,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: isMobile ? 16 : 24),
                  Text(
                    'SocioTADS', 
                    style: isMobile 
                        ? styles.headlineLarge 
                        : styles.displayLarge,
                  ),
                  SizedBox(height: isMobile ? 8 : 12),
                  Text(
                    'Monitor & schedule your social posts\nwith a beautiful, minimal interface',
                    style: styles.bodyLarge.copyWith(color: colors.textSecondary),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: isMobile ? 32 : 48),
                  Container(
                    padding: EdgeInsets.all(isMobile ? 16 : 20),
                    decoration: BoxDecoration(
                      color: colors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: colors.border, width: 1),
                    ),
                    child: Column(
                      children: [
                        _FeatureRow(
                          icon: CupertinoIcons.graph_circle,
                          title: 'Analytics',
                          subtitle: 'Track post performance',
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Container(height: 1, color: colors.border),
                        ),
                        _FeatureRow(
                          icon: CupertinoIcons.clock,
                          title: 'Scheduling',
                          subtitle: 'Plan posts ahead of time',
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Container(height: 1, color: colors.border),
                        ),
                        _FeatureRow(
                          icon: CupertinoIcons.layers,
                          title: 'Multi-platform',
                          subtitle: 'Manage all socials in one place',
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: isMobile ? 32 : 48),
                  Text('AVAILABLE PLATFORMS', style: styles.caption),
                  SizedBox(height: isMobile ? 12 : 16),
                  SizedBox(
                    width: double.infinity,
                    child: CupertinoButton(
                      color: colors.surface,
                      padding: EdgeInsets.symmetric(vertical: isMobile ? 12 : 16),
                      borderRadius: BorderRadius.circular(12),
                      onPressed: () {
                        Navigator.of(context).push(
                          CupertinoPageRoute(
                            builder: (context) => const XPage(),
                          ),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: colors.textPrimary,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '𝕏',
                              style: TextStyle(
                                fontSize: isMobile ? 14 : 16,
                                fontWeight: FontWeight.bold,
                                color: colors.background,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'X (Twitter)',
                            style: styles.titleMedium,
                          ),
                          const Spacer(),
                          Icon(CupertinoIcons.chevron_right, color: colors.textMuted, size: 20),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: isMobile ? 12 : 16, horizontal: 20),
                    decoration: BoxDecoration(
                      color: colors.surfaceSecondary,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: colors.border, width: 1),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(CupertinoIcons.add, color: colors.textMuted, size: 20),
                        const SizedBox(width: 12),
                        Flexible(
                          child: Text(
                            'More platforms coming soon',
                            style: styles.bodyMedium.copyWith(color: colors.textMuted),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: isMobile ? 24 : 32),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      showCupertinoModalPopup(
                        context: context,
                        builder: (context) => const ThemeSelectorSheet(),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(CupertinoIcons.paintbrush, color: colors.textMuted, size: 18),
                        const SizedBox(width: 8),
                        Text('Change Theme', style: styles.bodySmall),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Helper widget for feature rows in landing page
class _FeatureRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _FeatureRow({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = ThemeProvider.of(context);
    final colors = theme.colors;
    final styles = AppTextStyles(colors);

    return Row(
      children: [
        Icon(icon, color: colors.accent, size: 24),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: styles.titleMedium),
              Text(subtitle, style: styles.bodySmall),
            ],
          ),
        ),
      ],
    );
  }
}

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

class XPage extends StatefulWidget {
  const XPage({super.key});

  @override
  State<XPage> createState() => _XPageState();
}

class _XPageState extends State<XPage> {
  late Future<List<Map<String, dynamic>>> _postsFuture;
  final GitHubService _githubService = GitHubService();
  int _selectedTab = 0;

  @override
  void initState() {
    super.initState();
    _postsFuture = _githubService.fetchPosts();
  }

  void _refreshPosts() {
    setState(() {
      _postsFuture = _githubService.fetchPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = ThemeProvider.of(context);
    final colors = theme.colors;
    final styles = AppTextStyles(colors);
    final isMobile = Responsive.isMobileScreen(context);

    return CupertinoPageScaffold(
      backgroundColor: colors.background,
      navigationBar: CupertinoNavigationBar(
        middle: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: colors.textPrimary,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                '𝕏',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: colors.background,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text('Posts', style: styles.titleLarge),
          ],
        ),
        backgroundColor: colors.surface,
        border: Border(bottom: BorderSide(color: colors.border, width: 0.5)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: _refreshPosts,
              child: Icon(CupertinoIcons.refresh, color: colors.textSecondary, size: isMobile ? 20 : 22),
            ),
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                Navigator.of(context).push(
                  CupertinoPageRoute(
                    builder: (context) => CreatePostPage(onPostCreated: _refreshPosts),
                  ),
                );
              },
              child: Icon(CupertinoIcons.plus_circle_fill, color: colors.accent, size: isMobile ? 24 : 28),
            ),
          ],
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 12 : 16, 
              vertical: isMobile ? 8 : 12,
            ),
            decoration: BoxDecoration(
              color: colors.surface,
              border: Border(bottom: BorderSide(color: colors.border, width: 0.5)),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _TabButton(
                    label: 'All',
                    icon: CupertinoIcons.list_bullet,
                    isSelected: _selectedTab == 0,
                    onTap: () => setState(() => _selectedTab = 0),
                  ),
                  SizedBox(width: isMobile ? 8 : 12),
                  _TabButton(
                    label: 'Scheduled',
                    icon: CupertinoIcons.clock,
                    isSelected: _selectedTab == 1,
                    onTap: () => setState(() => _selectedTab = 1),
                  ),
                  SizedBox(width: isMobile ? 8 : 12),
                  _TabButton(
                    label: 'Posted',
                    icon: CupertinoIcons.checkmark_circle,
                    isSelected: _selectedTab == 2,
                    onTap: () => setState(() => _selectedTab = 2),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _postsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CupertinoActivityIndicator(radius: 16),
                        const SizedBox(height: 16),
                        Text('Loading posts...', style: styles.bodySmall),
                      ],
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(CupertinoIcons.exclamationmark_triangle, color: colors.error, size: 48),
                          const SizedBox(height: 16),
                          Text('Error loading posts', style: styles.titleMedium),
                          const SizedBox(height: 8),
                          Text(
                            snapshot.error.toString(),
                            style: styles.bodySmall,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          CupertinoButton.filled(
                            onPressed: _refreshPosts,
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                var posts = snapshot.data ?? [];
                
                if (_selectedTab == 1) {
                  posts = posts.where((p) => p['posted'] != true).toList();
                } else if (_selectedTab == 2) {
                  posts = posts.where((p) => p['posted'] == true).toList();
                }

                if (posts.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.all(isMobile ? 24 : 32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(CupertinoIcons.doc_text, color: colors.textMuted, size: isMobile ? 40 : 48),
                          const SizedBox(height: 16),
                          Text('No posts yet', style: styles.titleMedium),
                          const SizedBox(height: 8),
                          Text(
                            'Create your first post to get started', 
                            style: styles.bodySmall,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          CupertinoButton.filled(
                            onPressed: () {
                              Navigator.of(context).push(
                                CupertinoPageRoute(
                                  builder: (context) => CreatePostPage(onPostCreated: _refreshPosts),
                                ),
                              );
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(CupertinoIcons.plus, size: 18),
                                SizedBox(width: 8),
                                Text('Create Post'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: Responsive.maxContentWidth(context)),
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(
                        horizontal: isMobile ? 8 : 0,
                        vertical: 8,
                      ),
                      itemCount: posts.length,
                      itemBuilder: (context, index) => PostCard(post: posts[index]),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabButton({
    required this.label,
    required this.icon,
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? colors.accent : colors.surfaceSecondary,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? CupertinoColors.white : colors.textSecondary,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: styles.labelMedium.copyWith(
                color: isSelected ? CupertinoColors.white : colors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PostCard extends StatelessWidget {
  final Map<String, dynamic> post;

  const PostCard({required this.post});

  String _formatTime(String dateTimeString) {
    try {
      final dateTime = DateTime.parse(dateTimeString);
      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.isNegative) {
        final futureDiff = dateTime.difference(now);
        if (futureDiff.inHours < 24) {
          return 'in ${futureDiff.inHours}h';
        } else {
          return 'in ${futureDiff.inDays}d';
        }
      }

      if (difference.inMinutes < 60) {
        return '${difference.inMinutes}m ago';
      } else if (difference.inHours < 24) {
        return '${difference.inHours}h ago';
      } else if (difference.inDays < 7) {
        return '${difference.inDays}d ago';
      } else {
        return dateTime.toString().split(' ')[0];
      }
    } catch (e) {
      return 'Unknown';
    }
  }

  String _formatFullDate(String dateTimeString) {
    try {
      final dateTime = DateTime.parse(dateTimeString);
      final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      return '${months[dateTime.month - 1]} ${dateTime.day}, ${dateTime.year} at ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return 'Unknown date';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = ThemeProvider.of(context);
    final colors = theme.colors;
    final styles = AppTextStyles(colors);
    final isPosted = post['posted'] == true;
    final isMobile = Responsive.isMobileScreen(context);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: isMobile ? 8 : 12, vertical: 6),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.border, width: 1),
      ),
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 12 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: isMobile ? 36 : 44,
                  height: isMobile ? 36 : 44,
                  decoration: BoxDecoration(
                    color: colors.surfaceSecondary,
                    borderRadius: BorderRadius.circular(isMobile ? 18 : 22),
                  ),
                  child: Center(
                    child: Text(
                      '𝕏',
                      style: TextStyle(
                        fontSize: isMobile ? 16 : 20,
                        fontWeight: FontWeight.bold,
                        color: colors.textPrimary,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: isMobile ? 8 : 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text('SocioTADS', style: styles.titleMedium),
                          const SizedBox(width: 4),
                          Icon(CupertinoIcons.checkmark_seal_fill, color: colors.accent, size: 16),
                        ],
                      ),
                      Text('@sociotads', style: styles.bodySmall),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: isPosted ? colors.success.withOpacity(0.15) : colors.warning.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isPosted ? CupertinoIcons.checkmark_circle_fill : CupertinoIcons.clock_fill,
                        size: 14,
                        color: isPosted ? colors.success : colors.warning,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        isPosted ? 'Posted' : 'Scheduled',
                        style: styles.caption.copyWith(
                          color: isPosted ? colors.success : colors.warning,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              post['text'] ?? '',
              style: styles.bodyLarge,
            ),
            if (post['image'] != null && post['image'].toString().isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: double.infinity,
                    height: 180,
                    color: colors.surfaceSecondary,
                    child: Image.network(
                      post['image'],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(CupertinoIcons.photo, color: colors.textMuted, size: 32),
                              const SizedBox(height: 8),
                              Text('Image unavailable', style: styles.caption),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            if (post['hashtags'] != null && (post['hashtags'] as List).isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: (post['hashtags'] as List<dynamic>)
                      .map((tag) => Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: colors.accent.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '#$tag',
                              style: styles.labelMedium.copyWith(color: colors.accent),
                            ),
                          ))
                      .toList(),
                ),
              ),
            const SizedBox(height: 16),
            Container(height: 1, color: colors.border),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(CupertinoIcons.calendar, size: 14, color: colors.textMuted),
                const SizedBox(width: 6),
                Text(
                  _formatFullDate(post['time'] ?? DateTime.now().toString()),
                  style: styles.caption,
                ),
                const Spacer(),
                Text(
                  _formatTime(post['time'] ?? DateTime.now().toString()),
                  style: styles.labelMedium.copyWith(color: colors.textSecondary),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CreatePostPage extends StatefulWidget {
  final VoidCallback onPostCreated;

  const CreatePostPage({required this.onPostCreated});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _hashtagsController = TextEditingController();
  DateTime _scheduledTime = DateTime.now().add(const Duration(hours: 1));
  final GitHubService _githubService = GitHubService();
  bool _isLoading = false;
  bool _isUploadingImage = false;
  PlatformFile? _selectedFile;
  Uint8List? _selectedImageBytes;
  String? _uploadedImageUrl;

  @override
  void dispose() {
    _textController.dispose();
    _hashtagsController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
        withData: true, // Important for web support
      );

      if (result != null && result.files.single.bytes != null) {
        setState(() {
          _selectedFile = result.files.single;
          _selectedImageBytes = result.files.single.bytes;
          _uploadedImageUrl = null;
        });
      }
    } catch (e) {
      _showAlert('Error', 'Failed to pick image: ${e.toString()}');
    }
  }

  Future<void> _uploadImage() async {
    if (_selectedImageBytes == null || _selectedFile == null) return;

    setState(() => _isUploadingImage = true);

    try {
      final url = await _githubService.uploadImageBytes(
        _selectedImageBytes!, 
        _selectedFile!.name,
      );
      setState(() {
        _uploadedImageUrl = url;
        _isUploadingImage = false;
      });
    } catch (e) {
      setState(() => _isUploadingImage = false);
      _showAlert('Error', 'Failed to upload image: ${e.toString()}');
    }
  }

  void _removeImage() {
    setState(() {
      _selectedFile = null;
      _selectedImageBytes = null;
      _uploadedImageUrl = null;
    });
  }

  Future<void> _createPost() async {
    if (_textController.text.isEmpty) {
      _showAlert('Error', 'Post content cannot be empty');
      return;
    }

    setState(() => _isLoading = true);

    try {
      String? imageUrl = _uploadedImageUrl;
      
      if (_selectedImageBytes != null && _selectedFile != null && imageUrl == null) {
        imageUrl = await _githubService.uploadImageBytes(
          _selectedImageBytes!,
          _selectedFile!.name,
        );
      }

      final hashtags = _hashtagsController.text
          .split(',')
          .map((tag) => tag.trim())
          .where((tag) => tag.isNotEmpty)
          .toList();

      final newPost = {
        'id': 'post_${DateTime.now().millisecondsSinceEpoch}',
        'text': _textController.text,
        'time': _scheduledTime.toIso8601String(),
        'image': imageUrl,
        'hashtags': hashtags.isEmpty ? null : hashtags,
        'posted': false,
      };

      await _githubService.createPost(newPost);

      if (mounted) {
        Navigator.of(context).pop();
        widget.onPostCreated();
      }
    } catch (e) {
      _showAlert('Error', 'Failed to create post: ${e.toString()}');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showAlert(String title, String message) {
    final theme = ThemeProvider.of(context);
    final colors = theme.colors;

    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK', style: TextStyle(color: colors.accent)),
          ),
        ],
      ),
    );
  }

  void _showDatePicker() {
    final theme = ThemeProvider.of(context);
    final colors = theme.colors;

    showCupertinoModalPopup(
      context: context,
      builder: (context) => Container(
        height: 300,
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancel', style: TextStyle(color: colors.textSecondary)),
                  ),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () => Navigator.pop(context),
                    child: Text('Done', style: TextStyle(color: colors.accent)),
                  ),
                ],
              ),
            ),
            Expanded(
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.dateAndTime,
                initialDateTime: _scheduledTime,
                minimumDate: DateTime.now(),
                onDateTimeChanged: (DateTime value) {
                  setState(() => _scheduledTime = value);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = ThemeProvider.of(context);
    final colors = theme.colors;
    final styles = AppTextStyles(colors);
    final isMobile = Responsive.isMobileScreen(context);
    final padding = Responsive.padding(context);

    return CupertinoPageScaffold(
      backgroundColor: colors.background,
      navigationBar: CupertinoNavigationBar(
        middle: Text('Create Post', style: styles.titleLarge),
        backgroundColor: colors.surface,
        border: Border(bottom: BorderSide(color: colors.border, width: 0.5)),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel', style: TextStyle(color: colors.textSecondary)),
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: _isLoading ? null : _createPost,
          child: _isLoading
              ? const CupertinoActivityIndicator()
              : Text('Post', style: TextStyle(color: colors.accent, fontWeight: FontWeight.w600)),
        ),
      ),
      child: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: Responsive.maxContentWidth(context)),
            child: SingleChildScrollView(
              padding: padding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(isMobile ? 16 : 20),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: colors.border, width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(CupertinoIcons.pencil, color: colors.accent, size: 20),
                        const SizedBox(width: 8),
                        Text('Post Content', style: styles.labelLarge),
                      ],
                    ),
                    const SizedBox(height: 12),
                    CupertinoTextField(
                      controller: _textController,
                      placeholder: 'What would you like to share?',
                      maxLines: 6,
                      minLines: 4,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: colors.surfaceSecondary,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: colors.border, width: 1),
                      ),
                      placeholderStyle: TextStyle(color: colors.textMuted, fontFamily: 'BBH_Bogle'),
                      style: styles.bodyLarge,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(CupertinoIcons.number, size: 14, color: colors.textMuted),
                        const SizedBox(width: 4),
                        Text('280 characters max', style: styles.caption),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: colors.border, width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(CupertinoIcons.clock, color: colors.accent, size: 20),
                        const SizedBox(width: 8),
                        Text('Schedule', style: styles.labelLarge),
                      ],
                    ),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: _showDatePicker,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: colors.surfaceSecondary,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: colors.border, width: 1),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${_scheduledTime.day}/${_scheduledTime.month}/${_scheduledTime.year}',
                                    style: styles.titleMedium,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${_scheduledTime.hour.toString().padLeft(2, '0')}:${_scheduledTime.minute.toString().padLeft(2, '0')}',
                                    style: styles.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                            Icon(CupertinoIcons.chevron_down, color: colors.textMuted, size: 18),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: colors.border, width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(CupertinoIcons.photo, color: colors.accent, size: 20),
                        const SizedBox(width: 8),
                        Text('Media', style: styles.labelLarge),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: colors.surfaceSecondary,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text('Optional', style: styles.caption),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (_selectedImageBytes != null) ...[
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.memory(
                              _selectedImageBytes!,
                              height: isMobile ? 120 : 150,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Row(
                              children: [
                                if (_uploadedImageUrl != null)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: colors.success.withOpacity(0.9),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(CupertinoIcons.checkmark_circle_fill, size: 14, color: CupertinoColors.white),
                                        const SizedBox(width: 4),
                                        Text('Uploaded', style: styles.caption.copyWith(color: CupertinoColors.white)),
                                      ],
                                    ),
                                  ),
                                const SizedBox(width: 8),
                                GestureDetector(
                                  onTap: _removeImage,
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: colors.error.withOpacity(0.9),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(CupertinoIcons.xmark, size: 16, color: CupertinoColors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (_isUploadingImage)
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: colors.background.withOpacity(0.7),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const CupertinoActivityIndicator(),
                                      const SizedBox(height: 8),
                                      Text('Uploading...', style: styles.bodySmall),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      if (_uploadedImageUrl == null)
                        SizedBox(
                          width: double.infinity,
                          child: CupertinoButton(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            color: colors.accent,
                            borderRadius: BorderRadius.circular(10),
                            onPressed: _isUploadingImage ? null : _uploadImage,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(CupertinoIcons.cloud_upload, size: 18, color: CupertinoColors.white),
                                const SizedBox(width: 8),
                                Text('Upload to GitHub', style: styles.labelMedium.copyWith(color: CupertinoColors.white)),
                              ],
                            ),
                          ),
                        ),
                    ] else
                      GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 32),
                          decoration: BoxDecoration(
                            color: colors.surfaceSecondary,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: colors.border, width: 1, style: BorderStyle.solid),
                          ),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: colors.accent.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(CupertinoIcons.photo_on_rectangle, color: colors.accent, size: 32),
                              ),
                              const SizedBox(height: 12),
                              Text('Click to select an image', style: styles.titleMedium),
                              const SizedBox(height: 4),
                              Text('PNG, JPG, GIF up to 10MB', style: styles.caption),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: colors.border, width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(CupertinoIcons.number, color: colors.accent, size: 20),
                        const SizedBox(width: 8),
                        Text('Hashtags', style: styles.labelLarge),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: colors.surfaceSecondary,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text('Optional', style: styles.caption),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    CupertinoTextField(
                      controller: _hashtagsController,
                      placeholder: 'AI, Technology, Innovation',
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: colors.surfaceSecondary,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: colors.border, width: 1),
                      ),
                      placeholderStyle: TextStyle(color: colors.textMuted, fontFamily: 'BBH_Bogle'),
                      style: styles.bodyMedium,
                    ),
                    const SizedBox(height: 8),
                    Text('Separate with commas', style: styles.caption),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: CupertinoButton(
                  color: colors.accent,
                  borderRadius: BorderRadius.circular(12),
                  onPressed: _isLoading ? null : _createPost,
                  child: _isLoading
                      ? const CupertinoActivityIndicator(color: CupertinoColors.white)
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(CupertinoIcons.paperplane_fill, size: 18),
                            const SizedBox(width: 8),
                            Text('Schedule Post', style: styles.titleMedium.copyWith(color: CupertinoColors.white)),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 16),
            ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
