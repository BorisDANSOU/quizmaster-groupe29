import 'dart:io';
// ignore: deprecated_member_use
import 'package:googleapis/firestore/v1.dart';
import 'package:googleapis_auth/auth_io.dart';
import '../models/quiz.dart';

/// Ecrit les quiz directement dans Firestore, pour que le mobile
/// les recoive en temps reel (StreamProvider Riverpod cote mobile).
/// Utilise un compte de service (acces admin), jamais expose au mobile.
class FirestoreService {
  static const _projectId = 'quizmaster-groupe29'; // ajuste si different
  static const _scopes = ['https://www.googleapis.com/auth/datastore'];

  Future<FirestoreApi> _client() async {
    final credsJson = File('service_account.json').readAsStringSync();
    final credentials = ServiceAccountCredentials.fromJson(credsJson);
    final client = await clientViaServiceAccount(credentials, _scopes);
    return FirestoreApi(client);
  }

  /// Envoie (cree ou met a jour) un quiz dans la collection "quizzes".
  Future<void> publierQuiz(Quiz quiz) async {
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
  }
}
