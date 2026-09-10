import 'dart:convert';
import 'dart:io';
import '../models/quiz.dart';

/// Service responsable de la lecture et de l'écriture des quiz
/// Isolé des models pour que Quiz/Question restent de simples structures
/// de données, sans logique de fichiers.
class JsonService {
  /// Lit un fichier JSON et le convertit en objet Quiz.
  /// Lance une exception si le fichier n'existe pas ou si le JSON est invalide.
  Quiz lireQuiz(String cheminFichier) {
    final fichier = File(cheminFichier);

    if (!fichier.existsSync()) {
      throw Exception('Fichier introuvable : $cheminFichier');
    }

    final contenu = fichier.readAsStringSync();
    final json = jsonDecode(contenu) as Map<String, dynamic>;

    return Quiz.fromJson(json);
  }

  void ecrireQuiz(Quiz quiz, String cheminFichier) {
    final fichier = File(cheminFichier);

    fichier.parent.createSync(recursive: true);

    // encoder avec indentation pour que le fichier reste lisible/editable
    final encoder = JsonEncoder.withIndent('  ');
    final contenuJson = encoder.convert(quiz.toJson());

    fichier.writeAsStringSync(contenuJson);
  }

  List<Quiz> lireListeQuiz(String cheminFichier) {
    final fichier = File(cheminFichier);

    if (!fichier.existsSync()) {
      return []; // Si le fichier n'existe pas, on retourne une liste vide au lieu de lancer une exception.
    }

    final contenu = fichier.readAsStringSync();
    final jsonList = jsonDecode(contenu) as List;

    return jsonList
        .map((json) => Quiz.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  void ecrireListeQuiz(List<Quiz> quizzes, String cheminFichier) {
    final fichier = File(cheminFichier);
    fichier.parent.createSync(recursive: true);

    final encoder = JsonEncoder.withIndent('  ');
    final contenuJson = encoder.convert(
      quizzes.map((q) => q.toJson()).toList(),
    );

    fichier.writeAsStringSync(contenuJson);
  }
}
