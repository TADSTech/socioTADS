import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:sociotads/api/git_service.dart';
import 'package:sociotads/theme/app_theme.dart';
import 'package:sociotads/utils/responsive.dart';

class CreatePostPage extends StatefulWidget {
  final VoidCallback onPostCreated;

  const CreatePostPage({super.key, required this.onPostCreated});

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
