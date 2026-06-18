/// Runtime configuration for the public landing site.
abstract final class LandingConfig {
  /// URL of the consumer app (web or store). Override at build time with
  /// `--dart-define=APP_URL=https://...`.
  static const String appUrl = String.fromEnvironment(
    'APP_URL',
    defaultValue: '',
  );

  static bool get hasAppUrl => appUrl.trim().isNotEmpty;

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
