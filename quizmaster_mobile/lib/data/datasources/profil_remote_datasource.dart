import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/profil_utilisateur.dart';

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