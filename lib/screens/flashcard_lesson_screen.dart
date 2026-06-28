import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/lesson_data.dart';
import '../services/user_provider.dart';

class FlashcardLessonScreen extends StatefulWidget {
  final MapNode lesson; 

  const FlashcardLessonScreen({super.key, required this.lesson});

  @override
  State<FlashcardLessonScreen> createState() => _FlashcardLessonScreenState();
}

class _FlashcardLessonScreenState extends State<FlashcardLessonScreen> {
  int _currentIndex = 0;
  List<String> _slides = [];

  @override
  void initState() {
    super.initState();
    // Pobieramy teksty z JSONa po ID lekcji podczas inicjalizacji ekranu
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final content = context.read<UserProvider>().lessonContents[widget.lesson.id];
      if (content != null && content['flashcards'] != null) {
        setState(() {
          _slides = List<String>.from(content['flashcards']);
        });
      }
    });
  }

  void _nextSlide() {
    if (_currentIndex < _slides.length - 1) {
      setState(() {
        _currentIndex++;
      });
    } else {
      // Skoro z JSONa usunięto quiz, to od razu kończymy lekcję
      _completeLesson();
    }
  }

  void _completeLesson() {
    context.read<UserProvider>().completeLesson(widget.lesson.id);
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text("Gratulacje! 🎉"),
        content: const Text("Lekcja ukończona! Odblokowano nowe wyzwania na Twojej ścieżce."),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
            onPressed: () {
              Navigator.pop(context); // Zamknij dialog
              Navigator.pop(context); // Wróc na mapę
            },
            child: const Text("Zakończ"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_slides.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator(color: Colors.green)));
    }

    final isLastSlide = _currentIndex == _slides.length - 1;

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
                value: (_currentIndex + 1) / _slides.length,
                backgroundColor: Colors.grey[300],
                color: Colors.green,
                minHeight: 8,
                borderRadius: BorderRadius.circular(4),
              ),
              const SizedBox(height: 32),
              Expanded(
                child: Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.menu_book, size: 48, color: Colors.green[400]),
                          const SizedBox(height: 24),
                          Text(
                            _slides[_currentIndex],
                            textAlign: TextAlign.justify,
                            style: const TextStyle(fontSize: 18, height: 1.5, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isLastSlide ? Colors.orange : Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _nextSlide, 
                child: Text(
                  isLastSlide ? "ZAKOŃCZ LEKCJĘ" : "DALEJ",
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}