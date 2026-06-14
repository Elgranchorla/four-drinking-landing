import 'package:flutter/material.dart';

abstract final class AppColors {
  static const Color primary = Color(0xFF8E1F7A);
  static const Color primaryDark = Color(0xFF64155A);
  static const Color accent = Color(0xFFE04B8E);
  static const Color secondary = Color(0xFFF5EDE6);
  static const Color secondaryDark = Color(0xFFE8DDD3);
  static const Color background = Color(0xFFF8F6F9);
  static const Color surface = Colors.white;
  static const Color textPrimary = Color(0xFF231F20);
  static const Color textSecondary = Color(0xFF776C77);
  static const Color onInverse = Colors.white;
  static const Color border = Color(0xFFE0D8E0);
  static const Color borderLight = Color(0xFFF0EBF0);
  static const Color success = Color(0xFF2E7D32);
  static const Color error = Color(0xFFC62828);

  static Color shadow([double opacity = 0.05]) =>
      Colors.black.withValues(alpha: opacity);

  static const Gradient appGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFE35193), Color(0xFF7F1B7F)],
  );
}
