import '../../domain/entities/profil_utilisateur.dart';
import '../../domain/entities/resultat_quiz.dart';
import '../../domain/repositories/leaderboard_repository.dart';
import '../datasources/leaderboard_remote_datasource.dart';

class LeaderboardRepositoryImpl implements LeaderboardRepository {
  LeaderboardRepositoryImpl({LeaderboardRemoteDataSource? dataSource})
    : _dataSource = dataSource ?? LeaderboardRemoteDataSource();

  final LeaderboardRemoteDataSource _dataSource;

  @override
  Future<List<ProfilUtilisateur>> getLeaderboard({int limit = 10}) {
    return _dataSource.getLeaderboard(limit: limit);
  }

  @override
  Future<void> saveResult(ResultatQuiz result) {
    return _dataSource.saveResult(result);
  }
}
