import '../entities/auth_user.dart';

abstract class AuthRepository {
  Future<AuthUser> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<AuthUser> signUpWithEmailAndPassword({
    required String email,
    required String password,
    String? displayName,
  });

 /// Connexion via Google Sign-In .
  Future<AuthUser> signInWithGoogle();

  Future<void> signOut();

  Stream<AuthUser?> authStateChanges();

  AuthUser? get currentUser;
}
