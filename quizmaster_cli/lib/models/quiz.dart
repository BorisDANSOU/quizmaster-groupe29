import 'question.dart';

/// Représente un quiz complet : métadonnées + liste de questions.
class Quiz {
  final String quizId;
  final String titre;
  final String categorie;
  final String difficulte;
  final List<Question> questions;

  Quiz({
    required this.quizId,
    required this.titre,
    required this.categorie,
    required this.difficulte,
    required this.questions,
  });

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      quizId: json['quizId'] as String,
      titre: json['titre'] as String,
      categorie: json['categorie'] as String,
      difficulte: json['difficulte'] as String,
      questions: (json['questions'] as List)
          .map((q) => Question.fromJson(q as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'quizId': quizId,
      'titre': titre,
      'categorie': categorie,
      'difficulte': difficulte,
      'questions': questions.map((q) => q.toJson()).toList(),
    };
  }

  int get scoreMax => questions.fold(0, (total, q) => total + q.points);
}
