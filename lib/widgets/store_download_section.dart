import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../config/landing_config.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import 'landing_legal_links.dart';

/// iOS and Android download CTAs.
///
/// Store URLs stay empty until the public listings are published.
/// A missing URL keeps the button visible and disabled.
class StoreDownloadSection extends StatelessWidget {
  const StoreDownloadSection({
    super.key,
    this.appStoreUrl,
    this.playStoreUrl,
    this.onOpenUrl,
  });

  static const String title = 'Descarga la app';
  static const String subtitle = 'Disponible para iPhone y Android.';
  static const String pendingSubtitle =
      'Los enlaces de descarga estarán listos en los próximos días.';
  static const String appStoreLabel = 'App Store';
  static const String playStoreLabel = 'Google Play';
  static const String pendingLabel = 'Próximamente';

  /// Overrides [LandingConfig.appStoreUrl] in tests.
  final String? appStoreUrl;

  /// Overrides [LandingConfig.playStoreUrl] in tests.
  final String? playStoreUrl;

  /// Overrides the external launcher in tests.
  final Future<void> Function(String url)? onOpenUrl;

  String get _appStoreUrl => appStoreUrl ?? LandingConfig.appStoreUrl;

  String get _playStoreUrl => playStoreUrl ?? LandingConfig.playStoreUrl;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isWide = width >= AppBreakpoints.tablet;
    final appStoreReady = _appStoreUrl.trim().isNotEmpty;
    final playStoreReady = _playStoreUrl.trim().isNotEmpty;

    final appStoreButton = _StoreDownloadButton(
      label: appStoreLabel,
      pendingLabel: pendingLabel,
      icon: Icons.phone_iphone_rounded,
      url: _appStoreUrl,
      isReady: appStoreReady,
      onOpenUrl: onOpenUrl,
    );
    final playStoreButton = _StoreDownloadButton(
      label: playStoreLabel,
      pendingLabel: pendingLabel,
      icon: Icons.android_rounded,
      url: _playStoreUrl,
      isReady: playStoreReady,
      onOpenUrl: onOpenUrl,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: AppTypography.headingSmall.copyWith(
            color: AppColors.primaryDark,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        if (!appStoreReady || !playStoreReady) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(
            pendingSubtitle,
            textAlign: TextAlign.center,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
        const SizedBox(height: AppSpacing.lg),
        if (isWide)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: appStoreButton),
              const SizedBox(width: AppSpacing.md),
              Expanded(child: playStoreButton),
            ],
          )
        else ...[
          appStoreButton,
          const SizedBox(height: AppSpacing.md),
          playStoreButton,
        ],
        const SizedBox(height: AppSpacing.lg),
        const LandingLegalLinks(),
      ],
    );
  }
}

class _StoreDownloadButton extends StatelessWidget {
  const _StoreDownloadButton({
    required this.label,
    required this.pendingLabel,
    required this.icon,
    required this.url,
    required this.isReady,
    required this.onOpenUrl,
  });

  final String label;
  final String pendingLabel;
  final IconData icon;
  final String url;
  final bool isReady;
  final Future<void> Function(String url)? onOpenUrl;

  Future<void> _open() async {
    final opener = onOpenUrl;
    if (opener != null) {
      await opener(url);
      return;
    }

    final uri = Uri.tryParse(url.trim());
    if (uri == null) return;

    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final foreground = isReady ? AppColors.primary : AppColors.textSecondary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        OutlinedButton(
          onPressed: isReady ? _open : null,
          style: OutlinedButton.styleFrom(
            foregroundColor: foreground,
            disabledForegroundColor: AppColors.textSecondary,
            side: BorderSide(
              color: isReady ? AppColors.primary : AppColors.border,
            ),
            padding: AppSpacing.button,
            shape: const RoundedRectangleBorder(
              borderRadius: AppRadius.button,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 20),
              const SizedBox(width: AppSpacing.sm),
              Flexible(
                child: Text(
                  label,
                  style: AppTypography.button.copyWith(color: foreground),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        if (!isReady) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(
            pendingLabel,
            textAlign: TextAlign.center,
            style: AppTypography.caption,
          ),
        ],
      ],
    );
  }
}
