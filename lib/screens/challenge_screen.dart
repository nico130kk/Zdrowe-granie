import 'package:flutter/material.dart';

class ChallengesScreen extends StatefulWidget {
  const ChallengesScreen({super.key});

  @override
  State<ChallengesScreen> createState() => _ChallengesScreenState();
}

class _ChallengesScreenState extends State<ChallengesScreen> {
  // Limity dni dla poszczególnych medali
  final int _maxBronzeDays = 6;
  final int _maxSilverDays = 14;
  final int _maxGoldDays = 30;

  // Postęp dla każdego etapu osobno
  int _bronzeProgress = 0;
  int _silverProgress = 0;
  int _goldProgress = 0;

  bool _canCheckToday = true;

  // Sprawdzamy, czy dany etap jest ukończony
  bool get _isBronzeDone => _bronzeProgress >= _maxBronzeDays;
  bool get _isSilverDone => _silverProgress >= _maxSilverDays;
  bool get _isGoldDone => _goldProgress >= _maxGoldDays;

  void _markTodayDone() {
    if (_canCheckToday) {
      setState(() {
        // Zwiększamy licznik tylko aktualnego wyzwania
        if (!_isBronzeDone) {
          _bronzeProgress++;
          _showSnack('Krok bliżej do Brązu! 🥉', _bronzeProgress, _maxBronzeDays);
        } else if (!_isSilverDone) {
          _silverProgress++;
           _showSnack('Krok bliżej do Srebra! 🥈', _silverProgress, _maxSilverDays);
        } else if (!_isGoldDone) {
          _goldProgress++;
           _showSnack('Krok bliżej do Złota! 🥇', _goldProgress, _maxGoldDays);
        }

        _canCheckToday = false;
      });
    }
  }

  void _showSnack(String msg, int progress, int max) {
    bool finished = progress == max;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(finished ? 'Gratulacje! Poziom ukończony!' : msg),
          backgroundColor: const Color(0xFF00C853),
          duration: const Duration(seconds: 2),
        ),
      );
  }

  void _debugNextDay() {
    setState(() {
      _canCheckToday = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('⏳ Symulacja: Nastał nowy dzień!'), duration: Duration(seconds: 1)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Wyzwania', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.fast_forward, color: Colors.grey),
            onPressed: _debugNextDay,
            tooltip: 'Następny dzień (Test)',
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // LOGIKA WYŚWIETLANIA:
          // Jeśli Brąz NIE jest skończony -> Pokaż Brąz
          if (!_isBronzeDone)
            _buildSegmentedChallengeCard(
              title: 'Sól: Brąz',
              medalIconColor: Colors.brown.shade400,
              progress: _bronzeProgress,
              maxProgress: _maxBronzeDays,
              isActive: true,
              canCheckToday: _canCheckToday,
              onCheckIn: _markTodayDone,
              description: 'Nie dosalaj niczego na talerzu. Wytrzymaj 6 dni!',
            )
          // W przeciwnym razie, jeśli Srebro NIE jest skończone -> Pokaż Srebro
          else if (!_isSilverDone)
            _buildSegmentedChallengeCard(
              title: 'Sól: Srebro',
              medalIconColor: Colors.grey.shade400,
              progress: _silverProgress,
              maxProgress: _maxSilverDays,
              isActive: true,
              canCheckToday: _canCheckToday,
              onCheckIn: _markTodayDone,
              description: 'Unikaj fast foodów i chipsów. Wytrzymaj 14 dni!',
            )
          // W przeciwnym razie, jeśli Złoto NIE jest skończone -> Pokaż Złoto
          else if (!_isGoldDone)
            _buildSegmentedChallengeCard(
              title: 'Sól: Złoto',
              medalIconColor: Colors.amber,
              progress: _goldProgress,
              maxProgress: _maxGoldDays,
              isActive: true,
              canCheckToday: _canCheckToday,
              onCheckIn: _markTodayDone,
              description: 'Pełna kontrola soli. Wytrzymaj 30 dni!',
            )
          // Jeśli wszystko skończone -> Ekran zwycięstwa
          else
             Container(
               padding: const EdgeInsets.all(30),
               alignment: Alignment.center,
               child: const Column(
                 children: [
                   Icon(Icons.emoji_events, size: 80, color: Colors.amber),
                   SizedBox(height: 20),
                   Text("Mistrz Soli!", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                   SizedBox(height: 10),
                   Text("Ukończyłeś wszystkie wyzwania na ten temat.", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
                 ],
               ),
             )
        ],
      ),
    );
  }

  Widget _buildSegmentedChallengeCard({
    required String title,
    required Color medalIconColor,
    required int progress,
    required int maxProgress,
    required bool isActive,
    bool canCheckToday = false,
    VoidCallback? onCheckIn,
    String description = '',
  }) {
    // Obliczamy ile dni zostało
    int remainingDays = maxProgress - progress;
    // Sprawdzamy czy ten konkretny etap jest skończony
    bool isCompleted = progress >= maxProgress;

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.black12, width: 2)),
      ),
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w400,
                  color: isActive ? Colors.black : Colors.grey,
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.military_tech, color: medalIconColor, size: 28),
            ],
          ),
          
          if (isActive && description.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4, bottom: 8),
              child: Text(description, style: const TextStyle(color: Colors.grey, fontSize: 13)),
            ),
            
          const SizedBox(height: 12),

          // Renderowanie "kreseczek" postępu
          Row(
            children: List.generate(maxProgress, (index) {
              return Expanded(
                child: Container(
                  height: 24,
                  // Dodajemy mały margines między segmentami (chyba że to ostatni)
                  margin: EdgeInsets.only(right: index == maxProgress - 1 ? 0 : 2),
                  // Zielony jeśli index < progress, szary jeśli nie
                  color: index < progress 
                      ? const Color(0xFF00C853) 
                      : Colors.grey.shade200,   
                ),
              );
            }),
          ),
          
          const SizedBox(height: 12),
          
          // Dolny pasek (Licznik i Przycisk)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isCompleted ? 'Ukończono!' : '$remainingDays/$maxProgress dni pozostało',
                style: TextStyle(
                  color: isCompleted ? const Color(0xFF00C853) : Colors.grey.shade600,
                  fontWeight: isCompleted ? FontWeight.bold : FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              
              if (isActive && !isCompleted)
                ElevatedButton(
                  onPressed: canCheckToday ? onCheckIn : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00C853),
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey.shade300,
                    elevation: 0,
                  ),
                  child: Text(canCheckToday ? 'Odhacz dzisiaj' : 'Wróć jutro'),
                ),
            ],
          ),
        ],
      ),
    );
  }
}