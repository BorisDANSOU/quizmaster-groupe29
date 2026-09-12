import '../entities/resultat_quiz.dart';
import '../repositories/leaderboard_repository.dart';

class EnregistrerResultatUseCase {
  const EnregistrerResultatUseCase(this._leaderboardRepository);

  final LeaderboardRepository _leaderboardRepository;

  Future<void> call(ResultatQuiz resultat) {
    return _leaderboardRepository.saveResult(resultat);
  }
}
