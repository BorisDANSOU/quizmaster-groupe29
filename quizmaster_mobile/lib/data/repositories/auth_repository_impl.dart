import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../../domain/entities/auth_user.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({AuthRemoteDataSource? dataSource})
    : _dataSource = dataSource ?? AuthRemoteDataSource();

  final AuthRemoteDataSource _dataSource;

  @override
  Future<AuthUser> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) {
    return _dataSource.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<AuthUser> signUpWithEmailAndPassword({
    required String email,
    required String password,
    String? displayName,
  }) {
    return _dataSource.signUpWithEmailAndPassword(
      email: email,
      password: password,
      displayName: displayName,
    );
  }

  @override
  Future<AuthUser> signInWithGoogle() {
    return _dataSource.signInWithGoogle();
  }

  @override
  Future<void> signOut() => _dataSource.signOut();

  @override
  Stream<AuthUser?> authStateChanges() => _dataSource.authStateChanges();

  @override
  AuthUser? get currentUser => _dataSource.currentUser;
}