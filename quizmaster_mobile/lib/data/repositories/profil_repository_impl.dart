import '../../domain/entities/profil_utilisateur.dart';
import '../../domain/repositories/profil_repository.dart';
import '../datasources/profil_remote_datasource.dart';

class ProfilRepositoryImpl implements ProfilRepository {
  ProfilRepositoryImpl({ProfilRemoteDataSource? dataSource})
    : _dataSource = dataSource ?? ProfilRemoteDataSource();

  final ProfilRemoteDataSource _dataSource;

  @override
  Future<ProfilUtilisateur?> getProfile(String uid) {
    return _dataSource.getProfile(uid);
  }

  @override
  Future<void> createOrUpdateProfile(String uid, ProfilUtilisateur profile) {
    return _dataSource.createOrUpdateProfile(uid, profile);
  }

  @override
  Future<List<HistoriqueQuiz>> getHistory(String uid) {
    return _dataSource.getHistory(uid);
  }

  @override
  Future<void> saveHistoryEntry(String uid, HistoriqueQuiz entry) {
    return _dataSource.saveHistoryEntry(uid, entry);
  }
}