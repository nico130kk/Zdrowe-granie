import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/user_provider.dart';
import '../screens/flashcard_lesson_screen.dart';
import '../models/lesson_data.dart'; // Importujemy naszą bazę wiedzy

class LessonsScreen extends StatelessWidget {
  const LessonsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final profile = userProvider.profile;

    if (userProvider.isLoading || profile == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator(color: Colors.green)));
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Baza Wiedzy", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: appLessons.length, // Tyle kart, ile mamy lekcji w bazie
        itemBuilder: (context, index) {
          final lesson = appLessons[index];
          
          // 🔥 MAGIA KŁÓDKI 🔥
          bool isLocked = false;
          if (lesson.requiredChallengeId != null) {
            // Jeśli lekcja czegoś wymaga, sprawdzamy ile dni gracz wyklikał w tym wyzwaniu
            int challengeProgress = profile.challengesProgress[lesson.requiredChallengeId] ?? 0;
            // Kłódka jest zamknięta, jeśli postęp jest mniejszy niż wymagany (np. < 6)
            isLocked = challengeProgress < lesson.requiredChallengeLevel;
          }

          return _buildLessonCard(context, lesson, isLocked);
        },
      ),
    );
  }

  // WIDŻET KARTY LEKCJI
  Widget _buildLessonCard(BuildContext context, Lesson lesson, bool isLocked) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: isLocked ? 0 : 4,
      color: isLocked ? Colors.grey[300] : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: isLocked 
          ? () {
              // Reakcja na kliknięcie zablokowanej lekcji
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Musisz najpierw zdobyć Brązowy Medal z poprzedniej lekcji! 🔒")),
              );
            } 
          : () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FlashcardLessonScreen(lesson: lesson),
                ),
              );

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Otwieram: ${lesson.title} 🚀")),
              );
            },
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isLocked ? Colors.grey[400] : Colors.green[100],
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isLocked ? Icons.lock : Icons.menu_book,
                  color: isLocked ? Colors.white : Colors.green[800],
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lesson.title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isLocked ? Colors.grey[600] : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isLocked ? "Zablokowane" : "Dotknij, aby rozpocząć naukę",
                      style: TextStyle(
                        color: isLocked ? Colors.grey[500] : Colors.green[600],
                        fontSize: 14,
                        fontWeight: isLocked ? FontWeight.normal : FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              if (!isLocked)
                Icon(Icons.chevron_right, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }
}