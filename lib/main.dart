import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:go_router/go_router.dart';

import 'firebase_options.dart';
import 'router.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  // Read /privacidad (and the other legal paths) from the browser URL.
  // Must run before the binding captures the initial route.
  usePathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();

  final router = createRouter();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(LandingApp(router: router));
}

class LandingApp extends StatelessWidget {
  const LandingApp({super.key, required this.router});

  final GoRouter router;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: '4drinking',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      locale: const Locale('es'),
      routerConfig: router,
    );
  }
}
