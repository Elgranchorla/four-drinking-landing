import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:four_drinking_landing/config/legal_documents.dart';
import 'package:four_drinking_landing/router.dart';
import 'package:four_drinking_landing/screens/landing_screen.dart';
import 'package:four_drinking_landing/widgets/store_download_section.dart';

void main() {
  group('LandingScreen', () {
    Future<void> pumpLanding(WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp.router(routerConfig: createRouter()),
      );
      await tester.pumpAndSettle();
    }

    Future<void> scrollToDownloads(WidgetTester tester) async {
      await tester.scrollUntilVisible(
        find.text(StoreDownloadSection.appStoreLabel),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();
    }

    testWidgets('muestra hero, pasos y CTAs de descarga', (tester) async {
      await pumpLanding(tester);

      expect(find.text(LandingScreen.headline), findsOneWidget);
      expect(find.text(LandingScreen.subtitle), findsOneWidget);
      expect(find.text(LandingScreen.ctaLabel), findsWidgets);
      expect(find.text('¿Cómo funciona?'), findsOneWidget);
      expect(find.text('Responde unas pocas preguntas'), findsOneWidget);
      expect(find.text('Recibe recomendaciones'), findsOneWidget);
      expect(find.text('Elige tu vino y disfrútalo'), findsOneWidget);

      await scrollToDownloads(tester);

      expect(find.text(StoreDownloadSection.title), findsWidgets);
      expect(find.text(StoreDownloadSection.appStoreLabel), findsOneWidget);
      expect(find.text(StoreDownloadSection.playStoreLabel), findsOneWidget);
      expect(find.text(StoreDownloadSection.pendingSubtitle), findsOneWidget);
      expect(find.text(StoreDownloadSection.pendingLabel), findsNWidgets(2));
      expect(find.byType(TextFormField), findsNothing);
    });

    testWidgets('mantiene los CTA desactivados mientras no hay enlaces', (
      tester,
    ) async {
      await pumpLanding(tester);
      await scrollToDownloads(tester);

      final appStore = tester.widget<OutlinedButton>(
        find.widgetWithText(OutlinedButton, StoreDownloadSection.appStoreLabel),
      );
      final playStore = tester.widget<OutlinedButton>(
        find.widgetWithText(
          OutlinedButton,
          StoreDownloadSection.playStoreLabel,
        ),
      );

      expect(appStore.onPressed, isNull);
      expect(playStore.onPressed, isNull);
    });

    testWidgets('abre la política de privacidad desde el footer', (
      tester,
    ) async {
      await pumpLanding(tester);
      await scrollToDownloads(tester);

      await tester.tap(find.text('Política de Privacidad'));
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
