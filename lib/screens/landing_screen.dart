import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../config/landing_config.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import '../widgets/app_button.dart';
import '../widgets/landing_logo.dart';
import '../widgets/landing_screenshot_gallery.dart';
import '../widgets/waitlist_form.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  static const String headline =
      'Encuentra el vino perfecto para cada ocasión';
  static const String subtitle =
      '4drinking te ayuda a elegir el vino ideal según tus gustos, el momento, el presupuesto y el maridaje.';

  static const double _maxContentWidth = 960;

  Future<void> _openAppUrl() async {
    final uri = Uri.tryParse(LandingConfig.appUrl.trim());
    if (uri == null) return;

    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isDesktop = width >= AppBreakpoints.desktop;
    final horizontalPadding = isDesktop ? AppSpacing.xxxl : AppSpacing.xl;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: GradientHeader(
              height: isDesktop ? 320 : 260,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LandingLogo(
                      height: isDesktop ? 56 : 44,
                      color: AppColors.onInverse,
                    ),
                    SizedBox(height: isDesktop ? AppSpacing.xxl : AppSpacing.xl),
                    Text(
                      headline,
                      textAlign: TextAlign.center,
                      style: (isDesktop
                              ? AppTypography.displayLarge
                              : AppTypography.headingLarge)
                          .copyWith(
                        color: AppColors.onInverse,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 640),
                      child: Text(
                        subtitle,
                        textAlign: TextAlign.center,
                        style: AppTypography.body.copyWith(
                          color: AppColors.onInverse.withValues(alpha: 0.92),
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: _maxContentWidth),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    AppSpacing.xxxl,
                    horizontalPadding,
                    AppSpacing.massive,
                  ),
                  child: Column(
                    children: [
                      const LandingScreenshotGallery(),
                      SizedBox(
                        height: isDesktop ? AppSpacing.massive : AppSpacing.xxxl,
                      ),
                      AppSurfaceCard(
                        padding: EdgeInsets.all(
                          isDesktop ? AppSpacing.xxl : AppSpacing.xl,
                        ),
                        child: const WaitlistForm(),
                      ),
                      if (LandingConfig.hasAppUrl) ...[
                        const SizedBox(height: AppSpacing.xxl),
                        TextButton(
                          onPressed: _openAppUrl,
                          child: Text(
                            '¿Ya tienes cuenta? Accede a la app',
                            style: AppTypography.bodyMedium.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        '© ${DateTime.now().year} 4drinking',
                        style: AppTypography.caption,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
