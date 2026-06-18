import 'package:cloud_firestore/cloud_firestore.dart';

import '../config/landing_config.dart';

class PrivacyNotAcceptedException implements Exception {
  const PrivacyNotAcceptedException();

  @override
  String toString() =>
      'Privacy policy must be accepted before joining the waitlist';
}

class WaitlistService {
  WaitlistService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  static const String collectionName = 'waitlist';
  static const String sourceLanding = 'landing';

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection(collectionName);

  Future<void> joinWaitlist({
    required String email,
    String? name,
    required bool privacyAccepted,
    required bool marketingConsent,
  }) async {
    if (!privacyAccepted) {
      throw const PrivacyNotAcceptedException();
    }

    final trimmedEmail = email.trim().toLowerCase();
    final trimmedName = name?.trim();

    await _collection.add({
      'email': trimmedEmail,
      'name': trimmedName == null || trimmedName.isEmpty ? null : trimmedName,
      'createdAt': FieldValue.serverTimestamp(),
      'source': sourceLanding,
      'privacyAccepted': true,
      'privacyAcceptedAt': FieldValue.serverTimestamp(),
      'privacyPolicyVersion': LandingConfig.privacyPolicyVersion,
      'marketingConsent': marketingConsent,
      'marketingConsentAt':
          marketingConsent ? FieldValue.serverTimestamp() : null,
      'termsVersion': LandingConfig.termsVersion,
      'cookiePolicyVersion': LandingConfig.cookiePolicyVersion,
    });
  }
}

bool isValidWaitlistEmail(String email) {
  final trimmed = email.trim();
  if (trimmed.isEmpty || trimmed.length > 320) {
    return false;
  }

  final emailPattern = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
  return emailPattern.hasMatch(trimmed);
}
