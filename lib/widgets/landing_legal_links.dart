import 'package:flutter/material.dart';

import '../config/landing_config.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import '../utils/legal_navigation.dart';

class LandingLegalLinks extends StatelessWidget {
  const LandingLegalLinks({super.key});

  @override
  Widget build(BuildContext context) {
    const linkStyle = TextStyle(
      color: AppColors.primary,
      fontWeight: FontWeight.w600,
      decoration: TextDecoration.underline,
    );
    const separatorStyle = TextStyle(color: AppColors.textSecondary);

    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.xs,
      children: [
        _LegalLink(
          label: 'Política de Privacidad',
          url: LandingConfig.privacyPolicyUrl,
          style: linkStyle,
        ),
        const Text('·', style: separatorStyle),
        _LegalLink(
          label: 'Política de Cookies',
          url: LandingConfig.cookiesPolicyUrl,
          style: linkStyle,
        ),
        const Text('·', style: separatorStyle),
        _LegalLink(
          label: 'Términos y Condiciones',
          url: LandingConfig.termsUrl,
          style: linkStyle,
        ),
        const Text('·', style: separatorStyle),
        _LegalLink(
          label: 'Aviso Legal',
          url: LandingConfig.legalNoticeUrl,
          style: linkStyle,
        ),
      ],
    );
  }
}

class _LegalLink extends StatelessWidget {
  const _LegalLink({
    required this.label,
    required this.url,
    required this.style,
  });

  final String label;
  final String url;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => openLegalLink(context, url),
      child: Text(
        label,
        style: AppTypography.caption.copyWith(
          color: style.color,
          fontWeight: style.fontWeight,
          decoration: style.decoration,
        ),
      ),
    );
  }
}
