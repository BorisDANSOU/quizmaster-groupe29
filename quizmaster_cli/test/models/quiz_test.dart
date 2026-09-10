import 'package:test/test.dart';
import 'package:quizmaster_cli/models/quiz.dart';

void main() {
  group('Quiz', () {
    final jsonExemple = {
      'quizId': 'q001',
      'titre': 'Culture Generale',
      'categorie': 'Education',
      'difficulte': 'facile',
      'questions': [
        {
          'id': 'q001-01',
          'enonce': 'Question 1',
          'type': 'qcm',
          'options': ['A', 'B'],
          'bonneReponseIndex': 0,
          'points': 10,
        },
        {
          'id': 'q001-02',
          'enonce': 'Question 2',
          'type': 'qcm',
          'options': ['A', 'B', 'C'],
          'bonneReponseIndex': 1,
          'points': 5,
        },
      ],
    };

    test('fromJson charge correctement un quiz avec ses questions', () {
      final quiz = Quiz.fromJson(jsonExemple);

      expect(quiz.quizId, 'q001');
      expect(quiz.difficulte, 'facile');
      expect(quiz.questions.length, 2);
    });

    test('scoreMax calcule bien la somme des points', () {
      final quiz = Quiz.fromJson(jsonExemple);

      expect(quiz.scoreMax, 15); // 10 + 5
    });

    test('toJson reconvertit correctement le quiz complet', () {
      final quiz = Quiz.fromJson(jsonExemple);
      final regenere = quiz.toJson();

      expect(regenere, jsonExemple);
    });
  });
}
