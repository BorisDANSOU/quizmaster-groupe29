import '../entities/profil_utilisateur.dart';
import '../repositories/profil_repository.dart';

class ChargerProfilUsecase {
  const ChargerProfilUsecase(this._profilRepository);

  final ProfilRepository _profilRepository;

  Future<ProfilUtilisateur?> call(String uid) {
    return _profilRepository.getProfile(uid);
  }
}