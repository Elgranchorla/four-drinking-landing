import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:four_drinking_landing/config/legal_documents.dart';
import 'package:four_drinking_landing/router.dart';
import 'package:four_drinking_landing/screens/landing_screen.dart';

void main() {
  group('LandingScreen', () {
    Future<void> pumpLanding(WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp.router(routerConfig: createRouter()),
      );
      await tester.pumpAndSettle();
    }

    Future<void> scrollToWaitlistForm(WidgetTester tester) async {
      await tester.scrollUntilVisible(
        find.text('Unirme a la lista'),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();
    }

    testWidgets('muestra hero y formulario', (tester) async {
      await pumpLanding(tester);

      expect(find.text(LandingScreen.headline), findsOneWidget);
      expect(find.text(LandingScreen.subtitle), findsOneWidget);

      await scrollToWaitlistForm(tester);

      expect(find.text('Únete a la lista de espera'), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(2));
    });

    testWidgets('muestra checkboxes de privacidad y marketing', (tester) async {
      await pumpLanding(tester);
      await scrollToWaitlistForm(tester);

      expect(find.byType(Checkbox), findsNWidgets(2));
      expect(
        find.textContaining('He leído y acepto la'),
        findsOneWidget,
      );
      expect(
        find.textContaining('Quiero recibir novedades'),
        findsOneWidget,
      );
    });

    testWidgets('no envía si la privacidad no está aceptada', (tester) async {
      await pumpLanding(tester);
      await scrollToWaitlistForm(tester);

      await tester.enterText(
        find.byType(TextFormField).first,
        'user@example.com',
      );
      await tester.ensureVisible(find.text('Unirme a la lista'));
      await tester.tap(find.text('Unirme a la lista'));
      await tester.pumpAndSettle();

      expect(
        find.text('Debes aceptar la Política de Privacidad para continuar'),
        findsOneWidget,
      );
      expect(
        find.text('Gracias, te avisaremos cuando 4drinking esté disponible.'),
        findsNothing,
      );
    });

    testWidgets('permite enviar con email válido y privacidad aceptada', (
      tester,
    ) async {
      await pumpLanding(tester);
      await scrollToWaitlistForm(tester);

      await tester.enterText(
        find.byType(TextFormField).first,
        'user@example.com',
      );
      await tester.ensureVisible(find.byType(Checkbox).first);
      await tester.tap(find.byType(Checkbox).first);
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Unirme a la lista'));
      await tester.tap(find.text('Unirme a la lista'));
      await tester.pump();

      expect(
        find.text('Debes aceptar la Política de Privacidad para continuar'),
        findsNothing,
      );
    });

    testWidgets('abre la política de privacidad desde el footer', (
      tester,
    ) async {
      await pumpLanding(tester);
      await scrollToWaitlistForm(tester);

      await tester.tap(find.text('Política de Privacidad').last);
      await tester.pumpAndSettle();

      expect(
        find.text(LegalDocument.privacy.title),
        findsWidgets,
      );
      expect(
        find.textContaining('Política de Privacidad de 4drinking'),
        findsOneWidget,
      );
    });
  });
}
