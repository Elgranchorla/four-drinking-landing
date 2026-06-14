import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
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
    test('stores normalized waitlist entry', () async {
      final firestore = FakeFirebaseFirestore();
      final service = WaitlistService(firestore: firestore);

      await service.joinWaitlist(
        email: '  Test@Example.com ',
        name: 'Ana',
      );

      final docs = await firestore.collection(WaitlistService.collectionName).get();
      expect(docs.docs, hasLength(1));
      expect(docs.docs.first.data()['email'], 'test@example.com');
      expect(docs.docs.first.data()['source'], WaitlistService.sourceLanding);
    });
  });
}
