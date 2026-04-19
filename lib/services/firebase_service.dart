import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_profile.dart';

class FirebaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Pobieranie danych użytkownika
  Future<UserProfile?> getUserProfile(String uid) async {
    var doc = await _db.collection('users').doc(uid).get();
    if (doc.exists) {
      return UserProfile.fromMap(doc.data()!);
    }
    return null;
  }

  // Zapisywanie/Aktualizacja postępu
  Future<void> saveUserProfile(UserProfile profile) async {
    await _db.collection('users').doc(profile.uid).set(
      profile.toMap(),
      SetOptions(merge: true), // Merge sprawia, że nie nadpisujemy całego dokumentu, tylko zmienione pola
    );
  }

  // Szybka metoda do aktualizacji konkretnego wyzwania
  Future<void> updateChallenge(String uid, String challengeId, int progress) async {
    await _db.collection('users').doc(uid).update({
      'challengesProgress.$challengeId': progress,
    });
  }
}