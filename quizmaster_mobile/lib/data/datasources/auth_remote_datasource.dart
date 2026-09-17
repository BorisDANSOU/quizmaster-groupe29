import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../domain/entities/auth_user.dart';

class AuthRemoteDataSource {
  AuthRemoteDataSource({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

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

  Future<AuthUser> signInWithGoogle() async {
    // L'initialisation est maintenant faite dans le main.dart
    final googleUser = await _googleSignIn.authenticate();
    final googleAuth = googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );

    final userCredential = await _firebaseAuth.signInWithCredential(credential);
    final user = userCredential.user;
    if (user == null) {
      throw StateError(
        'Erreur de connexion Google : aucun utilisateur retourné.',
      );
    }
    return _toAuthUser(user)!;
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _firebaseAuth.signOut();
  }

  Future<void> updateDisplayName(String displayName) async {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      throw StateError('Aucun utilisateur connecte.');
    }
    await user.updateDisplayName(displayName.trim());
    await user.reload();
  }

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
