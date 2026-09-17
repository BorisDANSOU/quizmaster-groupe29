import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quizmaster_mobile/data/datasources/quiz_local_datasource.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const cheminAsset = 'assets/test_quizzes.json';

  const contenuJson = '''
  [
    {
      "quizId": "q_fixture",
      "titre": "Quiz de test",
      "categorie": "Education",
      "difficulte": "facile",
      "questions": [
        {
          "id": "q_fixture-01",
          "enonce": "2 + 2 = ?",
          "type": "qcm",
          "options": ["3", "4", "5"],
          "bonneReponseIndex": 1,
          "points": 10
        }
      ]
    },
    {
      "quizId": "q_fixture_2",
      "titre": "Autre quiz",
      "categorie": "Sante_Bien_Etre",
      "difficulte": "moyen",
      "questions": [
        {
          "id": "q_fixture_2-01",
          "enonce": "Question test 2 ?",
          "type": "qcm",
          "options": ["A", "B"],
          "bonneReponseIndex": 0,
          "points": 5
        }
      ]
    }
  ]
  ''';

  // Intercepte les demandes d'assets et repond avec notre JSON de test,
  // sans avoir besoin de declarer un vrai fichier dans pubspec.yaml.
  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMessageHandler('flutter/assets', (ByteData? message) async {
          final cle = utf8.decode(message!.buffer.asUint8List());
          if (cle == cheminAsset) {
            final bytes = utf8.encode(contenuJson);
            return ByteData.view(Uint8List.fromList(bytes).buffer);
          }
          return null; // simule un fichier inexistant pour tout autre chemin
        });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMessageHandler('flutter/assets', null);
  });

  group('QuizLocalDataSource', () {
    const dataSource = QuizLocalDataSource(assetPath: cheminAsset);

    test('loadQuizzes lit et parse correctement le fichier JSON', () async {
      final quizzes = await dataSource.loadQuizzes();

      expect(quizzes.length, 2);
      expect(quizzes[0].quizId, 'q_fixture');
      expect(quizzes[0].questions.length, 1);
      expect(quizzes[1].difficulte, 'moyen');
    });

    test('getQuizById retourne le bon quiz', () async {
      final quiz = await dataSource.getQuizById('q_fixture_2');

      expect(quiz, isNotNull);
      expect(quiz!.titre, 'Autre quiz');
    });

    test('getQuizById retourne null si l id n existe pas', () async {
      final quiz = await dataSource.getQuizById('id_inexistant');

      expect(quiz, isNull);
    });

    test('searchQuizzes filtre correctement par difficulte', () async {
      final resultats = await dataSource.searchQuizzes(difficulty: 'moyen');

      expect(resultats.length, 1);
      expect(resultats.first.quizId, 'q_fixture_2');
    });

    test('searchQuizzes filtre correctement par categorie', () async {
      final resultats = await dataSource.searchQuizzes(category: 'Education');

      expect(resultats.length, 1);
      expect(resultats.first.quizId, 'q_fixture');
    });
  });
}
