import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import '../models/lesson_data.dart';
import '../services/user_provider.dart';

class FlashcardLessonScreen extends StatefulWidget {
  // 🔥 ZMIANA: Teraz ten ekran przyjmuje MapNode, a nie Lesson!
  final MapNode lesson; 

  const FlashcardLessonScreen({super.key, required this.lesson});

  @override
  State<FlashcardLessonScreen> createState() => _FlashcardLessonScreenState();
}

class _FlashcardLessonScreenState extends State<FlashcardLessonScreen> {
  int _currentIndex = 0;
  bool _showQuiz = false;
  bool _isFlipped = false;
  int? _selectedAnswerIndex;

  void _nextCard() {
    if (_currentIndex < widget.lesson.flashcards.length - 1) {
      setState(() {
        _currentIndex++;
        _isFlipped = false; 
      });
    } else {
      setState(() {
        _showQuiz = true; 
      });
    }
  }

  void _checkAnswer() {
    if (_selectedAnswerIndex == null) return;

    if (_selectedAnswerIndex == widget.lesson.finalQuiz.correctAnswerIndex) {
      context.read<UserProvider>().completeLesson(widget.lesson.id);
      
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          title: const Text("Gratulacje! 🎉"),
          content: const Text("Lekcja ukończona! Odblokowano nowe wyzwania na Twojej ścieżce."),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text("Zakończ"),
            )
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Niestety to zła odpowiedź. Spróbuj jeszcze raz! ❌"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Zabezpieczenie na wypadek braku fiszek (np. w poziomie START)
    if (widget.lesson.flashcards.isEmpty && !_showQuiz) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _showQuiz = true;
        });
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(widget.lesson.title),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              LinearProgressIndicator(
                value: _showQuiz ? 1.0 : (_currentIndex + 1) / (widget.lesson.flashcards.length + 1),
                backgroundColor: Colors.grey[300],
                color: Colors.green,
                minHeight: 8,
              ),
              const SizedBox(height: 32),
              Expanded(
                child: _showQuiz ? _buildQuizView() : _buildFlashcardView(),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _showQuiz 
                  ? (_selectedAnswerIndex != null ? _checkAnswer : null) 
                  : _nextCard, 
                child: Text(
                  _showQuiz ? "SPRAWDŹ ODPOWIEDŹ" : "DALEJ",
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFlashcardView() {
    if (widget.lesson.flashcards.isEmpty) return const SizedBox();
    final card = widget.lesson.flashcards[_currentIndex];
    
    return GestureDetector(
      onTap: () => setState(() => _isFlipped = !_isFlipped),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (Widget child, Animation<double> animation) {
          final rotateAnim = Tween(begin: pi, end: 0.0).animate(animation);
          return AnimatedBuilder(
            animation: rotateAnim,
            child: child,
            builder: (context, widget) {
              final isUnder = (ValueKey(_isFlipped) != widget?.key);
              final value = isUnder ? min(rotateAnim.value, pi / 2) : rotateAnim.value;
              return Transform(
                transform: Matrix4.rotationY(value),
                alignment: Alignment.center,
                child: widget,
              );
            },
          );
        },
        child: Card(
          key: ValueKey(_isFlipped),
          elevation: 8,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: _isFlipped ? Colors.green[50] : Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _isFlipped ? Icons.lightbulb_outline : Icons.help_outline, 
                  size: 48, 
                  color: _isFlipped ? Colors.green : Colors.orange
                ),
                const SizedBox(height: 24),
                Text(
                  _isFlipped ? card.back : card.front,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                ),
                const Spacer(),
                Text("Dotknij, aby odwrócić", style: TextStyle(color: Colors.grey[500]))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuizView() {
    final quiz = widget.lesson.finalQuiz;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text("Czas na test!", textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green)),
        const SizedBox(height: 24),
        Text(quiz.question, textAlign: TextAlign.center, style: const TextStyle(fontSize: 20)),
        const SizedBox(height: 32),
        ...List.generate(quiz.options.length, (index) {
          final isSelected = _selectedAnswerIndex == index;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: isSelected ? Colors.green[50] : Colors.white,
                side: BorderSide(color: isSelected ? Colors.green : Colors.grey[300]!, width: 2),
                padding: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () => setState(() => _selectedAnswerIndex = index),
              child: Text(
                quiz.options[index],
                style: TextStyle(
                  fontSize: 16, 
                  color: isSelected ? Colors.green[800] : Colors.black87,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}