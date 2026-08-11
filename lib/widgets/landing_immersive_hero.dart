import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import 'app_button.dart';
import 'landing_logo.dart';

/// Full-bleed photo hero aligned with the app home "potencia" treatment.
class LandingImmersiveHero extends StatelessWidget {
  const LandingImmersiveHero({
    super.key,
    required this.headline,
    required this.subtitle,
    required this.ctaLabel,
    required this.onCtaPressed,
  });

  static const backgroundAsset = 'assets/images/home_hero_bottles.jpg';

  static const _scrimGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0x80000000),
      Color(0x33000000),
      Color(0x52000000),
      Color(0x8A000000),
    ],
    stops: [0.0, 0.38, 0.62, 1.0],
  );

  final String headline;
  final String subtitle;
  final String ctaLabel;
  final VoidCallback onCtaPressed;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isDesktop = width >= AppBreakpoints.desktop;
    final horizontalPadding = isDesktop ? AppSpacing.xxxl : AppSpacing.xl;
    final minHeight = isDesktop ? 520.0 : 440.0;

    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: minHeight),
      child: Stack(
        fit: StackFit.passthrough,
        children: [
          Positioned.fill(
            child: Image.asset(
              backgroundAsset,
              fit: BoxFit.cover,
              alignment: const Alignment(0, -0.08),
              errorBuilder: (_, _, _) => const ColoredBox(
                color: AppColors.primaryDark,
              ),
            ),
          ),
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(gradient: _scrimGradient),
            ),
          ),
          SafeArea(
            bottom: false,
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                AppSpacing.xl,
                horizontalPadding,
                AppSpacing.xxxl,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 720),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: LandingLogo(
                          height: isDesktop ? 44 : 36,
                          color: AppColors.onInverse,
                        ),
                      ),
                      SizedBox(
                        height: isDesktop ? AppSpacing.massive : AppSpacing.xxxl,
                      ),
                      Text(
                        headline,
                        style: (isDesktop
                                ? AppTypography.displayLarge
                                : AppTypography.headingLarge)
                            .copyWith(
                          color: AppColors.onInverse,
                          fontSize: isDesktop ? 42 : 34,
                          height: 1.15,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        subtitle,
                        style: AppTypography.body.copyWith(
                          color: AppColors.onInverse.withValues(alpha: 0.86),
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: isDesktop ? 280 : double.infinity,
                          ),
                          child: AppButton(
                            label: ctaLabel,
                            expanded: true,
                            onPressed: onCtaPressed,
                          ),
                        ),
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
