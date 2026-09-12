import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/profil_utilisateur.dart';
import '../../domain/entities/resultat_quiz.dart';

class LeaderboardRemoteDataSource {
  LeaderboardRemoteDataSource({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  Future<List<ProfilUtilisateur>> getLeaderboard({int limit = 20}) async {
    final snapshot = await _firestore
        .collection('users')
        .orderBy('totalPoints', descending: true)
        .limit(limit)
        .get();

    return snapshot.docs
        .map(
          (doc) => ProfilUtilisateur.fromJson({...doc.data(), 'uid': doc.id}),
        )
        .toList();
  }

  Future<void> saveResult(ResultatQuiz result) async {
    final data = result.toJson();
    await _firestore.collection('results').add(data);

    final userDoc = _firestore.collection('users').doc(result.joueur);
    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(userDoc);
      if (!snapshot.exists) {
        transaction.set(userDoc, {
          'totalPoints': result.score,
          'quizzesCompleted': 1,
          'uid': result.joueur,
        });
      } else {
        final currentPoints = snapshot.data()?['totalPoints'] as int? ?? 0;
        final currentCompleted =
            snapshot.data()?['quizzesCompleted'] as int? ?? 0;
        transaction.update(userDoc, {
          'totalPoints': currentPoints + result.score,
          'quizzesCompleted': currentCompleted + 1,
        });
      }
    });
  }
}
