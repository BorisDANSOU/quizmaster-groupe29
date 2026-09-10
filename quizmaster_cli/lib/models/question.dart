/// Représente une question de quiz de type QCM.
class Question {
  final String id;
  final String enonce;
  final String type; // "qcm" 
  final List<String> options;
  final int bonneReponseIndex;
  final int points;

  Question({
    required this.id,
    required this.enonce,
    required this.type,
    required this.options,
    required this.bonneReponseIndex,
    required this.points,
  });

  /// Construit une Question à partir d'une Map JSON.
  /// Utilisé quand on lit un fichier quizzes.json.
  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] as String,
      enonce: json['enonce'] as String,
      type: json['type'] as String,
      options: List<String>.from(json['options'] as List),
      bonneReponseIndex: json['bonneReponseIndex'] as int,
      points: json['points'] as int,
    );
  }

  /// Pour convertir la Question en Map, prête à être encodée en JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'enonce': enonce,
      'type': type,
      'options': options,
      'bonneReponseIndex': bonneReponseIndex,
      'points': points,
    };
  }

  bool estCorrecte(int indexChoisi) => indexChoisi == bonneReponseIndex;
}