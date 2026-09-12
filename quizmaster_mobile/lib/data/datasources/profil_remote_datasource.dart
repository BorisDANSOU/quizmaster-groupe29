import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/profil_utilisateur.dart';
import '../../domain/entities/resultat_quiz.dart';

class ProfilRemoteDataSource {
  ProfilRemoteDataSource({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  Future<ProfilUtilisateur?> getProfile(String uid) async {
    final snapshot = await _firestore.collection('users').doc(uid).get();
    if (!snapshot.exists || snapshot.data() == null) {
      return null;
    }

    final data = snapshot.data()!;
    return ProfilUtilisateur.fromJson({...data, 'uid': snapshot.id});
  }

  Future<void> createOrUpdateProfile(
    String uid,
    ProfilUtilisateur profile,
  ) async {
    await _firestore
        .collection('users')
        .doc(uid)
        .set(profile.copyWith(uid: uid).toJson(), SetOptions(merge: true));
  }

  Future<List<ResultatQuiz>> getHistory(String uid) async {
    final snapshot = await _firestore
        .collection('results')
        .where('joueur', isEqualTo: uid)
        .orderBy('date', descending: true)
        .get();

    return snapshot.docs
        .map(
          (doc) => ResultatQuiz.fromJson({
            ...doc.data(),
            'quizId': doc.data()['quizId'] ?? '',
          }),
        )
        .toList();
  }

  Future<void> saveHistoryEntry(ResultatQuiz result) async {
    await _firestore.collection('results').add(result.toJson());
  }
}
