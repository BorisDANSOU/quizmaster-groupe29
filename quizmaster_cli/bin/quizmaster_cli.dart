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
        listerQuiz();
        break;
      case '3':
        modifierQuiz(jsonService);
        break;
      case '4':
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
  print('2. Lister les quiz existants');
  print('3. Modifier un quiz existant');
  print('4. Quitter');
  stdout.write('Ton choix : ');
}

/// Guide pas a pas pour creer un quiz complet
void creerQuiz(JsonService jsonService) {
  print('\n--- Creation d\'un nouveau quiz ---');

  stdout.write('ID du quiz (ex: q001) : ');
  final quizId = stdin.readLineSync() ?? '';

  stdout.write('Titre du quiz : ');
  final titre = stdin.readLineSync() ?? '';

  stdout.write('Categorie (ex: Education / Santé) : ');
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

/// Permet de modifier un quiz existant : changer ses metadonnees
/// et/ou lui ajouter de nouvelles questions.
void modifierQuiz(JsonService jsonService) {
  stdout.write('\nID du quiz a modifier (ex: q001) : ');
  final quizId = stdin.readLineSync() ?? '';
  final cheminFichier = 'data/$quizId.json';

  if (!File(cheminFichier).existsSync()) {
    print('Aucun quiz trouve avec cet ID ($cheminFichier).');
    return;
  }

  final quizActuel = jsonService.lireQuiz(cheminFichier);

  print('\n--- Modification de "${quizActuel.titre}" ---');
  print('(laisse vide pour ne pas changer une valeur)');

  stdout.write('Nouveau titre [${quizActuel.titre}] : ');
  final nouveauTitre = stdin.readLineSync() ?? '';

  stdout.write('Nouvelle categorie [${quizActuel.categorie}] : ');
  final nouvelleCategorie = stdin.readLineSync() ?? '';

  stdout.write('Nouvelle difficulte [${quizActuel.difficulte}] : ');
  final nouvelleDifficulte = stdin.readLineSync() ?? '';

  // On garde l'ancienne valeur si l'utilisateur n'a rien tape
  final titre = nouveauTitre.isNotEmpty ? nouveauTitre : quizActuel.titre;
  final categorie =
      nouvelleCategorie.isNotEmpty ? nouvelleCategorie : quizActuel.categorie;
  final difficulte =
      nouvelleDifficulte.isNotEmpty ? nouvelleDifficulte : quizActuel.difficulte;

  final questions = List<Question>.from(quizActuel.questions);

  stdout.write('\nAjouter une nouvelle question ? (o/n) : ');
  bool ajouterQuestion = stdin.readLineSync()?.toLowerCase() == 'o';

  while (ajouterQuestion) {
    questions.add(creerQuestion(questions.length + 1, quizId));

    stdout.write('\nAjouter une autre question ? (o/n) : ');
    ajouterQuestion = stdin.readLineSync()?.toLowerCase() == 'o';
  }

  final quizModifie = Quiz(
    quizId: quizId,
    titre: titre,
    categorie: categorie,
    difficulte: difficulte,
    questions: questions,
  );

  jsonService.ecrireQuiz(quizModifie, cheminFichier);
  print('\nQuiz modifie et sauvegarde avec succes.');
}

/// Retourne la liste des chemins de fichiers de quiz presents dans un dossier.
List<String> listerCheminsQuiz(String cheminDossier) {
  final dossier = Directory(cheminDossier);

  if (!dossier.existsSync()) {
    return [];
  }

  return dossier
      .listSync()
      .whereType<File>()
      .where((f) => f.path.endsWith('.json'))
      .map((f) => f.path)
      .toList();
}

/// Affiche a l'ecran la liste des quiz existants dans data/.
void listerQuiz() {
  final chemins = listerCheminsQuiz('data');

  if (chemins.isEmpty) {
    print('\nAucun quiz trouve.');
    return;
  }

  print('\n--- Quiz existants ---');
  for (final chemin in chemins) {
    print('- $chemin');
  }
}