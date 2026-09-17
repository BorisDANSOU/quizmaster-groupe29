import '../repositories/auth_repository.dart';
import '../entities/auth_user.dart';

class ConnexionGoogleUsecase {
  const ConnexionGoogleUsecase(this._authRepository);

  final AuthRepository _authRepository;

  Future<AuthUser> call() {
    return _authRepository.signInWithGoogle();
  }
}