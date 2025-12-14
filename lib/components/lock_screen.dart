import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sociotads/theme/app_theme.dart';
import 'package:sociotads/utils/responsive.dart';

/// Lock screen that requires a code to unlock the app
class LockScreen extends StatefulWidget {
  final Widget child;
  final VoidCallback? onUnlocked;

  const LockScreen({
    super.key,
    required this.child,
    this.onUnlocked,
  });

  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> with SingleTickerProviderStateMixin {
  bool _isUnlocked = false;
  bool _isLoading = false;
  String _enteredCode = '';
  String _errorMessage = '';
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  // The expected code from environment variable with fallback
  String get _expectedCode {
    try {
      return dotenv.env['UNLOCK_CODE'] ?? '12345678901';
    } catch (e) {
      // dotenv not initialized yet, use default
      return '12345678901';
    }
  }

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _shakeAnimation = Tween<double>(begin: 0, end: 10)
        .chain(CurveTween(curve: Curves.elasticIn))
        .animate(_shakeController);
    _shakeController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _shakeController.reverse();
      }
    });
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  void _onNumberPressed(String number) {
    if (_enteredCode.length >= 11) return;
    
    setState(() {
      _enteredCode += number;
      _errorMessage = '';
    });

    // Auto-submit when code is complete
    if (_enteredCode.length == 11) {
      _verifyCode();
    }
  }

  void _onBackspacePressed() {
    if (_enteredCode.isEmpty) return;
    
    setState(() {
      _enteredCode = _enteredCode.substring(0, _enteredCode.length - 1);
      _errorMessage = '';
    });
  }

  void _onClearPressed() {
    setState(() {
      _enteredCode = '';
      _errorMessage = '';
    });
  }

  void _verifyCode() {
    setState(() => _isLoading = true);

    // Small delay for UX
    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) return;

      if (_enteredCode == _expectedCode) {
        setState(() {
          _isUnlocked = true;
          _isLoading = false;
        });
        widget.onUnlocked?.call();
      } else {
        _shakeController.forward();
        setState(() {
          _errorMessage = 'Incorrect code. Please try again.';
          _enteredCode = '';
          _isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isUnlocked) {
      return widget.child;
    }

    return _LockScreenUI(
      enteredCode: _enteredCode,
      errorMessage: _errorMessage,
      isLoading: _isLoading,
      shakeAnimation: _shakeAnimation,
      onNumberPressed: _onNumberPressed,
      onBackspacePressed: _onBackspacePressed,
      onClearPressed: _onClearPressed,
      onSubmit: _verifyCode,
    );
  }
}

class _LockScreenUI extends StatelessWidget {
  final String enteredCode;
  final String errorMessage;
  final bool isLoading;
  final Animation<double> shakeAnimation;
  final void Function(String) onNumberPressed;
  final VoidCallback onBackspacePressed;
  final VoidCallback onClearPressed;
  final VoidCallback onSubmit;

