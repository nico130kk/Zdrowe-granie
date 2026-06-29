/// Screen responsible for displaying lesson content via flashcards or text summaries.
/// Safely handles empty or missing flashcard arrays from JSON to prevent infinite loading.

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

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final lessonContent = userProvider.lessonContents[widget.lesson.id];
    
    final List<dynamic> flashcards = lessonContent?['flashcards'] ?? [];

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      appBar: AppBar(
        title: Text(widget.lesson.title.replaceAll('\n', ' '), style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: flashcards.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.assignment_turned_in, size: 80, color: Colors.blueAccent.withValues(alpha: 0.8)),
                    const SizedBox(height: 24),
                    Text(
                      "Odblokowano etap:\n${widget.lesson.title}",
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Ten węzeł otwiera dostęp do kolejnych szczegółowych lekcji w tej gałęzi.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600], height: 1.4),
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          await userProvider.completeLesson(widget.lesson.id);
                          if (context.mounted) Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text("ZALICZ ETAP", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  LinearProgressIndicator(
                    value: (_currentIndex + 1) / flashcards.length,
                    backgroundColor: Colors.grey[200],
                    color: Colors.blueAccent,
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Fiszka ${_currentIndex + 1} z ${flashcards.length}",
                    style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 40),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 15, offset: const Offset(0, 8)),
                        ],
                      ),
                      child: Center(
                        child: SingleChildScrollView(
                          child: Text(
                            flashcards[_currentIndex].toString(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 18, height: 1.6, color: Colors.black87, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Row(
                    children: [
                      if (_currentIndex > 0)
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => setState(() => _currentIndex--),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.blueAccent, width: 2),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: const Text("POPRZEDNIA", style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      if (_currentIndex > 0) const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_currentIndex < flashcards.length - 1) {
                              setState(() => _currentIndex++);
                            } else {
                              await userProvider.completeLesson(widget.lesson.id);
                              if (context.mounted) Navigator.pop(context);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: Text(
                            _currentIndex < flashcards.length - 1 ? "DALEJ" : "ZALICZ LEKCJĘ",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}