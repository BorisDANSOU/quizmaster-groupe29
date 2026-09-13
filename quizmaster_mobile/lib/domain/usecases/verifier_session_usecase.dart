import '../repositories/auth_repository.dart';
import '../entities/auth_user.dart';

class VerifierSessionUseCase {
  const VerifierSessionUseCase(this._authRepository);

  final AuthRepository _authRepository;

  AuthUser? call() {
    return _authRepository.currentUser;
  }
}
