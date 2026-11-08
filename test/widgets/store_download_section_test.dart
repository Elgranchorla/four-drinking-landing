import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:four_drinking_landing/widgets/store_download_section.dart';

void main() {
  group('StoreDownloadSection', () {
    testWidgets('abre la tienda cuando el enlace ya está publicado', (
      tester,
    ) async {
      final opened = <String>[];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StoreDownloadSection(
              appStoreUrl: 'https://apps.apple.com/app/id000',
              playStoreUrl: 'https://play.google.com/store/apps/details?id=app',
              onOpenUrl: (url) async => opened.add(url),
            ),
          ),
        ),
      );

      expect(find.text(StoreDownloadSection.pendingLabel), findsNothing);
      expect(find.text(StoreDownloadSection.pendingSubtitle), findsNothing);

      await tester.tap(find.text(StoreDownloadSection.appStoreLabel));
      await tester.tap(find.text(StoreDownloadSection.playStoreLabel));
      await tester.pump();

      expect(opened, [
        'https://apps.apple.com/app/id000',
        'https://play.google.com/store/apps/details?id=app',
      ]);
    });

    testWidgets('activa solo la tienda que ya tiene enlace', (tester) async {
      final opened = <String>[];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StoreDownloadSection(
              appStoreUrl: 'https://apps.apple.com/app/id000',
              playStoreUrl: '',
              onOpenUrl: (url) async => opened.add(url),
            ),
          ),
        ),
      );

      expect(find.text(StoreDownloadSection.pendingLabel), findsOneWidget);

      await tester.tap(find.text(StoreDownloadSection.appStoreLabel));
      await tester.tap(find.text(StoreDownloadSection.playStoreLabel));
      await tester.pump();

      expect(opened, ['https://apps.apple.com/app/id000']);
    });
  });
}
