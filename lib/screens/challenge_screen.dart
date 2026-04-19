import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/user_provider.dart';

class ChallengesScreen extends StatelessWidget {
  const ChallengesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Podpinamy się pod Magazyn (Provider)
    final userProvider = context.watch<UserProvider>();
    final profile = userProvider.profile;

    // 2. Obsługa ładowania i braku danych
    if (userProvider.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: Colors.green)),
      );
    }

    if (profile == null) {
      return const Scaffold(
        body: Center(child: Text("Błąd: Nie można załadować profilu.")),
      );
    }

    // 3. Pobranie danych z profilu
    int bronze = profile.challengesProgress['sol_braz'] ?? 0;
    int silver = profile.challengesProgress['sol_srebro'] ?? 0;
    int gold = profile.challengesProgress['sol_zloto'] ?? 0;

    // Logika sprawdzania, czy użytkownik już dziś kliknął
    bool canClickToday = true;
    if (profile.lastReviewDate != null) {
      final now = DateTime.now();
      final last = profile.lastReviewDate!;
      if (last.year == now.year && last.month == now.month && last.day == now.day) {
        canClickToday = false;
      }
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Twoje Wyzwania", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildChallengeSection(
            title: "🥉 Brązowy Medal (6 dni)",
            progress: bronze,
            total: 6,
            color: Colors.orange[800]!,
            isLocked: false,
          ),
          const SizedBox(height: 16),
          _buildChallengeSection(
            title: "🥈 Srebrny Medal (14 dni)",
            progress: silver,
            total: 14,
            color: Colors.blueGrey[400]!,
            isLocked: bronze < 6, // Zablokowane póki nie ma brązu
          ),
          const SizedBox(height: 16),
          _buildChallengeSection(
            title: "🥇 Złoty Medal (30 dni)",
            progress: gold,
            total: 30,
            color: Colors.amber[700]!,
            isLocked: silver < 14, // Zablokowane póki nie ma srebra
          ),
          const SizedBox(height: 32),
          
          // GŁÓWNY PRZYCISK AKCJI
          ElevatedButton(
            onPressed: canClickToday 
              ? () => _handleDailyProgress(context, userProvider, bronze, silver, gold)
              : null, // Przycisk nieaktywny jeśli już kliknięto
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(
              canClickToday ? "ODHACZ DZISIEJSZY TRENING" : "WYKONANO DZISIAJ ✅",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          if (!canClickToday)
            const Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Text("Wróć jutro, aby kontynuować serię!", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
            ),
        ],
      ),
    );
  }

  // LOGIKA ZWIĘKSZANIA PROGRESU
  void _handleDailyProgress(BuildContext context, UserProvider provider, int b, int s, int g) {
    if (b < 6) {
      provider.updateChallenge('sol_braz', b + 1);
    } else if (s < 14) {
      provider.updateChallenge('sol_srebro', s + 1);
    } else if (g < 30) {
      provider.updateChallenge('sol_zloto', g + 1);
    }
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Świetnie! Postęp zapisany w chmurze ☁️")),
    );
  }

  // WIDŻET POJEDYNCZEJ SEKCJI WYZWANIA
  Widget _buildChallengeSection({
    required String title, 
    required int progress, 
    required int total, 
    required Color color,
    required bool isLocked,
  }) {
    double percent = progress / total;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isLocked ? Colors.grey[200] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: TextStyle(
                fontSize: 16, 
                fontWeight: FontWeight.bold,
                color: isLocked ? Colors.grey : Colors.black87
              )),
              if (isLocked) const Icon(Icons.lock, size: 18, color: Colors.grey),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: percent,
            backgroundColor: Colors.grey[300],
            color: isLocked ? Colors.grey : color,
            minHeight: 10,
            borderRadius: BorderRadius.circular(5),
          ),
          const SizedBox(height: 8),
          Text("$progress / $total dni", style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }
}