class Flashcard {
  final String front;
  final String back;

  const Flashcard({required this.front, required this.back});
}

class QuizQuestion {
  final String question;
  final List<String> options;
  final int correctAnswerIndex;

  const QuizQuestion({
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
  });
}

class Lesson {
  final String id;
  final String title;
  final String unlocksChallengeId; // Jakie wyzwanie odblokuje ta lekcja (np. 'sol_braz')
  final String? requiredChallengeId; // Jakie wyzwanie trzeba ukończyć, by odblokować tę lekcję (np. 'sol_braz')
  final int requiredChallengeLevel; // Ile punktów musi mieć to wyzwanie (u nas 6 dni dla brązu)
  final List<Flashcard> flashcards;
  final QuizQuestion finalQuiz;

  const Lesson({
    required this.id,
    required this.title,
    required this.unlocksChallengeId,
    this.requiredChallengeId,
    this.requiredChallengeLevel = 6, // Domyślnie wymaga brązu (6 dni)
    required this.flashcards,
    required this.finalQuiz,
  });
}

// BAZA WIEDZY - TU W PRZYSZŁOŚCI DODAJESZ NOWE TEMATY
const List<Lesson> appLessons = [
  // ==================== LEKCJA 1: SÓL ====================
  Lesson(
    id: 'lesson_1',
    title: 'Sól w diecie',
    unlocksChallengeId: 'sol_braz',
    requiredChallengeId: null, // Pierwsza lekcja, zawsze odblokowana
    flashcards: [
      Flashcard(
        front: 'Czym jest sól i jaka jest jej rola w organizmie?',
        back: 'Sól (NaCl) odpowiada m.in. za regulację gospodarki wodno-elektrolitowej oraz wchłanianie składników odżywczych w jelitach.',
      ),
      Flashcard(
        front: 'Jakie jest zalecane dzienne spożycie soli?',
        back: 'WHO zaleca spożywanie do 5 gramów na dzień. Sportowcy mogą potrzebować jej więcej ze względu na utratę z potem.',
      ),
      Flashcard(
        front: 'Czym grozi nadmiar soli?',
        back: 'Może skutkować nadciśnieniem tętniczym, chorobami sercowo-naczyniowymi, chorobami nerek oraz zatrzymywaniem wody (obrzękami).',
      ),
      Flashcard(
        front: 'Gdzie ukrywa się najwięcej soli?',
        back: 'W pieczywie, wędlinach, serach, daniach instant, fast foodach, chipsach, sosach i konserwach.',
      ),
      Flashcard(
        front: 'Mit czy Fakt: Sól himalajska (różowa) jest dużo zdrowsza.',
        back: 'Mit. Niezależnie od rodzaju, to głównie NaCl. Różnice mineralne są tak minimalne, że nie mają dużego znaczenia zdrowotnego.',
      ),
    ],
    finalQuiz: QuizQuestion(
      question: 'Zgodnie z wytycznymi WHO, ile wynosi maksymalne zalecane dzienne spożycie soli dla zdrowej osoby dorosłej?',
      options: ['2 gramy', '5 gramów', '10 gramów', '15 gramów'],
      correctAnswerIndex: 1, // Odpowiedź: 5 gramów
    ),
  ),

  // ==================== LEKCJA 2: ZBOŻA ====================
  Lesson(
    id: 'lesson_2',
    title: 'Produkty Zbożowe',
    unlocksChallengeId: 'zboza_braz',
    requiredChallengeId: 'sol_braz', // Wymaga ukończenia wyzwania z Soli
    flashcards: [
      Flashcard(
        front: 'Rola produktów zbożowych',
        back: 'Są podstawą żywienia i głównym źródłem energii. Kluczowe jest jednak wybieranie odpowiedniego rodzaju zbóż i stopnia ich przetworzenia.',
      ),
      Flashcard(
        front: 'Co kryje w sobie pełne ziarno?',
        back: 'To kopalnia błonnika, węglowodanów złożonych, witamin (głównie z grupy B) oraz minerałów (magnez, cynk, żelazo). Najwięcej dobrych składników jest tuż pod okrywą!',
      ),
      Flashcard(
        front: 'Pełnoziarniste vs Przetworzone',
        back: 'Pełnoziarniste powstają z całego ziarna (łuska + zarodek + bielmo). Przetworzone (rafinowane) tylko z bielma, przez co tracą większość wartości odżywczych.',
      ),
      Flashcard(
        front: 'Co kupować, a czego unikać?',
        back: 'KUPUJ: chleb razowy, makaron pełnoziarnisty, brązowy ryż, kaszę gryczaną/jęczmienną. \nUNIKAJ: białego pieczywa, jasnych makaronów, płatków kukurydzianych.',
      ),
      Flashcard(
        front: 'Uwaga na sklepową pułapkę!',
        back: 'Czy wiesz, że ciemne pieczywo w sklepie czasami jest sztucznie barwione karmelem, aby wyglądało na "zdrowe" i pełnoziarniste? Zawsze czytaj skład!',
      ),
    ],
    finalQuiz: QuizQuestion(
      question: 'Który z poniższych produktów jest produktem przetworzonym (rafinowanym), którego lepiej unikać?',
      options: ['Kasza gryczana', 'Płatki owsiane', 'Brązowy ryż', 'Płatki kukurydziane'],
      correctAnswerIndex: 3,
    ),
  ),

  // ==================== LEKCJA 3: WARZYWA I OWOCE ====================
  Lesson(
    id: 'lesson_3',
    title: 'Warzywa i Owoce',
    unlocksChallengeId: 'warzywa_braz',
    requiredChallengeId: 'zboza_braz', // Wymaga ukończenia wyzwania ze Zbóż
    flashcards: [
      Flashcard(
        front: 'Dlaczego są tak ważne?',
        back: 'Dostarczają witamin (C, K, z grupy B), składników mineralnych, błonnika i antyoksydantów. Chronią przed chorobami cywilizacyjnymi (np. udar, nowotwory).',
      ),
      Flashcard(
        front: 'Co jest ważniejsze: warzywa czy owoce?',
        back: 'Zdecydowanie warzywa! Mają mniej cukru, kalorii i dużo błonnika. Owoce to świetne źródło energii, ale przez fruktozę powinniśmy jeść ich mniej niż warzyw.',
      ),
      Flashcard(
        front: 'Jaka jest zalecana dzienna porcja?',
        back: 'Zaleca się spożywanie minimum 400 g warzyw i owoców dziennie, najlepiej dodając je do każdego posiłku.',
      ),
      Flashcard(
        front: 'Czy sok owocowy to to samo co owoc?',
        back: 'Tylko częściowo. Szklanka soku 100% ma witaminy, ale prawie nie ma błonnika. Przez to nie daje uczucia sytości i szybko podnosi cukier we krwi.',
      ),
      Flashcard(
        front: 'Jakich napojów unikać?',
        back: 'Uważaj na "nektary" i "napoje o smaku owocowym". Zazwyczaj zawierają śladowe ilości owoców, za to są nafaszerowane dodanym cukrem.',
      ),
    ],
    finalQuiz: QuizQuestion(
      question: 'Dlaczego warzywa powinny być spożywane częściej niż owoce?',
      options: ['Szybciej się trawią', 'Zawierają mniej witaminy C', 'Mają mniej kalorii i naturalnych cukrów', 'Mają mniejszą objętość'],
      correctAnswerIndex: 2,
    ),
  ),
];