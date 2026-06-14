import 'package:cloud_firestore/cloud_firestore.dart';

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
  }) async {
    final trimmedEmail = email.trim().toLowerCase();
    final trimmedName = name?.trim();

    await _collection.add({
      'email': trimmedEmail,
      'name': trimmedName == null || trimmedName.isEmpty ? null : trimmedName,
      'createdAt': FieldValue.serverTimestamp(),
      'source': sourceLanding,
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
