import 'package:flutter/material.dart';

abstract final class AppSpacing {
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 20;
  static const double xl = 24;
  static const double xxl = 32;
  static const double xxxl = 40;
  static const double massive = 64;

  static const EdgeInsets button =
      EdgeInsets.symmetric(horizontal: lg, vertical: sm + 2);
}

abstract final class AppRadius {
  static const BorderRadius card = BorderRadius.all(Radius.circular(18));
  static const BorderRadius button = BorderRadius.all(Radius.circular(16));
  static const BorderRadius input = BorderRadius.all(Radius.circular(16));
}

abstract final class AppBreakpoints {
  static const double tablet = 600;
  static const double desktop = 1024;
}
