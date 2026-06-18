/// Metadata for published legal documents on the landing site.
class LegalDocument {
  const LegalDocument({
    required this.path,
    required this.title,
    required this.assetPath,
    required this.routeName,
  });

  final String path;
  final String title;
  final String assetPath;
  final String routeName;

  static const privacy = LegalDocument(
    path: '/privacidad',
    title: 'Política de Privacidad',
    assetPath: 'assets/legal/politica-privacidad.md',
    routeName: 'privacy',
  );

  static const cookies = LegalDocument(
    path: '/cookies',
    title: 'Política de Cookies',
    assetPath: 'assets/legal/politica-cookies.md',
    routeName: 'cookies',
  );

  static const terms = LegalDocument(
    path: '/terminos',
    title: 'Términos y Condiciones',
    assetPath: 'assets/legal/terminos-y-condiciones.md',
    routeName: 'terms',
  );

  static const legalNotice = LegalDocument(
    path: '/aviso-legal',
    title: 'Aviso Legal',
    assetPath: 'assets/legal/aviso-legal.md',
    routeName: 'legal_notice',
  );

  static const List<LegalDocument> all = [
    privacy,
    cookies,
    terms,
    legalNotice,
  ];

  static LegalDocument? forPath(String path) {
    final normalized = path.endsWith('/') && path.length > 1
        ? path.substring(0, path.length - 1)
        : path;

    for (final document in all) {
      if (document.path == normalized) return document;
    }

    return null;
  }
}
