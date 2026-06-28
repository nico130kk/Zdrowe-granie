import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle; 
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_profile.dart';

class UserProvider extends ChangeNotifier {
  UserProfile? _profile;
  bool _isLoading = false;
  
  Map<String, dynamic> _lessonContents = {};

  UserProfile? get profile => _profile;
  bool get isLoading => _isLoading;
  Map<String, dynamic> get lessonContents => _lessonContents;

  // Sprawdza, czy gracz kliknął już dzisiaj przycisk powtórki
  bool get isDailyReviewDone {
    if (_profile?.lastReviewDate == null) return false;
    final now = DateTime.now();
    return _profile!.lastReviewDate!.year == now.year &&
           _profile!.lastReviewDate!.month == now.month &&
           _profile!.lastReviewDate!.day == now.day;
  }

  // Wrzuca wszystkie pytania z ukończonych lekcji do wiadra, miesza i zwraca losowe
  List<dynamic> getRandomReviewQuestions() {
    if (_profile == null) return [];
    List<dynamic> pool = [];
    
    for (String lessonId in _profile!.completedLessonsIDs) {
      final content = _lessonContents[lessonId];
      if (content != null && content['quiz'] != null) {
        pool.addAll(content['quiz']);
      }
    }
    
    pool.shuffle(); // Losowanie!
    return pool.take(5).toList(); // Bierzemy max 5 pytań (jak mniej, weźmie wszystkie)
  }

  Future<void> loadUser(String uid) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      final String response = await rootBundle.loadString('assets/data.json');
      final data = json.decode(response);
      for (var topic in data['topics']) {
        _lessonContents[topic['id']] = topic;
      }

      final prefs = await SharedPreferences.getInstance();
      final userDataString = prefs.getString('local_user_data');

      if (userDataString != null) {
        _profile = UserProfile.fromJson(jsonDecode(userDataString));
      } else {
        _profile = UserProfile(
          uid: 'local_user',
          streak: 0,
          completedLessonsIDs: [],
          challengesProgress: {}, 
        );
        await _saveToLocal();
      }
    } catch (e) {
      debugPrint("Error loading data: $e");
    }
    
    _isLoading = false;
    notifyListeners();
  }

  Future<void> _saveToLocal() async {
    if (_profile == null) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('local_user_data', jsonEncode(_profile!.toJson()));
  }

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
      // Dziś już zaliczone - nic nie robimy z licznikiem
    } else if (today.difference(lastReview).inDays == 1) {
      _profile!.streak += 1;
    } else {
      _profile!.streak = 1; // Stracony streak, zaczynamy od nowa
    }

    _profile!.lastReviewDate = now;
    notifyListeners();
    await _saveToLocal();
  }

  Future<void> updateChallenge(String challengeId, int newProgress) async {
    if (_profile == null) return;
    _profile!.challengesProgress[challengeId] = newProgress;
    notifyListeners();
    await _saveToLocal();
  }

  Future<void> completeLesson(String lessonId) async {
    if (_profile == null) return;
    if (!_profile!.completedLessonsIDs.contains(lessonId)) {
      _profile!.completedLessonsIDs.add(lessonId);
      
      final content = _lessonContents[lessonId];
      if (content != null && content['challenges'] != null) {
        _profile!.challengesProgress['${lessonId}_braz'] = _profile!.challengesProgress['${lessonId}_braz'] ?? 0;
      }
      
      notifyListeners();
      await _saveToLocal();
    }
  }
}