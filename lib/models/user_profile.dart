import 'package:flutter/material.dart';

class UserProfile {
  final String uid;
  int streak;
  DateTime? lastReviewDate;
  List<String> completedLessonsIDs;
  Map<String, int> challengesProgress; // Nowość: trzymamy tu postęp każdego wyzwania

  UserProfile({
    required this.uid,
    this.streak = 0,
    this.lastReviewDate,
    this.completedLessonsIDs = const [],
    this.challengesProgress = const {},
  });

  // Konwersja na mapę do Firebase
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'streak': streak,
      'lastReviewDate': lastReviewDate?.toIso8601String(),
      'completedLessonsIDs': completedLessonsIDs,
      'challengesProgress': challengesProgress,
    };
  }

  // Tworzenie obiektu z danych z Firebase
  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      uid: map['uid'] ?? '',
      streak: map['streak'] ?? 0,
      lastReviewDate: map['lastReviewDate'] != null 
          ? DateTime.parse(map['lastReviewDate']) 
          : null,
      completedLessonsIDs: List<String>.from(map['completedLessonsIDs'] ?? []),
      challengesProgress: Map<String, int>.from(map['challengesProgress'] ?? {}),
    );
  }
}