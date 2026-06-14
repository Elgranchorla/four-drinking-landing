import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:four_drinking_landing/screens/landing_screen.dart';

void main() {
  testWidgets('LandingScreen muestra hero y formulario', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: LandingScreen()),
    );

    expect(find.text(LandingScreen.headline), findsOneWidget);
    expect(find.text(LandingScreen.subtitle), findsOneWidget);
    expect(find.text('Únete a la lista de espera'), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(2));
  });
}
