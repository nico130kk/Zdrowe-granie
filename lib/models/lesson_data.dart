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
  final double x;
  final double y;
  final String? requiredParentId;
  
  // 🔥 TE POLA WRACAJĄ, żeby naprawić błędy!
  // UWAGA: Jeśli miałeś tu wcześniej konkretne klasy (np. List<Flashcard> lub Quiz),
  // podmień słówko 'dynamic' na swoje stare nazwy.
  final List<dynamic> flashcards;
  final dynamic finalQuiz;

  const MapNode({
    required this.id,
    required this.title,
    required this.x,
    required this.y,
    this.requiredParentId,
    // Domyślnie ustawiamy puste wartości, bo i tak docelowo wepniemy tu JSON-a!
    this.flashcards = const [], 
    this.finalQuiz,
  });
}

// Nasza nowa mapa ułożona dokładnie według Twojego odręcznego szkicu!
const List<MapNode> appNodes = [
  // GŁÓWNY WĘZEŁ (Odblokowany na start)
  MapNode(id: 'dieta', title: 'Dieta', x: -50, y: 150, requiredParentId: null),
  
  // ODNOGI OD DIETY
  MapNode(id: 'warzywa_owoce', title: 'Warzywa\ni Owoce', x: -220, y: 50, requiredParentId: 'dieta'),
  MapNode(id: 'produkty_zbozowe', title: 'Zbożowe', x: -160, y: -80, requiredParentId: 'dieta'),
  MapNode(id: 'tluszcze', title: 'Tłuszcze', x: 80, y: 250, requiredParentId: 'dieta'),
  
  // BIAŁKO (Hub centralny odblokowywany przez Dietę)
  MapNode(id: 'bialko', title: 'Białko', x: 80, y: 0, requiredParentId: 'dieta'),
  
  // ODNOGI OD BIAŁKA
  MapNode(id: 'mieso', title: 'Mięso', x: -60, y: -160, requiredParentId: 'bialko'),
  MapNode(id: 'ryby', title: 'Ryby', x: 40, y: -220, requiredParentId: 'bialko'),
  MapNode(id: 'jaja', title: 'Jaja', x: 150, y: -200, requiredParentId: 'bialko'),
  MapNode(id: 'mleko_nabial', title: 'Nabiał', x: 240, y: -120, requiredParentId: 'bialko'),
  MapNode(id: 'orzechy', title: 'Orzechy', x: 270, y: -10, requiredParentId: 'bialko'),
  MapNode(id: 'straczkowe', title: 'Strączki', x: 220, y: 100, requiredParentId: 'bialko'),
];