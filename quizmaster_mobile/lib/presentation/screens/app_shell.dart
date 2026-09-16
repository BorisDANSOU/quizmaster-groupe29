import 'package:flutter/material.dart';
import '../../domain/usecases/charger_liste_quiz_usecase.dart';
import '../../domain/usecases/valider_reponse_usecase.dart';
import '../../data/datasources/quiz_local_datasource.dart';
import '../../data/repositories/quiz_repository_impl.dart';
import 'splash_screen.dart';
import 'login_screen.dart';
import 'signup_screen.dart';
import 'main_navigation_screen.dart';

enum _Etape { splash, connexion, inscription, principal }

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  _Etape _etape = _Etape.splash;

  late final _quizRepository = QuizRepositoryImpl(
    dataSource: const QuizLocalDataSource(assetPath: 'assets/quizzes.json'),
  );
  late final _chargerListeQuiz = ChargerListeQuizUseCase(_quizRepository);
  final _validerReponse = const ValiderReponseUseCase();

  @override
  Widget build(BuildContext context) {
    switch (_etape) {
      case _Etape.splash:
        return SplashScreen(
          onInitialisationTerminee: () {
            setState(() => _etape = _Etape.connexion);
          },
        );

      case _Etape.connexion:
        return LoginScreen(
          onConnexion: (email, motDePasse) async {
            debugPrint('Connexion (simulee) : $email');
            setState(() => _etape = _Etape.principal);
          },
          onConnexionGoogle: () async {
            debugPrint('Connexion Google (simulee)');
            setState(() => _etape = _Etape.principal);
          },
          onNaviguerVersInscription: () =>
              setState(() => _etape = _Etape.inscription),
          onMotDePasseOublie: () {},
        );

      case _Etape.inscription:
        return SignupScreen(
          onInscription: (nom, email, motDePasse) async {
            debugPrint('Inscription (simulee) : $nom / $email');
            setState(() => _etape = _Etape.principal);
          },
          onNaviguerVersConnexion: () =>
              setState(() => _etape = _Etape.connexion),
        );

      case _Etape.principal:
        return MainNavigationScreen(
          chargerListeQuiz: _chargerListeQuiz,
          validerReponse: _validerReponse,
          onDeconnexion: () => setState(() => _etape = _Etape.connexion),
        );
    }
  }
}
