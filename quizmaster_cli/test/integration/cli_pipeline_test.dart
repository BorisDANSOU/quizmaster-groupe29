import 'dart:io';
import 'package:test/test.dart';
import 'package:quizmaster_cli/models/quiz.dart';
import 'package:quizmaster_cli/models/question.dart';
import 'package:quizmaster_cli/services/json_service.dart';
import 'package:quizmaster_cli/quizmaster_cli.dart' show listerCheminsQuiz;

/// Test d'integration : verifie que les differentes briques du CLI
/// (models, JsonService, listing) fonctionnent correctement ENSEMBLE,
/// contrairement aux tests unitaires qui testent chaque piece isolement.
void main() {
  group('Pipeline CLI complet', () {
    final dossierTemp = 'test/temp_integration';
    final service = JsonService();

    setUp(() {
      Directory(dossierTemp).createSync(recursive: true);
    });

    tearDown(() {
      final dossier = Directory(dossierTemp);
      if (dossier.existsSync()) {
        dossier.deleteSync(recursive: true);
      }
    });

    test('un quiz cree, ecrit puis relu conserve toutes ses donnees', () {
      // 1. Simule la creation d'un quiz (comme le ferait creerQuiz())
      final quizOriginal = Quiz(
        quizId: 'q_test',
        titre: 'Quiz Integration',
        categorie: 'Test',
        difficulte: 'moyen',
        questions: [
          Question(
            id: 'q_test-01',
            enonce: 'Question 1 ?',
            type: 'qcm',
            options: ['A', 'B', 'C'],
            bonneReponseIndex: 1,
            points: 10,
          ),
          Question(
            id: 'q_test-02',
            enonce: 'Question 2 ?',
            type: 'qcm',
            options: ['Vrai', 'Faux'],
            bonneReponseIndex: 0,
            points: 5,
          ),
        ],
      );

      // 2. Ecrit le quiz sur le disque (comme le fait JsonService dans le CLI)
      final chemin = '$dossierTemp/q_test.json';
      service.ecrireQuiz(quizOriginal, chemin);

      // 3. Relit le quiz depuis le disque
      final quizRelu = service.lireQuiz(chemin);

      // 4. Verifie qu'aucune donnee n'a ete perdue ou alteree
      expect(quizRelu.quizId, quizOriginal.quizId);
      expect(quizRelu.titre, quizOriginal.titre);
      expect(quizRelu.difficulte, quizOriginal.difficulte);
      expect(quizRelu.questions.length, 2);
      expect(quizRelu.questions[0].enonce, 'Question 1 ?');
      expect(quizRelu.questions[1].bonneReponseIndex, 0);
      expect(quizRelu.scoreMax, 15);
    });

    test('un quiz modifie (question ajoutee) est bien persiste', () {
      final quizInitial = Quiz(
        quizId: 'q_test2',
        titre: 'Quiz a modifier',
        categorie: 'Test',
        difficulte: 'facile',
        questions: [
          Question(
            id: 'q_test2-01',
            enonce: 'Premiere question',
            type: 'qcm',
            options: ['Oui', 'Non'],
            bonneReponseIndex: 0,
            points: 10,
          ),
        ],
      );

      final chemin = '$dossierTemp/q_test2.json';
      service.ecrireQuiz(quizInitial, chemin);

      // Relit, ajoute une question, ecrit de nouveau (= ce que fait modifierQuiz)
      final quizLu = service.lireQuiz(chemin);
      final questionsModifiees = List<Question>.from(quizLu.questions)
        ..add(
          Question(
            id: 'q_test2-02',
            enonce: 'Deuxieme question ajoutee',
            type: 'qcm',
            options: ['A', 'B'],
            bonneReponseIndex: 1,
            points: 5,
          ),
        );

      final quizModifie = Quiz(
        quizId: quizLu.quizId,
        titre: quizLu.titre,
        categorie: quizLu.categorie,
        difficulte: quizLu.difficulte,
        questions: questionsModifiees,
      );

      service.ecrireQuiz(quizModifie, chemin);

      // Verifie que le fichier contient bien les 2 questions apres re-lecture
      final quizFinal = service.lireQuiz(chemin);
      expect(quizFinal.questions.length, 2);
      expect(quizFinal.questions[1].id, 'q_test2-02');
    });

    test('listerCheminsQuiz retrouve bien tous les fichiers crees', () {
      // Cree 2 quiz differents dans le dossier temporaire
      service.ecrireQuiz(
        Quiz(
          quizId: 'q_a',
          titre: 'Quiz A',
          categorie: 'Test',
          difficulte: 'facile',
          questions: [],
        ),
        '$dossierTemp/q_a.json',
      );
      service.ecrireQuiz(
        Quiz(
          quizId: 'q_b',
          titre: 'Quiz B',
          categorie: 'Test',
          difficulte: 'facile',
          questions: [],
        ),
        '$dossierTemp/q_b.json',
      );

      final chemins = listerCheminsQuiz(dossierTemp);

      expect(chemins.length, 2);
      expect(chemins.any((c) => c.contains('q_a.json')), true);
      expect(chemins.any((c) => c.contains('q_b.json')), true);
    });
  });
}
