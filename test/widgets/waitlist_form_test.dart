import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:four_drinking_landing/services/waitlist_service.dart';
import 'package:four_drinking_landing/widgets/waitlist_form.dart';

void main() {
  testWidgets('mantiene el formulario visible tras un envío correcto', (
    tester,
  ) async {
    final service = WaitlistService(firestore: FakeFirebaseFirestore());

    await tester.pumpWidget(
      MaterialApp.router(
        routerConfig: GoRouter(
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => Scaffold(
                body: WaitlistForm(waitlistService: service),
              ),
            ),
          ],
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byType(TextFormField).first,
      'user@example.com',
    );
    await tester.tap(find.byType(Checkbox).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Unirme a la lista'));
    await tester.pumpAndSettle();

    expect(
      find.text('Gracias, te avisaremos cuando 4drinking esté disponible.'),
      findsOneWidget,
    );
    expect(find.text('Únete a la lista de espera'), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(2));
    expect(find.text('Unirme a la lista'), findsOneWidget);
  });
}
