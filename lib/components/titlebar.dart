import 'package:flutter/cupertino.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:sociotads/theme/app_theme.dart';

class CustomTitleBar extends StatelessWidget {
  const CustomTitleBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ThemeProvider.of(context);
    final colors = theme.colors;
    final styles = AppTextStyles(colors);

    return Container(
      height: 36,
      color: colors.surface,
      child: Row(
        children: [
          Expanded(
            child: MoveWindow(
              child: Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.asset(
                        'assets/logo.png',
                        width: 24,
                        height: 24,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'SocioTADS',
                      style: styles.titleMedium,
                    ),
                  ],
                ),
              ),
            ),
          ),
          WindowButtons(colors: colors),
        ],
      ),
    );
  }
}

class WindowButtons extends StatelessWidget {
  final AppColors colors;

  const WindowButtons({super.key, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _WindowButton(
          icon: CupertinoIcons.minus,
          onPressed: () => appWindow.minimize(),
          colors: colors,
          hoverColor: colors.surfaceSecondary,
        ),
        _WindowButton(
          icon: CupertinoIcons.square,
          onPressed: () => appWindow.maximizeOrRestore(),
          colors: colors,
          hoverColor: colors.surfaceSecondary,
        ),
        _WindowButton(
          icon: CupertinoIcons.xmark,
          onPressed: () => appWindow.close(),
          colors: colors,
          hoverColor: const Color(0xFFE81123),
          isClose: true,
        ),
      ],
    );
  }
}

class _WindowButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final AppColors colors;
  final Color hoverColor;
  final bool isClose;

  const _WindowButton({
    required this.icon,
    required this.onPressed,
    required this.colors,
    required this.hoverColor,
    this.isClose = false,
  });

  @override
  State<_WindowButton> createState() => _WindowButtonState();
}

class _WindowButtonState extends State<_WindowButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: Container(
          width: 46,
          height: 36,
          color: _isHovered ? widget.hoverColor : widget.colors.surface,
          child: Center(
            child: Icon(
              widget.icon,
              size: 14,
              color: _isHovered && widget.isClose
                  ? CupertinoColors.white
                  : widget.colors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}