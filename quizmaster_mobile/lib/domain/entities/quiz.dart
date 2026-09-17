import 'question.dart';

class Quiz {
  const Quiz({
    required this.quizId,
    required this.titre,
    required this.categorie,
    required this.difficulte,
    required this.questions,
  });

  final String quizId;
  final String titre;
  final String categorie;
  final String difficulte;
  final List<Question> questions;

  factory Quiz.fromJson(Map<String, dynamic> json) {
    final questions = (json['questions'] as List? ?? const <dynamic>[])
        .map(
          (entry) => Question.fromJson(Map<String, dynamic>.from(entry as Map)),
        )
        .toList();

    return Quiz(
      quizId: (json['quizId'] ?? '').toString(),
      titre: (json['titre'] ?? '').toString(),
      categorie: (json['categorie'] ?? '').toString(),
      difficulte: (json['difficulte'] ?? 'facile').toString(),
      questions: questions,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'quizId': quizId,
      'titre': titre,
      'categorie': categorie,
      'difficulte': difficulte,
      'questions': questions.map((question) => question.toJson()).toList(),
    };
  }

  Quiz copyWith({
    String? quizId,
    String? titre,
    String? categorie,
    String? difficulte,
    List<Question>? questions,
  }) {
    return Quiz(
      quizId: quizId ?? this.quizId,
      titre: titre ?? this.titre,
      categorie: categorie ?? this.categorie,
      difficulte: difficulte ?? this.difficulte,
      questions: questions ?? this.questions,
    );
  }
}
