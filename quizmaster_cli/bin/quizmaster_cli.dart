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
        supprimerQuiz();
        break;
      case '5':
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
  print('4. Supprimer un quiz');
  print('5. Quitter');
  stdout.write('Ton choix : ');
}

/// Guide pas a pas pour creer un quiz complet
void creerQuiz(JsonService jsonService) {
  print('\n--- Creation d\'un nouveau quiz ---');

  String quizId = '';
  while (quizId.isEmpty || File('data/$quizId.json').existsSync()) {
    stdout.write('ID du quiz (ex: q001) : ');
    quizId = stdin.readLineSync() ?? '';

    if (quizId.isEmpty) {
      print('L\'ID ne peut pas etre vide.');
    } else if (File('data/$quizId.json').existsSync()) {
      print('Un quiz avec cet ID existe deja, choisis-en un autre.');
      quizId = ''; // force une nouvelle saisie
    }
  }

  stdout.write('Titre du quiz : ');
  final titre = stdin.readLineSync() ?? '';

  stdout.write('Categorie (ex: Education) : ');
  final categorie = stdin.readLineSync() ?? '';

  // Difficulte : uniquement une des 3 valeurs autorisees
  const difficultesValides = ['facile', 'moyen', 'difficile'];
  String difficulte = '';
  while (!difficultesValides.contains(difficulte)) {
    stdout.write('Difficulte (facile/moyen/difficile) : ');
    difficulte = (stdin.readLineSync() ?? '').toLowerCase();

    if (!difficultesValides.contains(difficulte)) {
      print('Valeur invalide, choisis parmi : facile, moyen, difficile.');
    }
  }

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
  final categorie = nouvelleCategorie.isNotEmpty
      ? nouvelleCategorie
      : quizActuel.categorie;
  final difficulte = nouvelleDifficulte.isNotEmpty
      ? nouvelleDifficulte
      : quizActuel.difficulte;

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

/// Supprime le fichier JSON d'un quiz, apres confirmation de l'utilisateur.
void supprimerQuiz() {
  stdout.write('\nID du quiz a supprimer (ex: q001) : ');
  final quizId = stdin.readLineSync() ?? '';
  final cheminFichier = 'data/$quizId.json';
  final fichier = File(cheminFichier);

  if (!fichier.existsSync()) {
    print('Aucun quiz trouve avec cet ID ($cheminFichier).');
    return;
  }

  stdout.write('Es-tu sur de vouloir supprimer "$quizId" ? (o/n) : ');
  final confirmation = stdin.readLineSync()?.toLowerCase();

  if (confirmation == 'o') {
    fichier.deleteSync();
    print('Quiz supprime avec succes.');
  } else {
    print('Suppression annulee.');
  }
}
