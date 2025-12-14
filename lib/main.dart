import 'package:flutter/cupertino.dart';
import 'package:cupertino_icons/cupertino_icons.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sociotads/api/git_service.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      title: 'SocioTADS',
      home: LandingPage(),
      debugShowCheckedModeBanner: false,
      theme: CupertinoThemeData(
        textTheme: CupertinoTextThemeData(
          navTitleTextStyle: TextStyle(
            fontFamily: 'BBH_Bogle',
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.white,
      child: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'SocioTADS',
                style: const TextStyle(
                  fontFamily: 'BBH_Bogle',
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: CupertinoColors.black,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Monitor your socials in sleek B&W',
                style: const TextStyle(
                  fontFamily: 'BBH_Bogle',
                  fontSize: 18,
                  color: CupertinoColors.systemGrey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              CupertinoButton.filled(
                onPressed: () {
                  Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (context) => const XPage(),
                    ),
                  );
                },
                child: const SizedBox(
                  width: 200,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(CupertinoIcons.xmark_circle, size: 20),
                      SizedBox(width: 8),
                      Text('Open X'),
                    ],
                  ),
                ),
              ),
            ],
          ),
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

  @override
  void initState() {
    super.initState();
    _postsFuture = _githubService.fetchPosts();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.white,
      navigationBar: CupertinoNavigationBar(
        middle: const Text('X Posts'),
        backgroundColor: CupertinoColors.white,
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            Navigator.of(context).push(
              CupertinoPageRoute(
                builder: (context) => CreatePostPage(
                  onPostCreated: () {
                    setState(() {
                      _postsFuture = _githubService.fetchPosts();
                    });
                  },
                ),
              ),
            );
          },
          child: const Icon(CupertinoIcons.plus),
        ),
      ),
      child: SafeArea(
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _postsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CupertinoActivityIndicator(),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Error loading posts',
                      style: const TextStyle(
                        color: CupertinoColors.systemRed,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 16),
                    CupertinoButton(
                      onPressed: () {
                        setState(() {
                          _postsFuture = _githubService.fetchPosts();
                        });
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            final posts = snapshot.data ?? [];
            if (posts.isEmpty) {
              return const Center(
                child: Text('No posts yet'),
              );
            }

            return ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                return PostCard(post: post);
              },
            );
          },
        ),
      ),
    );
  }
}

class PostCard extends StatelessWidget {
  final Map<String, dynamic> post;

  const PostCard({required this.post});

