import '../entities/resultat_quiz.dart';
import '../repositories/leaderboard_repository.dart';
import '../repositories/profil_repository.dart';
import '../entities/profil_utilisateur.dart';

/// Enregistre le resultat d'un quiz a deux endroits :
/// - le classement global (Firebase, pour tous les joueurs)
/// - l'historique personnel du joueur (pour l'ecran Profil)

class EnregistrerResultatUseCase {
  const EnregistrerResultatUseCase(
    this._leaderboardRepository,
    this._profilRepository,);

  final LeaderboardRepository _leaderboardRepository;
  final ProfilRepository _profilRepository;

  Future<void> call(ResultatQuiz resultat, {required String titreQuiz}) async {
    await _leaderboardRepository.saveResult(resultat);

    // await _profilRepository.saveHistoryEntry(resultat);
    await _profilRepository.saveHistoryEntry(
      resultat.joueur,
      HistoriqueQuiz(
        quizId: resultat.quizId,
        titre: titreQuiz,
        score: resultat.score,
        date: resultat.date,
      ),
    );

  }
}
