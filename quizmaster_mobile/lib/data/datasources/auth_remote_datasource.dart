import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/repositories/auth_repository.dart';

class AuthRemoteDataSource {
  AuthRemoteDataSource({FirebaseAuth? firebaseAuth})
    : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  final FirebaseAuth _firebaseAuth;

  Future<AuthUser> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final credential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = credential.user;
    if (user == null) {
      throw StateError('Erreur de connexion : aucun utilisateur retourné.');
    }
    return _toAuthUser(user)!;
  }

  Future<AuthUser> signUpWithEmailAndPassword({
    required String email,
    required String password,
    String? displayName,
  }) async {
    final credential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final trimmedName = displayName?.trim();
    if (trimmedName != null && trimmedName.isNotEmpty) {
      final currentUser = credential.user;
      if (currentUser != null) {
        await currentUser.updateDisplayName(trimmedName);
        await currentUser.reload();
      }
    }

    final user = credential.user;
    if (user == null) {
      throw StateError('Erreur d’inscription : aucun utilisateur retourné.');
    }
    return _toAuthUser(user)!;
  }

  Future<void> signOut() => _firebaseAuth.signOut();

  Stream<AuthUser?> authStateChanges() {
    return _firebaseAuth.authStateChanges().map((user) => _toAuthUser(user));
  }

  AuthUser? get currentUser => _toAuthUser(_firebaseAuth.currentUser);

  AuthUser? _toAuthUser(User? user) {
    if (user == null) {
      return null;
    }

    return AuthUser(
      uid: user.uid,
      email: user.email,
      displayName: user.displayName,
      photoUrl: user.photoURL,
      isAnonymous: user.isAnonymous,
    );
  }
}
