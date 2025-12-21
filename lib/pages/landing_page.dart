import 'package:flutter/cupertino.dart';
import 'package:sociotads/components/theme_selector.dart';
import 'package:sociotads/pages/x_page.dart';
import 'package:sociotads/theme/app_theme.dart';
import 'package:sociotads/utils/responsive.dart';

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
