class Flashcard {
  final String front;
  final String back;
  const Flashcard({required this.front, required this.back});
}

class QuizQuestion {
  final String question;
  final List<String> options;
  final int correctAnswerIndex;
  const QuizQuestion({required this.question, required this.options, required this.correctAnswerIndex});
}

class MapNode {
  final String id;
  final String title;
  final List<Flashcard> flashcards;
  final QuizQuestion finalQuiz;
  
  final double x;
  final double y;
  
  // ID lekcji, z której wywodzi się ta. 
  // Aby odblokować ten node, rodzic (np. 'start') musi mieć brązowy medal (6 dni).
  final String? requiredParentId;

  const MapNode({
    required this.id,
    required this.title,
    required this.flashcards,
    required this.finalQuiz,
    required this.x,
    required this.y,
    this.requiredParentId,
  });
}

// BAZA DANYCH DRZEWA WIEDZY - DOKŁADNIE JAK NA TWOIM RYSUNKU
const List<MapNode> appNodes = [
  // 1. ŚRODEK (Zawsze dostępny)
  MapNode(
    id: 'start',
    title: 'START',
    x: 0,
    y: 0,
    requiredParentId: null,
    flashcards: [
      Flashcard(front: 'Lorem ipsum 1?', back: 'Dolor sit amet.'),
    ],
    finalQuiz: QuizQuestion(question: 'Lorem?', options: ['Ipsum', 'Dolor'], correctAnswerIndex: 0),
  ),

  // 2. W GÓRĘ (Od startu)
  MapNode(
    id: 'up_1',
    title: 'Lorem Up',
    x: 0,
    y: -140,
    requiredParentId: 'start',
    flashcards: [Flashcard(front: 'Lorem ipsum?', back: 'Dolor sit amet.')],
    finalQuiz: QuizQuestion(question: 'Ipsum?', options: ['A', 'B'], correctAnswerIndex: 1),
  ),

  // 3. W DÓŁ (Od startu)
  MapNode(
    id: 'down_1',
    title: 'Lorem Down',
    x: 0,
    y: 140,
    requiredParentId: 'start',
    flashcards: [Flashcard(front: 'Lorem ipsum?', back: 'Dolor sit amet.')],
    finalQuiz: QuizQuestion(question: 'Ipsum?', options: ['A', 'B'], correctAnswerIndex: 1),
  ),

  // 4. W LEWO (Od startu)
  MapNode(
    id: 'left_1',
    title: 'Lorem Left',
    x: -140,
    y: 0,
    requiredParentId: 'start',
    flashcards: [Flashcard(front: 'Lorem ipsum?', back: 'Dolor sit amet.')],
    finalQuiz: QuizQuestion(question: 'Ipsum?', options: ['A', 'B'], correctAnswerIndex: 1),
  ),

  // 5. W PRAWO (Od startu)
  MapNode(
    id: 'right_1',
    title: 'Lorem Right',
    x: 140,
    y: 0,
    requiredParentId: 'start',
    flashcards: [Flashcard(front: 'Lorem ipsum?', back: 'Dolor sit amet.')],
    finalQuiz: QuizQuestion(question: 'Ipsum?', options: ['A', 'B'], correctAnswerIndex: 1),
  ),

  // 6. ROZGAŁĘZIENIE Z PRAWEGO: W GÓRĘ-PRAWO
  MapNode(
    id: 'right_top',
    title: 'Lorem R-Top',
    x: 260,
    y: -80,
    requiredParentId: 'right_1', // Odblokuje się, gdy 'right_1' zdobędzie brąz!
    flashcards: [Flashcard(front: 'Lorem ipsum?', back: 'Dolor sit amet.')],
    finalQuiz: QuizQuestion(question: 'Ipsum?', options: ['A', 'B'], correctAnswerIndex: 1),
  ),

  // 7. ROZGAŁĘZIENIE Z PRAWEGO: W DÓŁ-PRAWO
  MapNode(
    id: 'right_bottom',
    title: 'Lorem R-Bot',
    x: 260,
    y: 80,
    requiredParentId: 'right_1', // Odblokuje się, gdy 'right_1' zdobędzie brąz!
    flashcards: [Flashcard(front: 'Lorem ipsum?', back: 'Dolor sit amet.')],
    finalQuiz: QuizQuestion(question: 'Ipsum?', options: ['A', 'B'], correctAnswerIndex: 1),
  ),
];