  const _LockScreenUI({
    required this.enteredCode,
    required this.errorMessage,
    required this.isLoading,
    required this.shakeAnimation,
    required this.onNumberPressed,
    required this.onBackspacePressed,
    required this.onClearPressed,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = ThemeProvider.of(context);
    final colors = theme.colors;
    final styles = AppTextStyles(colors);
    final isMobile = Responsive.isMobileScreen(context);

    return CupertinoPageScaffold(
      backgroundColor: colors.background,
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(isMobile ? 24 : 48),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo and Title
                  Container(
                    width: isMobile ? 80 : 100,
                    height: isMobile ? 80 : 100,
                    decoration: BoxDecoration(
                      color: colors.surface,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: colors.border, width: 1),
                      boxShadow: [
                        BoxShadow(
                          color: colors.textPrimary.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Image.asset(
                        'assets/logo.png',
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Icon(
                          CupertinoIcons.lock_shield_fill,
                          size: 48,
                          color: colors.accent,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: isMobile ? 24 : 32),
                  Text(
                    'SocioTADS',
                    style: styles.displayLarge.copyWith(
                      fontSize: isMobile ? 28 : 36,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Enter your 11-digit code to unlock',
                    style: styles.bodyMedium.copyWith(color: colors.textSecondary),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: isMobile ? 32 : 48),

                  // Code Display
                  AnimatedBuilder(
                    animation: shakeAnimation,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(shakeAnimation.value, 0),
                        child: child,
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      decoration: BoxDecoration(
                        color: colors.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: errorMessage.isNotEmpty ? colors.error : colors.border,
                          width: errorMessage.isNotEmpty ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(11, (index) {
                          final isFilled = index < enteredCode.length;
                          final isCurrentPosition = index == enteredCode.length;
                          return Container(
                            width: isMobile ? 20 : 24,
                            height: isMobile ? 20 : 24,
                            margin: EdgeInsets.symmetric(horizontal: isMobile ? 3 : 4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isFilled ? colors.accent : colors.surfaceSecondary,
                              border: Border.all(
                                color: isCurrentPosition ? colors.accent : colors.border,
                                width: isCurrentPosition ? 2 : 1,
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ),

                  // Error Message
                  if (errorMessage.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Text(
                      errorMessage,
                      style: styles.bodySmall.copyWith(color: colors.error),
                      textAlign: TextAlign.center,
                    ),
                  ],

                  SizedBox(height: isMobile ? 24 : 32),

                  // Number Pad
                  _NumberPad(
                    onNumberPressed: onNumberPressed,
                    onBackspacePressed: onBackspacePressed,
                    onClearPressed: onClearPressed,
                    isMobile: isMobile,
                  ),

                  const SizedBox(height: 24),

                  // Unlock Button
                  SizedBox(
                    width: double.infinity,
                    child: CupertinoButton(
                      color: enteredCode.length == 11 ? colors.accent : colors.surfaceSecondary,
                      borderRadius: BorderRadius.circular(12),
                      onPressed: enteredCode.length == 11 && !isLoading ? onSubmit : null,
                      child: isLoading
                          ? const CupertinoActivityIndicator(color: CupertinoColors.white)
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  CupertinoIcons.lock_open_fill,
                                  size: 18,
                                  color: enteredCode.length == 11
                                      ? CupertinoColors.white
                                      : colors.textMuted,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Unlock',
                                  style: styles.titleMedium.copyWith(
                                    color: enteredCode.length == 11
                                        ? CupertinoColors.white
                                        : colors.textMuted,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NumberPad extends StatelessWidget {
  final void Function(String) onNumberPressed;
  final VoidCallback onBackspacePressed;
  final VoidCallback onClearPressed;
  final bool isMobile;

  const _NumberPad({
    required this.onNumberPressed,
    required this.onBackspacePressed,
    required this.onClearPressed,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    final theme = ThemeProvider.of(context);
    final colors = theme.colors;

    final buttonSize = isMobile ? 60.0 : 70.0;
    final spacing = isMobile ? 12.0 : 16.0;

    return Column(
      children: [
        // Row 1: 1, 2, 3
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _NumberButton(number: '1', size: buttonSize, onPressed: onNumberPressed),
            SizedBox(width: spacing),
            _NumberButton(number: '2', size: buttonSize, onPressed: onNumberPressed),
            SizedBox(width: spacing),
            _NumberButton(number: '3', size: buttonSize, onPressed: onNumberPressed),
          ],
        ),
        SizedBox(height: spacing),
        // Row 2: 4, 5, 6
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _NumberButton(number: '4', size: buttonSize, onPressed: onNumberPressed),
            SizedBox(width: spacing),
            _NumberButton(number: '5', size: buttonSize, onPressed: onNumberPressed),
            SizedBox(width: spacing),
            _NumberButton(number: '6', size: buttonSize, onPressed: onNumberPressed),
          ],
        ),
        SizedBox(height: spacing),
        // Row 3: 7, 8, 9
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _NumberButton(number: '7', size: buttonSize, onPressed: onNumberPressed),
            SizedBox(width: spacing),
            _NumberButton(number: '8', size: buttonSize, onPressed: onNumberPressed),
            SizedBox(width: spacing),
            _NumberButton(number: '9', size: buttonSize, onPressed: onNumberPressed),
          ],
        ),
        SizedBox(height: spacing),
        // Row 4: Clear, 0, Backspace
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _ActionButton(
              icon: CupertinoIcons.clear,
              size: buttonSize,
              onPressed: onClearPressed,
              color: colors.surfaceSecondary,
              iconColor: colors.textMuted,
            ),
            SizedBox(width: spacing),
            _NumberButton(number: '0', size: buttonSize, onPressed: onNumberPressed),
            SizedBox(width: spacing),
            _ActionButton(
              icon: CupertinoIcons.delete_left,
              size: buttonSize,
              onPressed: onBackspacePressed,
              color: colors.surfaceSecondary,
              iconColor: colors.textSecondary,
            ),
          ],
        ),
      ],
    );
  }
}

class _NumberButton extends StatefulWidget {
  final String number;
  final double size;
  final void Function(String) onPressed;

  const _NumberButton({
    required this.number,
    required this.size,
    required this.onPressed,
  });

  @override
  State<_NumberButton> createState() => _NumberButtonState();
}

class _NumberButtonState extends State<_NumberButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = ThemeProvider.of(context);
    final colors = theme.colors;
    final styles = AppTextStyles(colors);

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onPressed(widget.number);
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          color: _isPressed ? colors.accent : colors.surface,
          borderRadius: BorderRadius.circular(widget.size / 2),
          border: Border.all(color: colors.border, width: 1),
          boxShadow: _isPressed
              ? []
              : [
                  BoxShadow(
                    color: colors.textPrimary.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Center(
          child: Text(
            widget.number,
            style: styles.headlineMedium.copyWith(
              color: _isPressed ? CupertinoColors.white : colors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatefulWidget {
  final IconData icon;
  final double size;
  final VoidCallback onPressed;
  final Color color;
  final Color iconColor;

  const _ActionButton({
    required this.icon,
    required this.size,
    required this.onPressed,
    required this.color,
    required this.iconColor,
  });

  @override
  State<_ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<_ActionButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = ThemeProvider.of(context);
    final colors = theme.colors;

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onPressed();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          color: _isPressed ? colors.accent.withOpacity(0.2) : widget.color,
          borderRadius: BorderRadius.circular(widget.size / 2),
          border: Border.all(color: colors.border, width: 1),
        ),
        child: Center(
          child: Icon(
            widget.icon,
            size: widget.size * 0.35,
            color: widget.iconColor,
          ),
        ),
      ),
    );
  }
}
