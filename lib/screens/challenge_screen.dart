import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/user_provider.dart';
import '../models/lesson_data.dart';

class ChallengesScreen extends StatefulWidget {
  const ChallengesScreen({super.key});

  @override
  State<ChallengesScreen> createState() => _ChallengesScreenState();
}

class _ChallengesScreenState extends State<ChallengesScreen> {
  final Set<String> _clickedTodayIds = {};

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final profile = userProvider.profile;

    if (userProvider.isLoading || profile == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator(color: Colors.green)));
    }

    final activeHabits = appNodes.where(
      (node) => profile.completedLessonsIDs.contains(node.id)
    ).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      appBar: AppBar(
        title: const Text("Wyzwania i Medale", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: activeHabits.isEmpty
          ? Center(
              child: Text(
                "Ukończ pierwszą lekcję na Mapie,\naby odblokować wyzwania!",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600], fontSize: 16),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: activeHabits.length,
              itemBuilder: (context, index) {
                final node = activeHabits[index];
                
                // Pobieramy postępy dla wszystkich 3 medali z danej lekcji
                int bronze = profile.challengesProgress['${node.id}_braz'] ?? 0;
                int silver = profile.challengesProgress['${node.id}_srebro'] ?? 0;
                int gold = profile.challengesProgress['${node.id}_zloto'] ?? 0;

                // 🔥 LOGIKA AWANSU MEDALU 🔥
                String currentStage = 'braz';
                int currentProgress = bronze;
                int currentTotal = 6;
                Color cardColor = Colors.orange[700]!;
                String stageName = 'Brązowy';

                if (bronze >= 6) {
                  if (silver >= 14) {
                    currentStage = 'zloto';
                    currentProgress = gold;
                    currentTotal = 30;
                    cardColor = Colors.amber[600]!;
                    stageName = 'Złoty';
                  } else {
                    currentStage = 'srebro';
                    currentProgress = silver;
                    currentTotal = 14;
                    cardColor = Colors.blueGrey[400]!;
                    stageName = 'Srebrny';
                  }
                }

                final challengeKey = '${node.id}_$currentStage';

                return _buildHabitCard(
                  context: context,
                  challengeKey: challengeKey,
                  lessonTitle: node.title,
                  stageName: stageName,
                  progress: currentProgress,
                  total: currentTotal,
                  color: cardColor,
                  onTap: () {
                    userProvider.updateChallenge(challengeKey, currentProgress + 1);
                    setState(() => _clickedTodayIds.add(challengeKey));
                  },
                );
              },
            ),
    );
  }

  Widget _buildHabitCard({
    required BuildContext context,
    required String challengeKey,
    required String lessonTitle,
    required String stageName,
    required int progress,
    required int total,
    required Color color,
    required VoidCallback onTap,
  }) {
    double percent = progress / total;
    bool isCompleted = progress >= total;
    bool isButtonActive = !_clickedTodayIds.contains(challengeKey) && !isCompleted;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border(left: BorderSide(color: color, width: 6)), // Kolorowy pasek z boku
        boxShadow: [
          // Złagodzony cień, żeby nie wywalało błędu withOpacity
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text("Nawyk: $lessonTitle", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              Icon(Icons.military_tech, color: color, size: 32),
            ],
          ),
          const SizedBox(height: 4),
          Text("Poziom: Medal $stageName", style: TextStyle(color: color, fontWeight: FontWeight.w600)),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: percent > 1.0 ? 1.0 : percent,
            backgroundColor: Colors.grey[200],
            color: color,
            minHeight: 10,
            borderRadius: BorderRadius.circular(5),
          ),
          const SizedBox(height: 8),
          Text(isCompleted ? "Wyzwanie Ukończone! 🏆" : "Postęp: $progress / $total dni", 
            style: TextStyle(color: isCompleted ? color : Colors.grey[600], fontWeight: FontWeight.bold)
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isButtonActive ? onTap : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: Text(isCompleted 
                ? (stageName == 'Złoty' ? "PEŁNE MISTRZOSTWO!" : "AWANS ODBLOKOWANY") 
                : (isButtonActive ? "ZALICZ DZISIAJ" : "ZROBIONE NA DZIŚ")),
            ),
          ),
        ],
      ),
    );
  }
}