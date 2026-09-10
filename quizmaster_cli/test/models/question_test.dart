import 'package:test/test.dart';
import 'package:quizmaster_cli/models/question.dart';

void main() {
  group('Question', () {
    test('fromJson cree correctement une Question a partir d une Map', () {
      final json = {
        'id': 'q001-01',
        'enonce': 'Quelle est la capitale du Togo ?',
        'type': 'qcm',
        'options': ['Lome', 'Kara', 'Sokode', 'Atakpame'],
        'bonneReponseIndex': 0,
        'points': 10,
      };

      final question = Question.fromJson(json);

      expect(question.id, 'q001-01');
      expect(question.options.length, 4);
      expect(question.bonneReponseIndex, 0);
      expect(question.points, 10);
    });

    test('un aller-retour fromJson -> toJson ne perd aucune donnee', () {
      final original = {
        'id': 'q002',
        'enonce': 'Vrai ou faux ?',
        'type': 'qcm',
        'options': ['Vrai', 'Faux'],
        'bonneReponseIndex': 0,
        'points': 5,
      };

      final question = Question.fromJson(original);
      final regenere = question.toJson();

      expect(regenere, original);
    });

    test(
      'estCorrecte retourne true si index correspond a la bonne reponse',
      () {
        final question = Question(
          id: 'q001',
          enonce: 'Test',
          type: 'qcm',
          options: ['A', 'B', 'C'],
          bonneReponseIndex: 2,
          points: 10,
        );

        expect(question.estCorrecte(2), true);
        expect(question.estCorrecte(0), false);
      },
    );
  });
}
