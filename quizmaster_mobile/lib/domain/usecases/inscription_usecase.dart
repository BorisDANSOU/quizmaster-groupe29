import '../repositories/auth_repository.dart';
import '../entities/auth_user.dart';

class InscriptionUseCase {
  const InscriptionUseCase(this._authRepository);

  final AuthRepository _authRepository;

  Future<AuthUser> call({
    required String email,
    required String password,
    String? displayName,
  }) {
    return _authRepository.signUpWithEmailAndPassword(
      email: email,
      password: password,
      displayName: displayName,
    );
  }
}
