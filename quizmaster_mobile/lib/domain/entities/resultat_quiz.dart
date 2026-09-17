class ResultatQuiz {
  const ResultatQuiz({
    required this.quizId,
    required this.joueur,
    required this.score,
    required this.date,
  });

  final String quizId;
  final String joueur;
  final int score;
  final DateTime date;

  factory ResultatQuiz.fromJson(Map<String, dynamic> json) {
    final dateString = (json['date'] ?? '').toString();

    return ResultatQuiz(
      quizId: (json['quizId'] ?? '').toString(),
      joueur: (json['joueur'] ?? '').toString(),
      score: (json['score'] as num? ?? 0).toInt(),
      date: DateTime.tryParse(dateString) ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'quizId': quizId,
      'joueur': joueur,
      'score': score,
      'date': date.toUtc().toIso8601String(),
    };
  }

  ResultatQuiz copyWith({
    String? quizId,
    String? joueur,
    int? score,
    DateTime? date,
  }) {
    return ResultatQuiz(
      quizId: quizId ?? this.quizId,
      joueur: joueur ?? this.joueur,
      score: score ?? this.score,
      date: date ?? this.date,
    );
  }
}
