import '../repositories/auth_repository.dart';

class VerifierSessionUseCase {
  const VerifierSessionUseCase(this._authRepository);

  final AuthRepository _authRepository;

  AuthUser? call() {
    return _authRepository.currentUser;
  }
}
