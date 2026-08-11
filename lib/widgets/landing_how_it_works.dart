import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

class LandingHowItWorks extends StatelessWidget {
  const LandingHowItWorks({super.key});

  static const title = '¿Cómo funciona?';

  static const steps = [
    _HowItWorksStep(
      icon: Icons.chat_bubble_outline_rounded,
      title: 'Responde unas pocas preguntas',
      description:
          'Te haremos una serie de preguntas para saber tus gustos y necesidades para cada ocasión',
    ),
    _HowItWorksStep(
      icon: Icons.liquor_outlined,
      title: 'Recibe recomendaciones',
      description:
          'Te enseñaremos la mejor selección de vinos según tus gustos y algunas recomendaciones de otras personas',
    ),
    _HowItWorksStep(
      icon: Icons.sentiment_satisfied_alt_outlined,
      title: 'Elige tu vino y disfrútalo',
      description: 'Fácil, ¿no? :)',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isDesktop = width >= AppBreakpoints.desktop;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: (isDesktop
                  ? AppTypography.headingLarge
                  : AppTypography.headingMedium)
              .copyWith(color: AppColors.primaryDark),
        ),
        SizedBox(height: isDesktop ? AppSpacing.xxl : AppSpacing.xl),
        for (var i = 0; i < steps.length; i++) ...[
          if (i > 0) SizedBox(height: isDesktop ? AppSpacing.xl : AppSpacing.lg),
          _HowItWorksStepRow(step: steps[i]),
        ],
      ],
    );
  }
}

class _HowItWorksStep {
  const _HowItWorksStep({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;
}

class _HowItWorksStepRow extends StatelessWidget {
  const _HowItWorksStepRow({required this.step});

  final _HowItWorksStep step;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          step.icon,
          size: 28,
          color: AppColors.primary,
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                step.title,
                style: AppTypography.title.copyWith(
                  color: AppColors.primaryDark,
                  fontSize: 17,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                step.description,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.45,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