  String _formatTime(String dateTimeString) {
    final dateTime = DateTime.parse(dateTimeString);
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return dateTime.toString().split(' ')[0];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: CupertinoColors.systemGrey5,
            width: 1,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SocioTADS',
                      style: const TextStyle(
                        fontFamily: 'BBH_Bogle',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: CupertinoColors.black,
                      ),
                    ),
                    Text(
                      '@sociotads',
                      style: const TextStyle(
                        fontFamily: 'BBH_Bogle',
                        fontSize: 14,
                        color: CupertinoColors.systemGrey,
                      ),
                    ),
                  ],
                ),
                Text(
                  _formatTime(post['time'] ?? DateTime.now().toString()),
                  style: const TextStyle(
                    fontFamily: 'BBH_Bogle',
                    fontSize: 12,
                    color: CupertinoColors.systemGrey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              post['text'] ?? '',
              style: const TextStyle(
                fontFamily: 'BBH_Bogle',
                fontSize: 14,
                color: CupertinoColors.black,
              ),
            ),
            if (post['image'] != null && post['image'].toString().isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemGrey6,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Image.network(
                    post['image'],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Icon(CupertinoIcons.photo_fill),
                      );
                    },
                  ),
                ),
              ),
            if (post['hashtags'] != null && (post['hashtags'] as List).isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Wrap(
                  spacing: 8,
                  children: (post['hashtags'] as List<dynamic>)
                      .map((tag) => Text(
                            '#$tag',
                            style: const TextStyle(
                              fontFamily: 'BBH_Bogle',
                              fontSize: 12,
                              color: CupertinoColors.systemBlue,
                            ),
                          ))
                      .toList(),
                ),
              ),
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Row(
                children: [
                  Text(
                    post['posted'] == true ? 'Posted' : 'Scheduled',
                    style: TextStyle(
                      fontFamily: 'BBH_Bogle',
                      fontSize: 12,
                      color: post['posted'] == true
                          ? CupertinoColors.systemGreen
                          : CupertinoColors.systemOrange,
                    ),
                  ),
                ],
              ),
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
  final TextEditingController _imageUrlController = TextEditingController();
  final TextEditingController _hashtagsController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final GitHubService _githubService = GitHubService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _timeController.text = DateTime.now().toString().split('.')[0];
  }

  @override
  void dispose() {
    _textController.dispose();
    _imageUrlController.dispose();
    _hashtagsController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  Future<void> _createPost() async {
    if (_textController.text.isEmpty) {
      _showAlert('Post content cannot be empty');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final hashtags = _hashtagsController.text
          .split(',')
          .map((tag) => tag.trim())
          .where((tag) => tag.isNotEmpty)
          .toList();

      final newPost = {
        'id': 'post_${DateTime.now().millisecondsSinceEpoch}',
        'text': _textController.text,
        'time': _timeController.text,
        'image': _imageUrlController.text.isEmpty ? null : _imageUrlController.text,
        'hashtags': hashtags.isEmpty ? null : hashtags,
        'posted': false,
      };

      await _githubService.createPost(newPost);

      if (mounted) {
        Navigator.of(context).pop();
        widget.onPostCreated();
        _showAlert('Post created successfully!');
      }
    } catch (e) {
      _showAlert('Failed to create post: ${e.toString()}');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showAlert(String message) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Notice'),
        content: Text(message),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.white,
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Create Post'),
        backgroundColor: CupertinoColors.white,
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Post Content',
                style: TextStyle(
                  fontFamily: 'BBH_Bogle',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: CupertinoColors.black,
                ),
              ),
              const SizedBox(height: 8),
              CupertinoTextField(
                controller: _textController,
                placeholder: 'What do you want to post?',
                maxLines: 5,
                padding: const EdgeInsets.all(12),
                style: const TextStyle(fontFamily: 'BBH_Bogle'),
              ),
              const SizedBox(height: 16),
              const Text(
                'Scheduled Time',
                style: TextStyle(
                  fontFamily: 'BBH_Bogle',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: CupertinoColors.black,
                ),
              ),
              const SizedBox(height: 8),
              CupertinoTextField(
                controller: _timeController,
                placeholder: 'YYYY-MM-DDTHH:mm:ss',
                padding: const EdgeInsets.all(12),
                style: const TextStyle(fontFamily: 'BBH_Bogle'),
              ),
              const SizedBox(height: 16),
              const Text(
                'Image URL (Optional)',
                style: TextStyle(
                  fontFamily: 'BBH_Bogle',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: CupertinoColors.black,
                ),
              ),
              const SizedBox(height: 8),
              CupertinoTextField(
                controller: _imageUrlController,
                placeholder: 'https://example.com/image.jpg',
                padding: const EdgeInsets.all(12),
                style: const TextStyle(fontFamily: 'BBH_Bogle'),
              ),
              const SizedBox(height: 16),
              const Text(
                'Hashtags (Optional)',
                style: TextStyle(
                  fontFamily: 'BBH_Bogle',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: CupertinoColors.black,
                ),
              ),
              const SizedBox(height: 8),
              CupertinoTextField(
                controller: _hashtagsController,
                placeholder: 'AI, Technology, Innovation (comma separated)',
                padding: const EdgeInsets.all(12),
                style: const TextStyle(fontFamily: 'BBH_Bogle'),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: CupertinoButton.filled(
                  onPressed: _isLoading ? null : _createPost,
                  child: _isLoading
                      ? const CupertinoActivityIndicator(color: CupertinoColors.white)
                      : const Text('Create Post'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
