import '../entities/profil_utilisateur.dart';
import '../entities/resultat_quiz.dart';

abstract class ProfilRepository {
  Future<ProfilUtilisateur?> getProfile(String uid);
  Future<void> createOrUpdateProfile(String uid, ProfilUtilisateur profile);
  Future<List<ResultatQuiz>> getHistory(String uid);
  Future<void> saveHistoryEntry(ResultatQuiz result);
}
