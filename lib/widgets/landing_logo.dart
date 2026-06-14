import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/app_colors.dart';

class LandingLogo extends StatelessWidget {
  const LandingLogo({
    super.key,
    this.height = 48,
    this.wordmark = true,
    this.color,
  });

  final double height;
  final bool wordmark;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final asset = wordmark
        ? 'assets/images/4drinking.svg'
        : 'assets/images/4.svg';

    return SvgPicture.asset(
      asset,
      height: height,
      fit: BoxFit.contain,
      semanticsLabel: '4drinking',
      colorFilter: color != null
          ? ColorFilter.mode(color!, BlendMode.srcIn)
          : null,
    );
  }
}

class GradientHeader extends StatelessWidget {
  const GradientHeader({
    super.key,
    required this.child,
    this.height = 180,
  });

  final Widget child;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: const BoxDecoration(gradient: AppColors.appGradient),
      child: SafeArea(child: child),
    );
  }
}
