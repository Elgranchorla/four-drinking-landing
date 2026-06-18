import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'router.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const LandingApp());
}

class LandingApp extends StatelessWidget {
  const LandingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: '4drinking',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      locale: const Locale('es'),
      routerConfig: createRouter(),
    );
  }
}
