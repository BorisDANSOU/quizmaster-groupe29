import 'dart:io';
import 'package:quizmaster_cli/models/quiz.dart';
import 'package:quizmaster_cli/models/question.dart';
import 'package:quizmaster_cli/services/json_service.dart';

/// Point d'entree du CLI QuizMaster.
void main() {
  final jsonService = JsonService();
  bool continuer = true;

  print('=== QuizMaster CLI - Createur de quiz ===');

  while (continuer) {
    afficherMenu();
    final choix = stdin.readLineSync();

    switch (choix) {
      case '1':
        creerQuiz(jsonService);
        break;
      case '2':
        continuer = false;
        print('A bientot !');
        break;
      default:
        print('Choix invalide, reessaie.\n');
    }
  }
}

/// Affiche les options disponibles du menu principal.
void afficherMenu() {
  print('\n--- Menu ---');
  print('1. Creer un nouveau quiz');
  print('2. Quitter');
  stdout.write('Ton choix : ');
}

/// Guide pas a pas pour creer un quiz complet
void creerQuiz(JsonService jsonService) {
  print('\n--- Creation d\'un nouveau quiz ---');

  stdout.write('ID du quiz (ex: q001) : ');
  final quizId = stdin.readLineSync() ?? '';

  stdout.write('Titre du quiz : ');
  final titre = stdin.readLineSync() ?? '';

  stdout.write('Categorie (ex: Education) : ');
  final categorie = stdin.readLineSync() ?? '';

  stdout.write('Difficulte (facile/moyen/difficile) : ');
  final difficulte = stdin.readLineSync() ?? 'facile';

  final questions = <Question>[];
  bool ajouterAutreQuestion = true;

  while (ajouterAutreQuestion) {
    questions.add(creerQuestion(questions.length + 1, quizId));

    stdout.write('\nAjouter une autre question ? (o/n) : ');
    final reponse = stdin.readLineSync()?.toLowerCase();
    ajouterAutreQuestion = reponse == 'o';
  }

  final quiz = Quiz(
    quizId: quizId,
    titre: titre,
    categorie: categorie,
    difficulte: difficulte,
    questions: questions,
  );

  final cheminFichier = 'data/$quizId.json';
  jsonService.ecrireQuiz(quiz, cheminFichier);

  print('\nQuiz sauvegarde avec succes dans : $cheminFichier');
}

/// Guide pour creer une seule question QCM.
Question creerQuestion(int numero, String quizId) {
  print('\n-- Question $numero --');

  stdout.write('Enonce de la question : ');
  final enonce = stdin.readLineSync() ?? '';

  final options = <String>[];
  print('Entre les options (laisse vide pour arreter, minimum 2) :');

  int numeroOption = 1;
  while (true) {
    stdout.write('Option $numeroOption : ');
    final option = stdin.readLineSync() ?? '';

    if (option.isEmpty) {
      if (options.length < 2) {
        print('Il faut au moins 2 options, continue.');
        continue;
      }
      break;
    }

    options.add(option);
    numeroOption++;
  }

  int bonneReponseIndex = -1;
  while (bonneReponseIndex < 0 || bonneReponseIndex >= options.length) {
    stdout.write('Index de la bonne reponse (0 a ${options.length - 1}) : ');
    bonneReponseIndex = int.tryParse(stdin.readLineSync() ?? '') ?? -1;
  }

  stdout.write('Points pour cette question : ');
  final points = int.tryParse(stdin.readLineSync() ?? '') ?? 10;

  return Question(
    id: '$quizId-${numero.toString().padLeft(2, '0')}',
    enonce: enonce,
    type: 'qcm',
    options: options,
    bonneReponseIndex: bonneReponseIndex,
    points: points,
  );
}
