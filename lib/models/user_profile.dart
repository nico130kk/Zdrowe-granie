import 'package:flutter/material.dart';

class UserProfile {
  String uid; // ID z Firebase
  int streak; // Aktualny płomień
  DateTime? lastReviewDate; // Kiedy ostatnio robił powtórkę? (do sprawdzania streaka)
  List<String> completedLessonsIDs; // Lista przerobionych tematów (do losowania powtórek)

  UserProfile({
    required this.uid,
    this.streak = 0,
    this.lastReviewDate,
    this.completedLessonsIDs = const [],
  });
}