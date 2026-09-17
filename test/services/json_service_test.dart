import 'dart:io';

import 'package:test/test.dart';

import '../../quizmaster_cli/lib/models/quiz.dart';
import '../../quizmaster_cli/lib/models/question.dart';
import '../../quizmaster_cli/lib/services/json_service.dart';

void main() {
  group('JsonService', () {
    // Fichier temporaire utilise uniquement pour les tests,
    final cheminTest = 'test/temp/quiz_test.json';
    final service = JsonService();

    tearDown(() {
      final fichier = File(cheminTest);
      if (fichier.existsSync()) {
        fichier.deleteSync();
      }
    });

    test('ecrireQuiz puis lireQuiz redonne le meme quiz', () {
      final quiz = Quiz(
        quizId: 'q001',
        titre: 'Test Quiz',
        categorie: 'Education',
        difficulte: 'facile',
        questions: [
          Question(
            id: 'q001-01',
            enonce: 'Question test',
            type: 'qcm',
            options: ['A', 'B'],
            bonneReponseIndex: 0,
            points: 10,
          ),
        ],
      );

      service.ecrireQuiz(quiz, cheminTest);
      final quizLu = service.lireQuiz(cheminTest);

      expect(quizLu.quizId, quiz.quizId);
      expect(quizLu.questions.length, 1);
      expect(quizLu.questions[0].enonce, 'Question test');
    });

    test('lireQuiz lance une exception si le fichier n existe pas', () {
      expect(
        () => service.lireQuiz('fichier_qui_n_existe_pas.json'),
        throwsException,
      );
    });

    test(
      'lireListeQuiz retourne une liste vide si le fichier n existe pas',
      () {
        final resultat = service.lireListeQuiz('fichier_inexistant.json');
        expect(resultat, isEmpty);
      },
    );
  });
}
