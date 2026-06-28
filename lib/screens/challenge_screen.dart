/// Screen displaying the list of unlocked challenges.
/// Parses medal requirements from JSON and prevents duplicate daily completion
/// using the UserProvider verification system.
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
  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final profile = userProvider.profile;

    if (userProvider.isLoading || profile == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator(color: Colors.green)));
    }

    final activeHabits = appNodes.where((node) {
      if (!profile.completedLessonsIDs.contains(node.id)) return false;
      final content = userProvider.lessonContents[node.id];
      return content != null && content['challenges'] != null;
    }).toList();

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
                final lessonContent = userProvider.lessonContents[node.id];
                
                bool hasSilver = lessonContent?['challenges']?['silver'] != null;
                bool hasGold = lessonContent?['challenges']?['gold'] != null;

                int reqBronze = lessonContent?['challenges']?['bronze']?['days'] ?? 6;
                int reqSilver = lessonContent?['challenges']?['silver']?['days'] ?? 14;
                int reqGold = lessonContent?['challenges']?['gold']?['days'] ?? 30;

                int bronze = profile.challengesProgress['${node.id}_braz'] ?? 0;
                int silver = profile.challengesProgress['${node.id}_srebro'] ?? 0;
                int gold = profile.challengesProgress['${node.id}_zloto'] ?? 0;

                String currentStage = 'braz';
                int currentProgress = bronze;
                int currentTotal = reqBronze;
                Color cardColor = Colors.orange[700]!;
                String stageName = 'Brązowy';
                String jsonStageKey = 'bronze'; 
                bool hasNextStage = hasSilver;

                if (bronze >= reqBronze) {
                  if (hasSilver) {
                    if (silver >= reqSilver) {
                      if (hasGold) {
                        currentStage = 'zloto';
                        currentProgress = gold;
                        currentTotal = reqGold;
                        cardColor = Colors.amber[600]!;
                        stageName = 'Złoty';
                        jsonStageKey = 'gold';
                        hasNextStage = false;
                      } else {
                        currentStage = 'srebro';
                        currentProgress = reqSilver;
                        currentTotal = reqSilver;
                        cardColor = Colors.blueGrey[400]!;
                        stageName = 'Srebrny';
                        jsonStageKey = 'silver';
                        hasNextStage = false;
                      }
                    } else {
                      currentStage = 'srebro';
                      currentProgress = silver;
                      currentTotal = reqSilver;
                      cardColor = Colors.blueGrey[400]!;
                      stageName = 'Srebrny';
                      jsonStageKey = 'silver';
                      hasNextStage = hasGold;
                    }
                  } else {
                    currentStage = 'braz';
                    currentProgress = reqBronze;
                    currentTotal = reqBronze;
                    cardColor = Colors.orange[700]!;
                    stageName = 'Brązowy';
                    jsonStageKey = 'bronze';
                    hasNextStage = false;
                  }
                }

                final challengeKey = '${node.id}_$currentStage';
                
                String challengeDescription = "Zdobądź ten medal!";
                if (lessonContent != null && lessonContent['challenges'] != null) {
                  challengeDescription = lessonContent['challenges'][jsonStageKey]?['text'] ?? challengeDescription;
                }

                return _buildHabitCard(
                  context: context,
                  nodeId: node.id,
                  challengeKey: challengeKey,
                  lessonTitle: node.title,
                  stageName: stageName,
                  description: challengeDescription,
                  progress: currentProgress,
                  total: currentTotal,
                  color: cardColor,
                  hasNextStage: hasNextStage,
                  userProvider: userProvider,
                );
              },
            ),
    );
  }

  Widget _buildHabitCard({
    required BuildContext context,
    required String nodeId,
    required String challengeKey,
    required String lessonTitle,
    required String stageName,
    required String description,
    required int progress,
    required int total,
    required Color color,
    required bool hasNextStage,
    required UserProvider userProvider,
  }) {
    double percent = progress / total;
    bool isCompleted = progress >= total;
    bool isButtonActive = userProvider.isChallengeAvailableToday(nodeId) && !isCompleted;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border(left: BorderSide(color: color, width: 6)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))],
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
          const SizedBox(height: 12),
          
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(8)),
            child: Text(
              description,
              style: TextStyle(color: Colors.grey[800], fontSize: 14, height: 1.4),
            ),
          ),
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
              onPressed: isButtonActive ? () => userProvider.updateChallenge(nodeId, challengeKey, progress + 1) : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: Text(isCompleted 
                ? (hasNextStage ? "AWANS ODBLOKOWANY" : "PEŁNE MISTRZOSTWO!") 
                : (isButtonActive ? "ZALICZ DZISIAJ" : "ZROBIONE NA DZIŚ")),
            ),
          ),
        ],
      ),
    );
  }
}