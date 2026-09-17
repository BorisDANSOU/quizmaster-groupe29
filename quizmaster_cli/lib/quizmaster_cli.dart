import 'dart:io';

/// Liste les chemins des fichiers JSON présents dans un dossier donné.
List<String> listerCheminsQuiz(String cheminDossier) {
  final dossier = Directory(cheminDossier);

  if (!dossier.existsSync()) {
    return const [];
  }

  return dossier
      .listSync()
      .whereType<File>()
      .where((f) => f.path.endsWith('.json'))
      .map((f) => f.path)
      .toList();
}
