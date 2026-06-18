import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

class LandingScreenshotGallery extends StatelessWidget {
  const LandingScreenshotGallery({super.key});

  static const _screenshots = [
    _ScreenshotItem(
      assetPath: 'assets/screenshots/home.png',
      label: 'Inicio',
      icon: Icons.home_outlined,
    ),
    _ScreenshotItem(
      assetPath: 'assets/screenshots/questions.png',
      label: 'Preguntas',
      icon: Icons.quiz_outlined,
    ),
    _ScreenshotItem(
      assetPath: 'assets/screenshots/recommendations.png',
      label: 'Recomendaciones',
      icon: Icons.wine_bar_outlined,
    ),
    _ScreenshotItem(
      assetPath: 'assets/screenshots/choice.png',
      label: 'Elección',
      icon: Icons.touch_app_outlined,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isDesktop = width >= AppBreakpoints.desktop;
    final isTablet = width >= AppBreakpoints.tablet;

    return Column(
      children: [
        Text(
          'Así funciona 4drinking',
          textAlign: TextAlign.center,
          style: AppTypography.headingMedium.copyWith(
            color: AppColors.primaryDark,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Responde unas pocas preguntas y recibe recomendaciones personalizadas.',
          textAlign: TextAlign.center,
          style: AppTypography.body.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: AppSpacing.xxl),
        LayoutBuilder(
          builder: (context, constraints) {
            final crossAxisCount = isDesktop ? 4 : (isTablet ? 2 : 1);
            const spacing = AppSpacing.md;
            final itemWidth =
                (constraints.maxWidth - spacing * (crossAxisCount - 1)) /
                    crossAxisCount;

            return Wrap(
              spacing: spacing,
              runSpacing: spacing,
              alignment: WrapAlignment.center,
              children: _screenshots
                  .map(
                    (item) => SizedBox(
                      width: crossAxisCount == 1
                          ? constraints.maxWidth
                          : itemWidth,
                      child: _ScreenshotCard(item: item),
                    ),
                  )
                  .toList(),
            );
          },
        ),
      ],
    );
  }
}

class _ScreenshotItem {
  const _ScreenshotItem({
    required this.assetPath,
    required this.label,
    required this.icon,
  });

  final String assetPath;
  final String label;
  final IconData icon;
}

class _ScreenshotCard extends StatelessWidget {
  const _ScreenshotCard({required this.item});

  final _ScreenshotItem item;

  static const _framePadding = 7.0;
  static const _innerRadius = 12.0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: AppRadius.card,
            border: Border.all(color: AppColors.borderLight),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow(0.06),
                blurRadius: 14,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(_framePadding),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(_innerRadius),
              child: AspectRatio(
                aspectRatio: 9 / 16,
                child: _ScreenshotImage(item: item),
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          item.label,
          style: AppTypography.title.copyWith(color: AppColors.primaryDark),
        ),
      ],
    );
  }
}

class _ScreenshotImage extends StatelessWidget {
  const _ScreenshotImage({required this.item});

  final _ScreenshotItem item;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      item.assetPath,
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) => _ScreenshotPlaceholder(
        label: item.label,
        icon: item.icon,
      ),
    );
  }
}

class _ScreenshotPlaceholder extends StatelessWidget {
  const _ScreenshotPlaceholder({
    required this.label,
    required this.icon,
  });

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.secondary,
            AppColors.secondaryDark,
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 48,
            color: AppColors.primary.withValues(alpha: 0.7),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            label,
            style: AppTypography.title.copyWith(
              color: AppColors.primaryDark,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Text(
              'Captura próximamente',
              textAlign: TextAlign.center,
              style: AppTypography.caption,
            ),
          ),
        ],
      ),
    );
  }
}
