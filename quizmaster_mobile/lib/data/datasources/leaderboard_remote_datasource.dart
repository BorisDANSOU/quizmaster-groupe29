import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import '../../domain/entities/profil_utilisateur.dart';
import '../../domain/entities/resultat_quiz.dart';

class LeaderboardRemoteDataSource {
  LeaderboardRemoteDataSource({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  Future<List<ProfilUtilisateur>> getLeaderboard({int limit = 10}) async {
    final snapshot = await _firestore
        .collection('users')
        .orderBy('totalPoints', descending: true)
        .limit(limit)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return ProfilUtilisateur.fromJson({
        ...data,
        'uid': doc.id,
        'nom': data['nom'] ?? '',
        'email': data['email'] ?? '',
        'quizJoues': data['quizzesCompleted'] ?? data['quizJoues'] ?? 0,
        'totalPoints': data['totalPoints'] ?? 0,
      });
    }).toList();
  }

  Future<void> saveResult(ResultatQuiz result) async {
    final data = result.toJson();
    await _firestore.collection('results').add(data);

    final userDoc = _firestore.collection('users').doc(result.joueur);
    final firebaseAuth = Firebase.apps.isNotEmpty ? FirebaseAuth.instance : null;
    final currentUser = firebaseAuth?.currentUser;
    final displayName = currentUser?.displayName?.trim();

    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(userDoc);
      if (!snapshot.exists) {
        transaction.set(userDoc, {
          'totalPoints': result.score,
          'quizzesCompleted': 1,
          'quizJoues': 1,
          'uid': result.joueur,
          'nom': displayName ?? '',
          'email': currentUser?.email ?? '',
        });
      } else {
        final currentPoints = snapshot.data()?['totalPoints'] as int? ?? 0;
        final currentCompleted =
            snapshot.data()?['quizzesCompleted'] as int? ?? 0;
        final currentQuizJoues =
            snapshot.data()?['quizJoues'] as int? ?? currentCompleted;
        final currentName = snapshot.data()?['nom'] as String? ?? '';

        transaction.update(userDoc, {
          'totalPoints': currentPoints + result.score,
          'quizzesCompleted': currentCompleted + 1,
          'quizJoues': currentQuizJoues + 1,
          if (displayName != null && displayName.isNotEmpty && currentName.isEmpty)
            'nom': displayName,
          if (currentUser?.email != null &&
              currentUser!.email!.isNotEmpty &&
              (snapshot.data()?['email'] as String? ?? '').isEmpty)
            'email': currentUser.email,
        });
      }
    });
  }
}
