class UserProfile {
  final String uid; 
  int streak;
  DateTime? lastReviewDate;
  List<String> completedLessonsIDs;
  Map<String, int> challengesProgress;
  Map<String, String> lastChallengeClickDates;

  UserProfile({
    required this.uid,
    required this.streak,
    this.lastReviewDate,
    required this.completedLessonsIDs,
    required this.challengesProgress,
    required this.lastChallengeClickDates,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      uid: json['uid'],
      streak: json['streak'],
      lastReviewDate: json['lastReviewDate'] != null ? DateTime.parse(json['lastReviewDate']) : null,
      completedLessonsIDs: List<String>.from(json['completedLessonsIDs']),
      challengesProgress: Map<String, int>.from(json['challengesProgress']),
      lastChallengeClickDates: Map<String, String>.from(json['lastChallengeClickDates'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'streak': streak,
      'lastReviewDate': lastReviewDate?.toIso8601String(),
      'completedLessonsIDs': completedLessonsIDs,
      'challengesProgress': challengesProgress,
      'lastChallengeClickDates': lastChallengeClickDates,
    };
  }
}