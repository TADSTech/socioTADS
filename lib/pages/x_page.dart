import 'package:flutter/cupertino.dart';
import 'package:sociotads/api/git_service.dart';
import 'package:sociotads/pages/create_post_page.dart';
import 'package:sociotads/theme/app_theme.dart';
import 'package:sociotads/utils/responsive.dart';

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

  void _showAIGeneratorSheet(BuildContext context, AppColors colors, AppTextStyles styles) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: Text('Generate AI Tweet', style: styles.titleMedium),
        message: Text(
          'Trigger the GitHub Action to generate an AI-powered tweet',
          style: styles.bodySmall,
        ),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              _triggerAIGeneration('news');
            },
            isDefaultAction: true,
            child: Text('📰 News Tweet'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              _triggerAIGeneration('insight');
            },
            isDefaultAction: true,
            child: Text('💡 Insight Tweet'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              _triggerAIGeneration('tip');
            },
            isDefaultAction: true,
            child: Text('🎯 Tip Tweet'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              _triggerAIGeneration('future');
            },
            isDefaultAction: true,
            child: Text('🚀 Future Tweet'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(context),
          isDestructiveAction: false,
          child: const Text('Cancel'),
        ),
      ),
    );
  }

  void _triggerAIGeneration(String category) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Generating Tweet'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            const CupertinoActivityIndicator(radius: 12),
            const SizedBox(height: 16),
            Text(
              'Triggering GitHub Action...\nCategory: $category',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 12),
            const Text(
              'This will generate a new tweet and commit it to the repository.',
              style: TextStyle(fontSize: 11, color: CupertinoColors.systemGrey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () {
              Navigator.pop(context);
              // Launch GitHub Actions workflow
              _launchGitHubAction(category);
            },
            isDefaultAction: true,
            child: const Text('Proceed'),
          ),
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(context),
            isDestructiveAction: true,
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _launchGitHubAction(String category) async {
    try {
      await _githubService.triggerWorkflow(
        'generate-ai-tweet.yml',
        inputs: {
          'category': category,
          'schedule_hours': '2',
          'char_limit': '280', // Updated to standard X limit
        },
      );

      if (!mounted) return;
      
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('GitHub Action Triggered'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              const Icon(CupertinoIcons.checkmark_circle_fill, 
                color: CupertinoColors.systemGreen, size: 48),
              const SizedBox(height: 12),
              Text(
                'Tweet generation started!\n\nCategory: $category\n\nThe new post will appear shortly.',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13),
              ),
            ],
          ),
          actions: [
            CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(context);
                // Refresh posts after a delay to allow the action to complete
                Future.delayed(const Duration(seconds: 10), _refreshPosts);
              },
              isDefaultAction: true,
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } catch (e) {
      if (!mounted) return;
      
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('Error'),
          content: Text('Failed to trigger action: $e'),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
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
              onPressed: () => _showAIGeneratorSheet(context, colors, styles),
              child: Icon(CupertinoIcons.sparkles, color: colors.accent, size: isMobile ? 20 : 22),
            ),
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

  const PostCard({super.key, required this.post});

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
