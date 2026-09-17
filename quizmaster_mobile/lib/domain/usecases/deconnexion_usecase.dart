import '../repositories/auth_repository.dart';

class DeconnexionUseCase {
  const DeconnexionUseCase(this._authRepository);

  final AuthRepository _authRepository;

  Future<void> call() {
    return _authRepository.signOut();
  }
}
