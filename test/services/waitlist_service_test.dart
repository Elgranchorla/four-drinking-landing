import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:four_drinking_landing/config/landing_config.dart';
import 'package:four_drinking_landing/services/waitlist_service.dart';

void main() {
  group('isValidWaitlistEmail', () {
    test('accepts valid emails', () {
      expect(isValidWaitlistEmail('user@example.com'), isTrue);
    });

    test('rejects invalid emails', () {
      expect(isValidWaitlistEmail('not-an-email'), isFalse);
    });
  });

  group('WaitlistService', () {
    late FakeFirebaseFirestore firestore;
    late WaitlistService service;

    setUp(() {
      firestore = FakeFirebaseFirestore();
      service = WaitlistService(firestore: firestore);
    });

    Future<Map<String, dynamic>> saveEntry({
      bool privacyAccepted = true,
      bool marketingConsent = false,
    }) async {
      await service.joinWaitlist(
        email: '  Test@Example.com ',
        name: 'Ana',
        privacyAccepted: privacyAccepted,
        marketingConsent: marketingConsent,
      );

      final docs =
          await firestore.collection(WaitlistService.collectionName).get();
      expect(docs.docs, hasLength(1));
      return docs.docs.first.data();
    }

    test('stores normalized waitlist entry', () async {
      final data = await saveEntry();

      expect(data['email'], 'test@example.com');
      expect(data['name'], 'Ana');
      expect(data['source'], WaitlistService.sourceLanding);
      expect(data['createdAt'], isNotNull);
    });

    test('stores privacyAccepted true', () async {
      final data = await saveEntry();

      expect(data['privacyAccepted'], isTrue);
      expect(data['privacyAcceptedAt'], isNotNull);
    });

    test('stores privacyPolicyVersion', () async {
      final data = await saveEntry();

      expect(
        data['privacyPolicyVersion'],
        LandingConfig.privacyPolicyVersion,
      );
      expect(data['termsVersion'], LandingConfig.termsVersion);
      expect(data['cookiePolicyVersion'], LandingConfig.cookiePolicyVersion);
    });

    test('stores marketingConsent true when accepted', () async {
      final data = await saveEntry(marketingConsent: true);

      expect(data['marketingConsent'], isTrue);
      expect(data['marketingConsentAt'], isNotNull);
    });

    test('stores marketingConsent false when not accepted', () async {
      final data = await saveEntry(marketingConsent: false);

      expect(data['marketingConsent'], isFalse);
      expect(data['marketingConsentAt'], isNull);
    });

    test('throws when privacyAccepted is false', () async {
      await expectLater(
        service.joinWaitlist(
          email: 'user@example.com',
          privacyAccepted: false,
          marketingConsent: false,
        ),
        throwsA(isA<PrivacyNotAcceptedException>()),
      );

      final docs =
          await firestore.collection(WaitlistService.collectionName).get();
      expect(docs.docs, isEmpty);
    });
  });
}
