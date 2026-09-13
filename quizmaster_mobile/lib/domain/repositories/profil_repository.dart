import '../entities/profil_utilisateur.dart';

abstract class ProfilRepository {
  Future<ProfilUtilisateur?> getProfile(String uid);
  Future<void> createOrUpdateProfile(String uid, ProfilUtilisateur profile);
  Future<List<HistoriqueQuiz>> getHistory(String uid);
  Future<void> saveHistoryEntry(String uid, HistoriqueQuiz entry);
}