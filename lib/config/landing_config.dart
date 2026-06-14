/// Runtime configuration for the public landing site.
abstract final class LandingConfig {
  /// URL of the consumer app (web or store). Override at build time with
  /// `--dart-define=APP_URL=https://...`.
  static const String appUrl = String.fromEnvironment(
    'APP_URL',
    defaultValue: '',
  );

  static bool get hasAppUrl => appUrl.trim().isNotEmpty;
}
