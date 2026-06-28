/// Defines data models for map nodes and the static layout of the entire lesson tree.
/// Hierarchy, names, and relationships are strictly mapped to the original project flowchart.

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
    required this.correctAnswerIndex
  });
}

class MapNode {
  final String id;
  final String title;
  final double x;
  final double y;
  final String? requiredParentId;
  final List<dynamic> flashcards;
  final dynamic finalQuiz;

  const MapNode({
    required this.id,
    required this.title,
    required this.x,
    required this.y,
    this.requiredParentId,
    this.flashcards = const [],
    this.finalQuiz,
  });
}

const List<MapNode> appNodes = [
  MapNode(id: 'start', title: 'Talerz\nzdrowego żywienia', x: -180, y: 0, requiredParentId: null),
  MapNode(id: 'dieta', title: 'Dieta', x: 0, y: 0, requiredParentId: 'start'),
  
  MapNode(id: 'skladniki', title: 'Składniki\nzdrowej diety', x: 0, y: 140, requiredParentId: 'dieta'),
  MapNode(id: 'nawyki', title: 'Zdrowe nawyki\nżywieniowe', x: 0, y: -140, requiredParentId: 'dieta'),

  MapNode(id: 'warzywa_owoce', title: 'Warzywa i\nOwoce', x: -330, y: 260, requiredParentId: 'skladniki'),
  MapNode(id: 'witaminy', title: 'Witaminy', x: -330, y: 360, requiredParentId: 'warzywa_owoce'),

  MapNode(id: 'produkty_zbozowe', title: 'Produkty\nzbożowe', x: -220, y: 260, requiredParentId: 'skladniki'),
  MapNode(id: 'blonnik', title: 'Błonnik\npokarmowy', x: -220, y: 360, requiredParentId: 'produkty_zbozowe'),

  MapNode(id: 'mleko_nabial', title: 'Mleko i przetwory\nmleczne', x: -110, y: 260, requiredParentId: 'skladniki'),
  MapNode(id: 'bialko', title: 'Białko', x: -110, y: 360, requiredParentId: 'mleko_nabial'),

  MapNode(id: 'mieso', title: 'Mięso', x: 0, y: 260, requiredParentId: 'skladniki'),
  MapNode(id: 'ryby', title: 'Ryby', x: 0, y: 360, requiredParentId: 'mieso'),
  MapNode(id: 'jaja', title: 'Jajka', x: 0, y: 460, requiredParentId: 'ryby'),

  MapNode(id: 'straczkowe', title: 'Nasiona roślin\nstrączkowych', x: 110, y: 260, requiredParentId: 'skladniki'),
  MapNode(id: 'weglowodany', title: 'Węglowodany', x: 110, y: 360, requiredParentId: 'straczkowe'),

  MapNode(id: 'orzechy', title: 'Orzechy i\nnasiona', x: 220, y: 260, requiredParentId: 'skladniki'),
  MapNode(id: 'mineraly', title: 'Składniki\nmineralne', x: 220, y: 360, requiredParentId: 'orzechy'),

  MapNode(id: 'tluszcze', title: 'Tłuszcze', x: 330, y: 260, requiredParentId: 'skladniki'),

  MapNode(id: 'posilki_4_5', title: '4-5 posiłków\ndziennie', x: -250, y: -260, requiredParentId: 'nawyki'),
  MapNode(id: 'regularne_pory', title: 'Regularne pory\nposiłków', x: -250, y: -360, requiredParentId: 'posilki_4_5'),
  MapNode(id: 'dokladne_przezuwanie', title: 'Dokładne\nprzeżuwanie', x: -250, y: -460, requiredParentId: 'regularne_pory'),

  MapNode(id: 'woda_napoje', title: 'Picie wody/\nNapoje', x: -80, y: -260, requiredParentId: 'nawyki'),
  MapNode(id: 'unikanie_alkoholu', title: 'Unikanie\nalkoholu', x: -80, y: -360, requiredParentId: 'woda_napoje'),

  MapNode(id: 'owoce_zamiast_slodyczy', title: 'Owoce zamiast\nsłodyczy', x: 90, y: -260, requiredParentId: 'nawyki'),
  MapNode(id: 'jedzenie_warzyw', title: 'Jedzenie większej\nilości warzyw', x: 90, y: -360, requiredParentId: 'owoce_zamiast_slodyczy'),
  MapNode(id: 'ograniczenie_cukru', title: 'Ograniczenie cukru\noraz słodyczy', x: 90, y: -460, requiredParentId: 'jedzenie_warzyw'),

  MapNode(id: 'ograniczenie_soli', title: 'Ograniczenie\nsoli/sodu', x: 260, y: -260, requiredParentId: 'nawyki'),
  MapNode(id: 'unikanie_wysokoprzetworzonych', title: 'Unikanie produktów\nwysokoprzetworzonych', x: 260, y: -360, requiredParentId: 'ograniczenie_soli'),
];