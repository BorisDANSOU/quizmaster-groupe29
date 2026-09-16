import 'dart:io';
// ignore: deprecated_member_use
import 'package:googleapis/firestore/v1.dart';
import 'package:googleapis_auth/auth_io.dart';
import '../models/quiz.dart';
import '../models/question.dart';

/// Ecrit les quiz directement dans Firestore, pour que le mobile
/// les recoive en temps reel (StreamProvider Riverpod cote mobile).
/// Utilise un compte de service (acces admin), jamais expose au mobile.
class FirestoreService {
  static const _projectId = 'quizmaster-cli-and-mobile'; // ajuste si different
  static const _scopes = ['https://www.googleapis.com/auth/datastore'];

  Future<FirestoreApi> _client() async {
    final file = File('service_account.json');
    if (!file.existsSync()) {
      throw Exception('Le fichier "service_account.json" est manquant à la racine du CLI.');
    }
    final credsJson = file.readAsStringSync();
    final credentials = ServiceAccountCredentials.fromJson(credsJson);
    final client = await clientViaServiceAccount(credentials, _scopes);
    return FirestoreApi(client);
  }

  /// Récupère la liste de tous les quiz en ligne sur Firestore.
  Future<List<Quiz>> recupererTousLesQuiz() async {
    try {
      final api = await _client();
      final parent = 'projects/$_projectId/databases/(default)/documents';
      
      final collection = await api.projects.databases.documents.list(parent, 'quizzes');
      if (collection.documents == null) return [];

      final listeQuiz = <Quiz>[];
      for (final doc in collection.documents!) {
        final fields = doc.fields;
        if (fields == null) continue;

        final quizId = fields['quizId']?.stringValue ?? '';
        final titre = fields['titre']?.stringValue ?? '';
        final categorie = fields['categorie']?.stringValue ?? '';
        final difficulte = fields['difficulte']?.stringValue ?? '';

        final qList = <Question>[];
        final questionsValue = fields['questions']?.arrayValue?.values;
        if (questionsValue != null) {
          for (final qVal in questionsValue) {
            final qMap = qVal.mapValue?.fields;
            if (qMap != null) {
              final optionsList = <String>[];
              final optValues = qMap['options']?.arrayValue?.values;
              if (optValues != null) {
                for (final oV in optValues) {
                  if (oV.stringValue != null) optionsList.add(oV.stringValue!);
                }
              }

              qList.add(Question(
                id: qMap['id']?.stringValue ?? '',
                enonce: qMap['enonce']?.stringValue ?? '',
                type: qMap['type']?.stringValue ?? 'qcm',
                options: optionsList,
                bonneReponseIndex: int.tryParse(qMap['bonneReponseIndex']?.integerValue ?? '0') ?? 0,
                points: int.tryParse(qMap['points']?.integerValue ?? '10') ?? 10,
              ));
            }
          }
        }

        listeQuiz.add(Quiz(
          quizId: quizId,
          titre: titre,
          categorie: categorie,
          difficulte: difficulte,
          questions: qList,
        ));
      }
      return listeQuiz;
    } catch (e) {
      throw Exception('Erreur lors de la récupération des quiz depuis Firestore: $e');
    }
  }

  /// Envoie (cree ou met a jour) un quiz dans la collection "quizzes".
  Future<void> publierQuiz(Quiz quiz) async {
    try {
      final api = await _client();
      final parent = 'projects/$_projectId/databases/(default)/documents';

    final document = Document(
      fields: {
        'quizId': Value(stringValue: quiz.quizId),
        'titre': Value(stringValue: quiz.titre),
        'categorie': Value(stringValue: quiz.categorie),
        'difficulte': Value(stringValue: quiz.difficulte),
        'questions': Value(
          arrayValue: ArrayValue(
            values: quiz.questions
                .map(
                  (q) => Value(
                    mapValue: MapValue(
                      fields: {
                        'id': Value(stringValue: q.id),
                        'enonce': Value(stringValue: q.enonce),
                        'type': Value(stringValue: q.type),
                        'options': Value(
                          arrayValue: ArrayValue(
                            values: q.options
                                .map((o) => Value(stringValue: o))
                                .toList(),
                          ),
                        ),
                        'bonneReponseIndex': Value(
                          integerValue: q.bonneReponseIndex.toString(),
                        ),
                        'points': Value(integerValue: q.points.toString()),
                      },
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      },
    );

    await api.projects.databases.documents.patch(
      document,
      '$parent/quizzes/${quiz.quizId}',
    );

    print('Quiz "${quiz.quizId}" publie sur Firestore avec succes.');
    } catch (e) {
      print('Erreur lors de la publication du quiz "${quiz.quizId}" : $e');
    }
  }

  /// Supprime un quiz de Firestore.
  Future<void> supprimerQuiz(String quizId) async {
    try {
      final api = await _client();
      final parent = 'projects/$_projectId/databases/(default)/documents';

      await api.projects.databases.documents.delete('$parent/quizzes/$quizId');

      print('Quiz "$quizId" supprime de Firestore avec succes.');
    } catch (e) {
      print('Erreur lors de la suppression du quiz "$quizId" de Firestore : $e');
    }
  }
}
