import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quizmaster_mobile/domain/usecases/charger_profil_usecase.dart';

import 'firebase_options.dart';
import 'domain/entities/auth_user.dart';
import 'domain/usecases/charger_liste_quiz_usecase.dart';
import 'domain/usecases/valider_reponse_usecase.dart';
import 'domain/usecases/charger_classement_usecase.dart';
import 'domain/usecases/enregistrer_resultat_usecase.dart';

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
import 'presentation/theme/app_colors.dart';

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
    ProviderScope(
      child: QuizMasterApp(
        authRepository: authRepository,
        quizRepository: quizRepository,
        profilRepository: profilRepository,
        leaderboardRepository: leaderboardRepository,
      ),
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
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryBlue,
          primary: AppColors.primaryBlue,
          secondary: AppColors.primaryBlueDark,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: AppColors.lightBackground,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
        ),
        textTheme: ThemeData.light().textTheme.apply(
          bodyColor: AppColors.textPrimaryLight,
          displayColor: AppColors.textPrimaryLight,
        ),
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
/// REEL de la session Firebase (authStateChanges).
/// L'ecran de splash est affiche d'abord pour le lancement propre de l'app.
class AuthGate extends StatefulWidget {
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
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  bool _afficherSplash = true;

  void _finSplash() {
    if (mounted) {
      setState(() => _afficherSplash = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_afficherSplash) {
      return SplashScreen(onInitialisationTerminee: _finSplash);
    }

    return StreamBuilder<AuthUser?>(
      stream: widget.authRepository.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return MainNavigationScreen(
            uid: snapshot.data!.uid,
            chargerListeQuiz: ChargerListeQuizUseCase(widget.quizRepository),
            validerReponse: const ValiderReponseUseCase(),
            chargerProfil: ChargerProfilUsecase(widget.profilRepository),
            chargerClassement: ChargerClassementUseCase(
              widget.leaderboardRepository,
            ),
            enregistrerResultat: EnregistrerResultatUseCase(
              widget.leaderboardRepository,
              widget.profilRepository,
            ),
            onDeconnexion: () => widget.authRepository.signOut(),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting &&
            !_afficherSplash) {
          return AuthFlow(authRepository: widget.authRepository);
        }

        return AuthFlow(authRepository: widget.authRepository);
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

  String _messageErreur(Object e) {
    if (e is FirebaseAuthException) {
      debugPrint('FirebaseAuthException: code=${e.code} message=${e.message}');
      switch (e.code) {
        case 'email-already-in-use':
          return 'Cet email est déjà utilisé.';
        case 'invalid-email':
          return 'Adresse email invalide.';
        case 'weak-password':
          return 'Mot de passe trop faible (6 caractères minimum).';
        case 'user-not-found':
        case 'wrong-password':
        case 'invalid-credential':
          return 'Email ou mot de passe incorrect.';
        case 'network-request-failed':
          return 'Problème de connexion internet.';
        default:
          return 'Erreur (${e.code}) : ${e.message}';
      }
    }
    debugPrint('Erreur non-Firebase: $e');
    return 'Erreur inattendue : $e';
  }

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
    } catch (e) {
      setState(() => _erreur = _messageErreur(e));
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
      setState(() => _erreur = _messageErreur(e));
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
      setState(() => _erreur = _messageErreur(e));
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
