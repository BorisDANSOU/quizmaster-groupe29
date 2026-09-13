import '../repositories/auth_repository.dart';
import '../entities/auth_user.dart';

class ConnexionUseCase {
  const ConnexionUseCase(this._authRepository);

  final AuthRepository _authRepository;

  Future<AuthUser> call({required String email, required String password}) {
    return _authRepository.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }
}
