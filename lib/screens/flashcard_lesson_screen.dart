import 'package:flutter/material.dart';
import '../widgets/flip_card.dart';

class FlashcardLessonScreen extends StatefulWidget {
  const FlashcardLessonScreen({super.key});
  @override
  State<FlashcardLessonScreen> createState() => _FlashcardLessonScreenState();
}

class _FlashcardLessonScreenState extends State<FlashcardLessonScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  final List<Map<String, String>> _flashcards = [
    {'front': 'Czym jest sól i za co odpowiada w organizmie?', 'back': 'Sól (chlorek sodu, NaCl) reguluje gospodarkę wodno-elektrolitową i pomaga we wchłanianiu składników w jelitach. Nie należy jej całkowicie unikać, lecz kontrolować jej ilość.'},
    {'front': 'Jakie są zalecenia WHO dotyczące spożycia soli?', 'back': 'Zaleca się spożywanie do ok. 5 gramów dziennie! Sportowcy mogą potrzebować jej więcej ze względu na szybsze zużycie podczas wysiłku.'},
    {'front': 'Czym może skutkować spożywanie zbyt dużej ilości soli?', 'back': '• Nadciśnieniem tętniczym\n• Chorobami sercowo-naczyniowymi\n• Chorobami nerek\n• Zatrzymywaniem wody i obrzękiem'},
    {'front': 'Jakie produkty zawierają najwięcej soli?', 'back': 'Pieczywo, wędliny, sery, dania instant, fast food, chipsy i przekąski, sosy (np. sojowy, ketchup) oraz konserwy.'},
    {'front': 'Mit: Sól himalajska (różowa) jest zdrowsza od zwykłej soli. Prawda czy fałsz?', 'back': 'Fałsz! Niezależnie od rodzaju, każda sól to głównie NaCl. Różnice mineralne są minimalne i bez większego znaczenia zdrowotnego.'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(title: const Text('Lekcja 1: Sól'), backgroundColor: Colors.white, foregroundColor: Colors.black, elevation: 0),
      body: Column(
        children: [
          LinearProgressIndicator(value: (_currentIndex + 1) / _flashcards.length, backgroundColor: Colors.grey.shade300, color: Colors.green, minHeight: 8),
          const SizedBox(height: 10),
          Text('Fiszka ${_currentIndex + 1} z ${_flashcards.length}', style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) => setState(() => _currentIndex = index),
              itemCount: _flashcards.length,
              itemBuilder: (context, index) => Padding(padding: const EdgeInsets.all(24.0), child: FlipCardWidget(frontText: _flashcards[index]['front']!, backText: _flashcards[index]['back']!)),
            ),
          ),
          const Padding(padding: EdgeInsets.only(bottom: 40.0), child: Text('Stuknij kartę, aby ją odwrócić.\nPrzesuń w lewo/prawo, aby zmienić fiszkę.', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey))),
        ],
      ),
    );
  }
}