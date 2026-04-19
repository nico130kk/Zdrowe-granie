import 'package:flutter/material.dart';
import '../models/user_profile.dart';
import 'firebase_service.dart';

class UserProvider extends ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();
  UserProfile? _profile;
  bool _isLoading = false;

  // Gettery - ekrany będą z tego czytać
  UserProfile? get profile => _profile;
  bool get isLoading => _isLoading;

  // Główna funkcja ładowania - odpalamy ją raz przy starcie apki
  Future<void> loadUser(String uid) async {
    _isLoading = true;
    notifyListeners();

    try {
      // 1. Próbujemy pobrać profil z chmury
      _profile = await _firebaseService.getUserProfile(uid);

      // 2. JEŚLI PROFIL NIE ISTNIEJE (Pierwsze uruchomienie apki)
      if (_profile == null) {
        print("User nie istnieje. Tworzę nowy profil dla: $uid");
        
        _profile = UserProfile(
          uid: uid,
          streak: 0,
          completedLessonsIDs: [],
          challengesProgress: {
            'sol_braz': 0,
            'sol_srebro': 0,
            'sol_zloto': 0,
          },
        );

        // Zapisujemy ten nowy profil od razu w Firebase
        await _firebaseService.saveUserProfile(_profile!);
      }
    } catch (e) {
      print("Błąd podczas ładowania: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  // Funkcja aktualizacji wyzwania - używana na ekranie wyzwań
  Future<void> updateChallenge(String challengeId, int newProgress) async {
    if (_profile == null) return;

    // Aktualizujemy dane w pamięci RAM (natychmiastowo)
    _profile!.challengesProgress[challengeId] = newProgress;
    _profile!.lastReviewDate = DateTime.now();
    notifyListeners(); // UI odświeży się w milisekundę!

    // Wysyłamy do Firebase w tle (użytkownik nie musi czekać na kółeczko)
    await _firebaseService.saveUserProfile(_profile!);
  }

  // Zaznacza lekcję jako ukończoną (odblokowuje wyzwanie)
  Future<void> completeLesson(String lessonId) async {
    if (_profile == null) return;
    
    // Sprawdzamy, czy jeszcze jej nie ukończył
    if (!_profile!.completedLessonsIDs.contains(lessonId)) {
      _profile!.completedLessonsIDs.add(lessonId);
      notifyListeners(); // Odświeża UI
      await _firebaseService.saveUserProfile(_profile!); // Wysyła do chmury
    }
  }

  // Metoda obsługująca codzienną powtórkę i streak
  Future<void> completeDailyReview() async {
    if (_profile == null) return;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    // Pobieramy datę ostatniej powtórki (jeśli istnieje)
    DateTime? lastReview = _profile!.lastReviewDate != null 
        ? DateTime(_profile!.lastReviewDate!.year, _profile!.lastReviewDate!.month, _profile!.lastReviewDate!.day)
        : null;

    if (lastReview == null) {
      // Pierwsza powtórka w historii konta
      _profile!.streak = 1;
    } else if (today.isAtSameMomentAs(lastReview)) {
      // Już dziś zrobione - nie zwiększamy streaka, ale aktualizujemy dane
      print("Streak już nabity na dziś.");
    } else if (today.difference(lastReview).inDays == 1) {
      // Powtórka wykonana dzień po dniu - STREAK ROŚNIE!
      _profile!.streak += 1;
    } else {
      // Była przerwa (więcej niż 1 dzień) - RESET STREAKA
      _profile!.streak = 1;
    }

    _profile!.lastReviewDate = now;
    notifyListeners();
    await _firebaseService.saveUserProfile(_profile!);
  }

  
}