import '../entities/profil_utilisateur.dart';
import '../entities/resultat_quiz.dart';

abstract class LeaderboardRepository {
  Future<List<ProfilUtilisateur>> getLeaderboard({int limit = 10});
  Future<void> saveResult(ResultatQuiz result);
}
