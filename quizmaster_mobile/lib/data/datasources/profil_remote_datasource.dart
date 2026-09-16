import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/profil_utilisateur.dart';

class ProfilRemoteDataSource {
  ProfilRemoteDataSource({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  Future<ProfilUtilisateur?> getProfile(String uid) async {
    final snapshot = await _firestore.collection('users').doc(uid).get();
    final historique = await getHistory(uid);
    if (!snapshot.exists || snapshot.data() == null) {
      if (historique.isEmpty) return null;
      return ProfilUtilisateur(
        uid: uid,
        nom: '',
        email: '',
        quizJoues: historique.length,
        meilleureSerie: 0,
        tauxReussite: _calculerTauxReussite(historique),
        historique: historique,
      );
    }

    final data = snapshot.data()!;
    final statistiques = historique.any((entry) => entry.totalQuestions > 0)
        ? {
            'quizJoues': historique.length,
            'tauxReussite': _calculerTauxReussite(historique),
          }
        : const <String, int>{};

    return ProfilUtilisateur.fromJson({
      ...data,
      ...statistiques,
      'historique': historique.map((entry) => entry.toJson()).toList(),
      'uid': snapshot.id,
    });
  }

  int _calculerTauxReussite(List<HistoriqueQuiz> historique) {
    final totalQuestions = historique.fold<int>(
      0,
      (total, entry) => total + entry.totalQuestions,
    );
    if (totalQuestions == 0) return 0;
    final bonnesReponses = historique.fold<int>(
      0,
      (total, entry) => total + entry.score,
    );
    return ((bonnesReponses / totalQuestions) * 100).round();
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

  /// L'historique est stocke dans une sous-collection dediee a chaque
  /// utilisateur (users/{uid}/historique), separee du classement global.
  Future<List<HistoriqueQuiz>> getHistory(String uid) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(uid)
        .collection('historique')
        .orderBy('date', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => HistoriqueQuiz.fromJson(doc.data()))
        .toList();
  }

  Future<void> saveHistoryEntry(String uid, HistoriqueQuiz entry) async {
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('historique')
        .add(entry.toJson());
  }
}
