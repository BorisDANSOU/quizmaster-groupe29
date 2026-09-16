import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'domain/entities/auth_user.dart';
import 'data/datasources/auth_remote_datasource.dart';
import 'data/datasources/leaderboard_remote_datasource.dart';
import 'data/datasources/profil_remote_datasource.dart';
import 'data/datasources/quiz_local_datasource.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'data/repositories/leaderboard_repository_impl.dart';
import 'data/repositories/profil_repository_impl.dart';
import 'data/repositories/quiz_repository_impl.dart';

import 'presentation/screens/login_screen.dart';
import 'presentation/screens/signup_screen.dart';
import 'presentation/screens/splash_screen.dart';
import 'presentation/screens/main_navigation_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final authRepository = AuthRepositoryImpl(dataSource: AuthRemoteDataSource());
  final quizRepository = QuizRepositoryImpl(
    dataSource: const QuizLocalDataSource(assetPath: 'assets/quizzes.json'),
  );
  final profilRepository = ProfilRepositoryImpl(
    dataSource: ProfilRemoteDataSource(),
  );
  final leaderboardRepository = LeaderboardRepositoryImpl(
    dataSource: LeaderboardRemoteDataSource(),
  );

  runApp(
    QuizMasterApp(
      authRepository: authRepository,
      quizRepository: quizRepository,
      profilRepository: profilRepository,
      leaderboardRepository: leaderboardRepository,
    ),
  );
}

class QuizMasterApp extends StatelessWidget {
  const QuizMasterApp({
    super.key,
    required this.authRepository,
    required this.quizRepository,
    required this.profilRepository,
    required this.leaderboardRepository,
  });

  final AuthRepositoryImpl authRepository;
  final QuizRepositoryImpl quizRepository;
  final ProfilRepositoryImpl profilRepository;
  final LeaderboardRepositoryImpl leaderboardRepository;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QuizMaster',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF3E7BFA),
      ),
      home: AuthGate(
        authRepository: authRepository,
        quizRepository: quizRepository,
        profilRepository: profilRepository,
        leaderboardRepository: leaderboardRepository,
      ),
    );
  }
}

/// Dirige l'utilisateur vers l'auth ou l'app principale selon l'etat
/// REEL de la session Firebase (authStateChanges)
class AuthGate extends StatelessWidget {
  const AuthGate({
    super.key,
    required this.authRepository,
    required this.quizRepository,
    required this.profilRepository,
    required this.leaderboardRepository,
  });

  final AuthRepositoryImpl authRepository;
  final QuizRepositoryImpl quizRepository;
  final ProfilRepositoryImpl profilRepository;
  final LeaderboardRepositoryImpl leaderboardRepository;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthUser?>(
      stream: authRepository.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SplashScreen(onInitialisationTerminee: () {});
        }

        if (snapshot.hasData) {
          return MainNavigationScreen(
            onDemarrerQuiz: () {
              // TODO: brancher sur le vrai flux quiz une fois quiz_provider pret
            },
            onDeconnexion: () => authRepository.signOut(),
          );
        }

        return AuthFlow(authRepository: authRepository);
      },
    );
  }
}

/// Gere l'aller-retour Connexion <-> Inscription tant que
/// l'utilisateur n'est pas connecte.
class AuthFlow extends StatefulWidget {
  const AuthFlow({super.key, required this.authRepository});

  final AuthRepositoryImpl authRepository;

  @override
  State<AuthFlow> createState() => _AuthFlowState();
}

class _AuthFlowState extends State<AuthFlow> {
  bool _surInscription = false;
  bool _chargement = false;
  String? _erreur;

  Future<void> _connecter(String email, String motDePasse) async {
    setState(() {
      _chargement = true;
      _erreur = null;
    });
    try {
      await widget.authRepository.signInWithEmailAndPassword(
        email: email,
        password: motDePasse,
      );
      // Pas besoin de navigation manuelle : authStateChanges() dans
      // AuthGate detecte le changement et bascule automatiquement.
    } catch (e) {
      setState(
        () => _erreur = 'Connexion impossible : vérifie tes identifiants.',
      );
    } finally {
      if (mounted) setState(() => _chargement = false);
    }
  }

  Future<void> _connecterGoogle() async {
    setState(() {
      _chargement = true;
      _erreur = null;
    });
    try {
      await widget.authRepository.signInWithGoogle();
    } catch (e) {
      setState(() => _erreur = 'Connexion Google impossible.');
    } finally {
      if (mounted) setState(() => _chargement = false);
    }
  }

  Future<void> _inscrire(String nom, String email, String motDePasse) async {
    setState(() {
      _chargement = true;
      _erreur = null;
    });
    try {
      await widget.authRepository.signUpWithEmailAndPassword(
        email: email,
        password: motDePasse,
        displayName: nom,
      );
    } catch (e) {
      setState(() => _erreur = 'Inscription impossible : email déjà utilisé ?');
    } finally {
      if (mounted) setState(() => _chargement = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_surInscription) {
      return SignupScreen(
        isLoading: _chargement,
        erreur: _erreur,
        onInscription: _inscrire,
        onNaviguerVersConnexion: () => setState(() => _surInscription = false),
      );
    }

    return LoginScreen(
      isLoading: _chargement,
      erreur: _erreur,
      onConnexion: _connecter,
      onConnexionGoogle: _connecterGoogle,
      onNaviguerVersInscription: () => setState(() => _surInscription = true),
      onMotDePasseOublie: () {},
    );
  }
}
