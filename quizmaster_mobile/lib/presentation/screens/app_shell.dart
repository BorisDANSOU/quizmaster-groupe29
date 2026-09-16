import 'package:flutter/material.dart';
import 'splash_screen.dart';
import 'login_screen.dart';
import 'signup_screen.dart';
import 'main_navigation_screen.dart';
import 'quiz_flow_screen.dart';

enum _Etape { splash, connexion, inscription, principal, quiz }

/// Racine de la navigation de l'app. Gere les transitions entre
/// Splash -> Auth -> App principale -> Quiz
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  _Etape _etape = _Etape.splash;

  @override
  Widget build(BuildContext context) {
    switch (_etape) {
      case _Etape.splash:
        return SplashScreen(
          onInitialisationTerminee: () {
            // Ici, une fois Firebase branche : verifier authStateChanges()
            // et aller directement sur _Etape.principal si deja connecte.
            setState(() => _etape = _Etape.connexion);
          },
        );

      case _Etape.connexion:
        return LoginScreen(
          onConnexion: (email, motDePasse) async {
            debugPrint('Connexion : $email');
            setState(() => _etape = _Etape.principal);
          },
          onConnexionGoogle: () async {
            debugPrint('Connexion Google');
            setState(() => _etape = _Etape.principal);
          },
          onNaviguerVersInscription: () =>
              setState(() => _etape = _Etape.inscription),
          onMotDePasseOublie: () {},
        );

      case _Etape.inscription:
        return SignupScreen(
          onInscription: (nom, email, motDePasse) async {
            debugPrint('Inscription : $nom / $email');
            setState(() => _etape = _Etape.principal);
          },
          onNaviguerVersConnexion: () =>
              setState(() => _etape = _Etape.connexion),
        );

      case _Etape.principal:
        return MainNavigationScreen(
          onDemarrerQuiz: () => setState(() => _etape = _Etape.quiz),
          onDeconnexion: () => setState(() => _etape = _Etape.connexion),
        );

      case _Etape.quiz:
        return QuizFlowScreen(
          onTerminer: () => setState(() => _etape = _Etape.principal),
        );
    }
  }
}
