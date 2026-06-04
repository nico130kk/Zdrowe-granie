class UserProfile {
  final String uid; // Zostawiamy dla porządku, będzie po prostu "local_user"
  int streak;
  DateTime? lastReviewDate;
  List<String> completedLessonsIDs;
  Map<String, int> challengesProgress;

  UserProfile({
    required this.uid,
    required this.streak,
    this.lastReviewDate,
    required this.completedLessonsIDs,
    required this.challengesProgress,
  });

  // Tłumaczenie z JSONa (Odczyt z dysku)
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      uid: json['uid'],
      streak: json['streak'],
      lastReviewDate: json['lastReviewDate'] != null ? DateTime.parse(json['lastReviewDate']) : null,
      completedLessonsIDs: List<String>.from(json['completedLessonsIDs']),
      challengesProgress: Map<String, int>.from(json['challengesProgress']),
    );
  }

  // Tłumaczenie na JSONa (Zapis na dysk)
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'streak': streak,
      'lastReviewDate': lastReviewDate?.toIso8601String(),
      'completedLessonsIDs': completedLessonsIDs,
      'challengesProgress': challengesProgress,
    };
  }
}