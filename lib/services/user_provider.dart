import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_profile.dart';
import '../models/lesson_data.dart';

class UserProvider extends ChangeNotifier {
  UserProfile? _profile;
  bool _isLoading = false;

  UserProfile? get profile => _profile;
  bool get isLoading => _isLoading;

  // Pobiera listę pytań quizowych TYLKO z ukończonych lekcji
  List<QuizQuestion> get unlockedQuestions {
    if (_profile == null) return [];
    return appNodes
        .where((node) => _profile!.completedLessonsIDs.contains(node.id))
        .map((node) => node.finalQuiz)
        .toList();
  }

  // Ładowanie z pamięci lokalnej
  Future<void> loadUser(String uid) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final userDataString = prefs.getString('local_user_data');

      if (userDataString != null) {
        // Znaleziono zapis na telefonie
        _profile = UserProfile.fromJson(jsonDecode(userDataString));
      } else {
        // Pierwsze uruchomienie apki! Tworzymy czysty profil
        _profile = UserProfile(
          uid: 'local_user',
          streak: 0,
          completedLessonsIDs: [],
          challengesProgress: {}, // Puste wyzwania na start
        );
        await _saveToLocal();
      }
    } catch (e) {
      print("Błąd ładowania lokalnego: $e");
    }
    
    _isLoading = false;
    notifyListeners();
  }

  // Główna metoda zapisu na dysk
  Future<void> _saveToLocal() async {
    if (_profile == null) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('local_user_data', jsonEncode(_profile!.toJson()));
  }

  // Logika streaka i codziennej powtórki
  Future<void> completeDailyReview() async {
    if (_profile == null) return;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    DateTime? lastReview = _profile!.lastReviewDate != null 
        ? DateTime(_profile!.lastReviewDate!.year, _profile!.lastReviewDate!.month, _profile!.lastReviewDate!.day)
        : null;

    if (lastReview == null || _profile!.streak == 0) {
      _profile!.streak = 1;
    } else if (today.isAtSameMomentAs(lastReview)) {
      // Dziś już zaliczone
    } else if (today.difference(lastReview).inDays == 1) {
      _profile!.streak += 1;
    } else {
      _profile!.streak = 1;
    }

    _profile!.lastReviewDate = now;
    notifyListeners();
    await _saveToLocal();
  }

  // Odznaczanie dnia wyzwania
  Future<void> updateChallenge(String challengeId, int newProgress) async {
    if (_profile == null) return;
    _profile!.challengesProgress[challengeId] = newProgress;
    notifyListeners();
    await _saveToLocal();
  }

  // Ukończenie lekcji - otwiera wyzwanie
  Future<void> completeLesson(String lessonId) async {
    if (_profile == null) return;
    if (!_profile!.completedLessonsIDs.contains(lessonId)) {
      _profile!.completedLessonsIDs.add(lessonId);
      // Ustawiamy startowy postęp wyzwania dla tej lekcji na 0 (jeśli nie istnieje)
      _profile!.challengesProgress['${lessonId}_braz'] = _profile!.challengesProgress['${lessonId}_braz'] ?? 0;
      notifyListeners();
      await _saveToLocal();
    }
  }
}