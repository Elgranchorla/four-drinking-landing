import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Semantic text styles with consistent line heights.
///
/// Headings use bundled [Playfair Display]; body text stays sans-serif.
abstract final class AppTypography {
  static const String serifFamily = 'Playfair Display';

  static const double _lineHeightTight = 1.25;
  static const double _lineHeightNormal = 1.4;

  static const TextStyle displayLarge = TextStyle(
    fontFamily: serifFamily,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: _lineHeightTight,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
  );

  static const TextStyle headingLarge = TextStyle(
    fontFamily: serifFamily,
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: _lineHeightTight,
    color: AppColors.textPrimary,
  );

  static const TextStyle headingMedium = TextStyle(
    fontFamily: serifFamily,
    fontSize: 22,
    fontWeight: FontWeight.w600,
    height: _lineHeightTight,
    color: AppColors.textPrimary,
  );

  static const TextStyle headingSmall = TextStyle(
    fontFamily: serifFamily,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: _lineHeightNormal,
    color: AppColors.textPrimary,
  );

  static const TextStyle title = TextStyle(
    fontFamily: serifFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: _lineHeightNormal,
    color: AppColors.textPrimary,
  );

  static const TextStyle body = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    height: _lineHeightNormal,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    height: _lineHeightNormal,
    color: AppColors.textPrimary,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.normal,
    height: _lineHeightNormal,
    color: AppColors.textSecondary,
  );

  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    height: _lineHeightNormal,
    color: Colors.white,
  );
}
