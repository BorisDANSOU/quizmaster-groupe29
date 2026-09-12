import '../entities/profil_utilisateur.dart';
import '../repositories/leaderboard_repository.dart';

class ChargerClassementUseCase {
  const ChargerClassementUseCase(this._leaderboardRepository);

  final LeaderboardRepository _leaderboardRepository;

  Future<List<ProfilUtilisateur>> call({int limit = 20}) {
    return _leaderboardRepository.getLeaderboard(limit: limit);
  }
}
