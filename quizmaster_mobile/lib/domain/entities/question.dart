class Question {
  const Question({
    required this.id,
    required this.enonce,
    required this.type,
    required this.options,
    required this.bonneReponseIndex,
    required this.points,
  });

  final String id;
  final String enonce;
  final String type;
  final List<String> options;
  final int bonneReponseIndex;
  final int points;

  factory Question.fromJson(Map<String, dynamic> json) {
    final options = (json['options'] as List? ?? const <dynamic>[])
        .map((entry) => entry.toString())
        .toList();

    return Question(
      id: (json['id'] ?? '').toString(),
      enonce: (json['enonce'] ?? '').toString(),
      type: (json['type'] ?? 'qcm').toString(),
      options: options,
      bonneReponseIndex: (json['bonneReponseIndex'] as num? ?? 0).toInt(),
      points: (json['points'] as num? ?? 0).toInt(),
    );
  }

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

  Question copyWith({
    String? id,
    String? enonce,
    String? type,
    List<String>? options,
    int? bonneReponseIndex,
    int? points,
  }) {
    return Question(
      id: id ?? this.id,
      enonce: enonce ?? this.enonce,
      type: type ?? this.type,
      options: options ?? this.options,
      bonneReponseIndex: bonneReponseIndex ?? this.bonneReponseIndex,
      points: points ?? this.points,
    );
  }
}
