/// Runtime configuration for the public landing site.
abstract final class LandingConfig {
  /// Optional single CTA URL (web app or marketing link).
  /// Override at build time with `--dart-define=APP_URL=https://...`.
  static const String appUrl = String.fromEnvironment(
    'APP_URL',
    defaultValue: '',
  );

  /// Google Play store listing. Override with
  /// `--dart-define=PLAY_STORE_URL=https://play.google.com/store/apps/details?id=...`
  static const String playStoreUrl = String.fromEnvironment(
    'PLAY_STORE_URL',
    defaultValue: '',
  );

  /// App Store listing. Override with
  /// `--dart-define=APP_STORE_URL=https://apps.apple.com/...`
  static const String appStoreUrl = String.fromEnvironment(
    'APP_STORE_URL',
    defaultValue: '',
  );

  static bool get hasAppUrl => appUrl.trim().isNotEmpty;

  static bool get hasPlayStoreUrl => playStoreUrl.trim().isNotEmpty;

  static bool get hasAppStoreUrl => appStoreUrl.trim().isNotEmpty;

  /// True when at least one public install link is configured.
  static bool get hasStoreLinks => hasPlayStoreUrl || hasAppStoreUrl;

  static const String privacyPolicyVersion = '1.0';
  static const String cookiePolicyVersion = '1.0';
  static const String termsVersion = '1.0';

  static const String privacyPolicyUrl = String.fromEnvironment(
    'PRIVACY_POLICY_URL',
    defaultValue: '/privacidad',
  );

  static const String cookiesPolicyUrl = String.fromEnvironment(
    'COOKIES_POLICY_URL',
    defaultValue: '/cookies',
  );

  static const String termsUrl = String.fromEnvironment(
    'TERMS_URL',
    defaultValue: '/terminos',
  );

  static const String legalNoticeUrl = String.fromEnvironment(
    'LEGAL_NOTICE_URL',
    defaultValue: '/aviso-legal',
  );
}
