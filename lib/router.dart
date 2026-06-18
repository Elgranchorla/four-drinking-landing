import 'package:go_router/go_router.dart';

import 'config/legal_documents.dart';
import 'screens/landing_screen.dart';
import 'screens/legal_document_screen.dart';

GoRouter createRouter() {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const LandingScreen(),
      ),
      for (final document in LegalDocument.all)
        GoRoute(
          path: document.path,
          name: document.routeName,
          builder: (context, state) => LegalDocumentScreen(document: document),
        ),
    ],
  );
}
