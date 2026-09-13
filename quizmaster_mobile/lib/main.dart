import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:quizmaster_mobile/domain/entities/auth_user.dart';

/// import 'firebase_options.dart';
import 'data/datasources/auth_remote_datasource.dart';
import 'data/datasources/leaderboard_remote_datasource.dart';
import 'data/datasources/profil_remote_datasource.dart';
import 'data/datasources/quiz_local_datasource.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'data/repositories/leaderboard_repository_impl.dart';
import 'data/repositories/profil_repository_impl.dart';
import 'data/repositories/quiz_repository_impl.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialisation de Firebase avec les options du projet
  await Firebase.initializeApp(
    ///options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialisation des Repositories (Injection simple pour l'exemple)
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
  final AuthRepositoryImpl authRepository;
  final QuizRepositoryImpl quizRepository;
  final ProfilRepositoryImpl profilRepository;
  final LeaderboardRepositoryImpl leaderboardRepository;

  const QuizMasterApp({
    super.key,
    required this.authRepository,
    required this.quizRepository,
    required this.profilRepository,
    required this.leaderboardRepository,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QuizMaster',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF2E7D32), // Vert forêt pour le thème
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF2E7D32),
        brightness: Brightness.dark,
      ),
      home: AuthGate(authRepository: authRepository),
    );
  }
}

/// Widget responsable de diriger l'utilisateur vers la page de connexion
/// ou vers l'accueil en fonction de son état d'authentification.
class AuthGate extends StatelessWidget {
  final AuthRepositoryImpl authRepository;

  const AuthGate({super.key, required this.authRepository});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthUser?>(
      stream: authRepository.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData) {
          return HomePage(
            user: snapshot.data!,
            authRepository: authRepository,
          );
        }

        return const LoginPage();
      },
    );
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Connexion')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Logique de connexion à implémenter
          },
          child: const Text('Se connecter'),
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
    required this.user,
    required this.authRepository,
  });

  final AuthUser user;
  final AuthRepositoryImpl authRepository;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QuizMaster'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authRepository.signOut();
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Bienvenue, ${user.displayName ?? user.email ?? 'joueur'}'),
            const SizedBox(height: 20),
            const Text('Prêt pour un quiz ?'),
          ],
        ),
      ),
    );
  }
}
