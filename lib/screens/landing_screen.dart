import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../config/landing_config.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import '../widgets/app_button.dart';
import '../widgets/landing_how_it_works.dart';
import '../widgets/landing_immersive_hero.dart';
import '../widgets/waitlist_form.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  static const String headline =
      'Encuentra el vino ideal para tu momento';
  static const String subtitle =
      'Responde unas pocas preguntas y recibe recomendaciones adaptadas a tus gustos.';
  static const String ctaLabel = 'Únete a la lista de espera';

  static const double _maxContentWidth = 720;

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  final _waitlistKey = GlobalKey();

  Future<void> _openAppUrl() async {
    final uri = Uri.tryParse(LandingConfig.appUrl.trim());
    if (uri == null) return;

    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Future<void> _scrollToWaitlist() async {
    final context = _waitlistKey.currentContext;
    if (context == null) return;

    await Scrollable.ensureVisible(
      context,
      duration: const Duration(milliseconds: 520),
      curve: Curves.easeOutCubic,
      alignment: 0.08,
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isDesktop = width >= AppBreakpoints.desktop;
    final horizontalPadding = isDesktop ? AppSpacing.xxxl : AppSpacing.xl;

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: LandingImmersiveHero(
              headline: LandingScreen.headline,
              subtitle: LandingScreen.subtitle,
              ctaLabel: LandingScreen.ctaLabel,
              onCtaPressed: _scrollToWaitlist,
            ),
          ),
          SliverToBoxAdapter(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: LandingScreen._maxContentWidth,
                ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    AppSpacing.xxxl,
                    horizontalPadding,
                    AppSpacing.massive,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const LandingHowItWorks(),
                      SizedBox(
                        height:
                            isDesktop ? AppSpacing.massive : AppSpacing.xxxl,
                      ),
                      KeyedSubtree(
                        key: _waitlistKey,
                        child: AppSurfaceCard(
                          padding: EdgeInsets.all(
                            isDesktop ? AppSpacing.xxl : AppSpacing.xl,
                          ),
                          child: const WaitlistForm(),
                        ),
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
                        textAlign: TextAlign.center,
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
