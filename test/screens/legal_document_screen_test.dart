import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:four_drinking_landing/config/legal_documents.dart';
import 'package:four_drinking_landing/router.dart';

void main() {
  group('Legal documents', () {
    for (final document in LegalDocument.all) {
      testWidgets('carga ${document.path}', (tester) async {
        final router = createRouter();
        await tester.pumpWidget(
          MaterialApp.router(routerConfig: router),
        );
        router.go(document.path);
        await tester.pumpAndSettle();

        expect(find.text(document.title), findsWidgets);
        expect(find.byType(CircularProgressIndicator), findsNothing);
        expect(
          find.text(
            'No hemos podido cargar este documento. Inténtalo de nuevo más tarde.',
          ),
          findsNothing,
        );
      });
    }
  });
}
