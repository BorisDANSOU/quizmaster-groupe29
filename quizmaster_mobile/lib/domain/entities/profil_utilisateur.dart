class HistoriqueQuiz {
  const HistoriqueQuiz({
    required this.quizId,
    required this.titre,
    required this.score,
    required this.date,
    this.totalQuestions = 0,
  });

  final String quizId;
  final String titre;
  final int score;
  final DateTime date;
  final int totalQuestions;

  factory HistoriqueQuiz.fromJson(Map<String, dynamic> json) {
    return HistoriqueQuiz(
      quizId: (json['quizId'] ?? '').toString(),
      titre: (json['titre'] ?? '').toString(),
      score: (json['score'] as num? ?? 0).toInt(),
      date:
          DateTime.tryParse((json['date'] ?? '').toString()) ?? DateTime.now(),
      totalQuestions: (json['totalQuestions'] as num? ?? 0).toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'quizId': quizId,
      'titre': titre,
      'score': score,
      'date': date.toIso8601String(),
      'totalQuestions': totalQuestions,
    };
  }
}

class ProfilUtilisateur {
  const ProfilUtilisateur({
    required this.uid,
    required this.nom,
    required this.email,
    required this.quizJoues,
    this.totalPoints = 0,
    required this.meilleureSerie,
    required this.tauxReussite,
    required this.historique,
  });

  final String uid;
  final String nom;
  final String email;
  final int quizJoues;
  final int totalPoints;
  final int meilleureSerie;
  final int tauxReussite;
  final List<HistoriqueQuiz> historique;

  factory ProfilUtilisateur.fromJson(Map<String, dynamic> json) {
    final historique = (json['historique'] as List? ?? const <dynamic>[])
        .map(
          (entry) =>
              HistoriqueQuiz.fromJson(Map<String, dynamic>.from(entry as Map)),
        )
        .toList();

    return ProfilUtilisateur(
      uid: (json['uid'] ?? '').toString(),
      nom: (json['nom'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      quizJoues: (json['quizJoues'] as num? ?? 0).toInt(),
      totalPoints: (json['totalPoints'] as num? ?? 0).toInt(),
      meilleureSerie: (json['meilleureSerie'] as num? ?? 0).toInt(),
      tauxReussite: (json['tauxReussite'] as num? ?? 0).toInt(),
      historique: historique,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'nom': nom,
      'email': email,
      'quizJoues': quizJoues,
      'totalPoints': totalPoints,
      'meilleureSerie': meilleureSerie,
      'tauxReussite': tauxReussite,
      'historique': historique.map((entry) => entry.toJson()).toList(),
    };
  }

  ProfilUtilisateur copyWith({
    String? uid,
    String? nom,
    String? email,
    int? quizJoues,
    int? totalPoints,
    int? meilleureSerie,
    int? tauxReussite,
    List<HistoriqueQuiz>? historique,
  }) {
    return ProfilUtilisateur(
      uid: uid ?? this.uid,
      nom: nom ?? this.nom,
      email: email ?? this.email,
      quizJoues: quizJoues ?? this.quizJoues,
      totalPoints: totalPoints ?? this.totalPoints,
      meilleureSerie: meilleureSerie ?? this.meilleureSerie,
      tauxReussite: tauxReussite ?? this.tauxReussite,
      historique: historique ?? this.historique,
    );
  }
}
