import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/user_provider.dart';

class DailyReviewScreen extends StatefulWidget {
  final List<dynamic> questions;

  const DailyReviewScreen({super.key, required this.questions});

  @override
  State<DailyReviewScreen> createState() => _DailyReviewScreenState();
}

class _DailyReviewScreenState extends State<DailyReviewScreen> {
  int _currentIndex = 0;
  int? _selectedAnswerIndex;

  void _checkAnswer() {
    if (_selectedAnswerIndex == null) return;

    final currentQuestion = widget.questions[_currentIndex];
    
    if (_selectedAnswerIndex == currentQuestion['correctAnswerIndex']) {
      // Poprawna odpowiedź - idziemy dalej lub kończymy
      if (_currentIndex < widget.questions.length - 1) {
        setState(() {
          _currentIndex++;
          _selectedAnswerIndex = null;
        });
      } else {
        // Koniec quizu, zaliczamy dzień!
        context.read<UserProvider>().completeDailyReview();
        
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => AlertDialog(
            title: const Text("Powtórka Zrobiona! 🔥", textAlign: TextAlign.center),
            content: const Text("Świetna robota! Twój licznik dni z rzędu właśnie wzrósł. Wracaj tu jutro!", textAlign: TextAlign.center),
            actions: [
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, foregroundColor: Colors.white),
                  onPressed: () {
                    Navigator.pop(context); // Zamknij dialog
                    Navigator.pop(context); // Zamknij ekran quizu
                  },
                  child: const Text("Zakończ"),
                ),
              )
            ],
          ),
        );
      }
    } else {
      // Zła odpowiedź
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Pudło! Spróbuj innej odpowiedzi. ❌"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = widget.questions[_currentIndex];
    final List<dynamic> options = currentQuestion['options'];

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Codzienna Powtórka", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              LinearProgressIndicator(
                value: (_currentIndex + 1) / widget.questions.length,
                backgroundColor: Colors.grey[300],
                color: Colors.orange,
                minHeight: 8,
                borderRadius: BorderRadius.circular(4),
              ),
              const SizedBox(height: 32),
              
              Text(
                "Pytanie ${_currentIndex + 1} z ${widget.questions.length}",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              
              Text(
                currentQuestion['question'],
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(height: 32),
              
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: List.generate(options.length, (index) {
                      final isSelected = _selectedAnswerIndex == index;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: InkWell(
                          onTap: () => setState(() => _selectedAnswerIndex = index),
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.orange[50] : Colors.white,
                              border: Border.all(
                                color: isSelected ? Colors.orange : Colors.grey[300]!,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              options[index],
                              style: TextStyle(
                                fontSize: 16, 
                                color: isSelected ? Colors.orange[800] : Colors.black87,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _selectedAnswerIndex != null ? _checkAnswer : null, 
                child: const Text(
                  "SPRAWDŹ ODPOWIEDŹ",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}