import 'dart:io';
import '../lib/models/quiz.dart';
import '../lib/models/question.dart';
import '../lib/services/json_service.dart';
import '../lib/services/firestore_service.dart';

/// Point d'entree du CLI QuizMaster.
Future<void> main() async {
  final jsonService = JsonService();
  bool continuer = true;

  print('=== QuizMaster CLI - Createur de quiz ===');

  while (continuer) {
    afficherMenu();
    final choix = stdin.readLineSync();

    switch (choix) {
      case '1':
        await creerQuiz(jsonService);
        break;
      case '2':
        listerQuiz();
        break;
      case '3':
        await modifierQuiz(jsonService);
        break;
      case '4':
        await supprimerQuiz();
        break;
      case '5':
        await publierQuiz();
        break;
      case '6':
        await telechargerQuizDepuisFirebase(jsonService);
        break;
      case '7':
        await publierTousLesQuizLocaux(jsonService);
        break;
      case '8':
        await testerConnexionFirebase();
        break;
      case '9':
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
  print('2. Lister les quiz locaux existants');
  print('3. Modifier un quiz local existant');
  print('4. Supprimer un quiz');
  print('5. Publier un quiz local specifique sur Firebase');
  print('6. Synchroniser / Telecharger un quiz depuis Firebase');
  print('7. Publier TOUS les quiz locaux en bloc (Bulk Upload)');
  print('8. Tester la connexion Firebase (Diagnostic)');
  print('9. Quitter');

  stdout.write('Ton choix : ');
}

/// Guide pas a pas pour creer un quiz complet
Future<void> creerQuiz(JsonService jsonService) async {
  print('\n--- Creation d\'un nouveau quiz ---');

  String quizId = '';
  final regExpId = RegExp(r'^[a-zA-Z0-9_\-]+$');
  while (quizId.isEmpty || File('data/$quizId.json').existsSync() || !regExpId.hasMatch(quizId)) {
    stdout.write('ID du quiz (ex: q001) : ');
    quizId = stdin.readLineSync() ?? '';

    if (quizId.isEmpty) {
      print('L\'ID ne peut pas etre vide.');
    } else if (!regExpId.hasMatch(quizId)) {
      print('L\'ID contient des caractères interdits (uniquement lettres, chiffres, tirets et underscores).');
      quizId = '';
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

  stdout.write('Publier ce quiz sur Firebase immédiatement ? (o/n) : ');
  final repPublier = stdin.readLineSync()?.toLowerCase();
  if (repPublier == 'o') {
    await FirestoreService().publierQuiz(quiz);
  }
}

/// Guide pour creer une seule question QCM.

Question creerQuestion(int numero, String quizId) {
  print('\n-- Question $numero --');

  stdout.write('Enonce de la question : ');
  final enonce = stdin.readLineSync() ?? '';

  final options = <String>[];
  const maxOptions = 5;
  const minOptions = 2;

  print('Ajoute les options (minimum $minOptions, maximum $maxOptions) :');

  while (options.length < maxOptions) {
    stdout.write('Option ${options.length + 1} : ');
    final option = stdin.readLineSync() ?? '';

    if (option.isEmpty) {
      print('Une option ne peut pas etre vide, reessaie.');
      continue;
    }

    options.add(option);

    // Si le maximum est deja atteint, pas besoin de demander : on sort direct
    if (options.length == maxOptions) {
      print('Nombre maximum d\'options atteint ($maxOptions).');
      break;
    }

    // Demande systematique apres CHAQUE option ajoutee
    stdout.write('Ajouter une autre option ? (o/n) : ');
    final continuer = stdin.readLineSync()?.toLowerCase();

    if (continuer != 'o') {
      // L'utilisateur veut s'arreter, mais le minimum n'est pas encore atteint
      if (options.length < minOptions) {
        print('Il faut au moins $minOptions options, continue.');
        continue;
      }
      break;
    }
  }

  // Saisie de la bonne reponse en base 1 (plus naturel pour l'utilisateur),
  // convertie en index interne base 0 pour rester coherent avec le modele.
  int numeroBonneReponse = -1;
  while (numeroBonneReponse < 1 || numeroBonneReponse > options.length) {
    stdout.write('Numero de la bonne reponse (1 a ${options.length}) : ');
    numeroBonneReponse = int.tryParse(stdin.readLineSync() ?? '') ?? -1;

    if (numeroBonneReponse < 1 || numeroBonneReponse > options.length) {
      print('Numero invalide, choisis entre 1 et ${options.length}.');
    }
  }
  final bonneReponseIndex =
      numeroBonneReponse - 1; // conversion base 1 -> base 0

  stdout.write('Points pour cette question : ');
  int points = -1;
  while (points < 0) {
    final inputPoints = stdin.readLineSync() ?? '';
    points = int.tryParse(inputPoints) ?? 10;
    if (points < 0) {
      print('Les points ne peuvent pas être négatifs. Réessaie : ');
    }
  }

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
Future<void> modifierQuiz(JsonService jsonService) async {
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

  stdout.write('Publier les modifications sur Firebase immédiatement ? (o/n) : ');
  final repPublier = stdin.readLineSync()?.toLowerCase();
  if (repPublier == 'o') {
    await FirestoreService().publierQuiz(quizModifie);
    print('\nQuiz publié avec succes sur Firebase');
  }
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
Future<void> supprimerQuiz() async {
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
    print('Quiz local supprime avec succes.');

    stdout.write('Le supprimer aussi de Firebase ? (o/n) : ');
    final repFirebase = stdin.readLineSync()?.toLowerCase();
    if (repFirebase == 'o') {
      await FirestoreService().supprimerQuiz(quizId);
    }
  } else {
    print('Suppression annulee.');
  }
}

Future<void> publierQuiz() async {
  stdout.write('\nID du quiz a publier : ');
  final quizId = stdin.readLineSync() ?? '';
  final chemin = 'data/$quizId.json';

  if (!File(chemin).existsSync()) {
    print('Quiz introuvable.');
    return;
  }

  final quiz = JsonService().lireQuiz(chemin);
  await FirestoreService().publierQuiz(quiz);
}

/// Télécharge les quiz depuis Firebase et les enregistre localement.
Future<void> telechargerQuizDepuisFirebase(JsonService jsonService) async {
  print('\n--- Synchronisation depuis Firebase ---');
  try {
    final quizEnLigne = await FirestoreService().recupererTousLesQuiz();
    if (quizEnLigne.isEmpty) {
      print('Aucun quiz trouvé sur Firebase.');
      return;
    }

    print('Quiz disponibles sur Firebase :');
    for (int i = 0; i < quizEnLigne.length; i++) {
      print('${i + 1}. [${quizEnLigne[i].quizId}] ${quizEnLigne[i].titre}');
    }

    stdout.write('\nEntrez le numéro du quiz à télécharger (ou "t" pour TOUT télécharger) : ');
    final choix = stdin.readLineSync()?.toLowerCase();

    if (choix == 't') {
      for (final quiz in quizEnLigne) {
        final chemin = 'data/${quiz.quizId}.json';
        jsonService.ecrireQuiz(quiz, chemin);
      }
      print('Tous les quiz ont été synchronisés avec succès localement !');
    } else {
      final index = (int.tryParse(choix ?? '') ?? 0) - 1;
      if (index >= 0 && index < quizEnLigne.length) {
        final quiz = quizEnLigne[index];
        final chemin = 'data/${quiz.quizId}.json';
        jsonService.ecrireQuiz(quiz, chemin);
        print('Quiz "${quiz.quizId}" synchronisé et enregistré localement.');
      } else {
        print('Choix invalide.');
      }
    }
  } catch (e) {
    print('Erreur lors du téléchargement : $e');
  }
}

/// Publie en bloc tous les fichiers JSON du dossier data/ vers Firebase.
Future<void> publierTousLesQuizLocaux(JsonService jsonService) async {
  print('\n--- Publication groupée (Bulk Upload) ---');
  final chemins = listerCheminsQuiz('data');

  if (chemins.isEmpty) {
    print('Aucun quiz local trouvé dans le dossier data/.');
    return;
  }

  print('${chemins.length} quiz locaux trouvés. Début de la publication...');
  int succes = 0;

  for (final chemin in chemins) {
    try {
      final quiz = jsonService.lireQuiz(chemin);
      print('Publication de ${quiz.quizId}...');
      await FirestoreService().publierQuiz(quiz);
      succes++;
    } catch (e) {
      print('Échec de la publication pour le fichier $chemin : $e');
    }
  }

  print('\nFin de la publication groupée : $succes/${chemins.length} quiz publiés avec succès !');
}

/// Vérifie si le fichier service_account.json est présent et si Firestore est accessible.
Future<void> testerConnexionFirebase() async {
  print('\n--- Diagnostic de la connexion Firebase ---');
  final file = File('service_account.json');
  
  if (!file.existsSync()) {
    print('[ERREUR] Le fichier "service_account.json" est ABSENT.');
    print('Action requise : Téléchargez la clé JSON depuis la console Firebase et placez-la à la racine de quizmaster_cli.');
    return;
  }
  print('[OK] Fichier "service_account.json" détecté.');

  try {
    print('Tentative d\'appel à l\'API Firestore...');
    final service = FirestoreService();
    // On tente simplement de lister les quiz pour voir si l'auth fonctionne
    await service.recupererTousLesQuiz();
    print('[SUCCÈS] Connexion établie ! Firestore répond correctement.');
  } catch (e) {
    print('[ERREUR] Echec de la connexion à Firestore.');
    print('Détails de l\'erreur : $e');
  }
}
