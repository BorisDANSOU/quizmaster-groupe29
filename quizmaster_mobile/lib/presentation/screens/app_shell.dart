import 'package:flutter/material.dart';
import '../../domain/usecases/charger_liste_quiz_usecase.dart';
import '../../domain/usecases/valider_reponse_usecase.dart';
import '../../domain/usecases/charger_profil_usecase.dart';
import '../../domain/usecases/charger_classement_usecase.dart';
import '../../domain/usecases/enregistrer_resultat_usecase.dart';
import '../../data/datasources/quiz_local_datasource.dart';
import '../../data/repositories/quiz_repository_impl.dart';
import '../../data/datasources/profil_remote_datasource.dart';
import '../../data/repositories/profil_repository_impl.dart';
import '../../data/datasources/leaderboard_remote_datasource.dart';
import '../../data/repositories/leaderboard_repository_impl.dart';
import 'splash_screen.dart';
import 'login_screen.dart';
import 'signup_screen.dart';
import 'main_navigation_screen.dart';

enum _Etape { splash, connexion, inscription, principal }

/// Racine de navigation utilisee UNIQUEMENT pour l'apercu visuel local
/// (lib/main_preview.dart). Connexion simulee (n'importe quel email/mdp
/// "reussit"), mais quiz/profil/classement sont charges reellement.
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
  late final _profilRepository = ProfilRepositoryImpl(
    dataSource: ProfilRemoteDataSource(),
  );
  late final _leaderboardRepository = LeaderboardRepositoryImpl(
    dataSource: LeaderboardRemoteDataSource(),
  );

  late final _chargerListeQuiz = ChargerListeQuizUseCase(_quizRepository);
  final _validerReponse = const ValiderReponseUseCase();
  late final _chargerProfil = ChargerProfilUsecase(_profilRepository);
  late final _chargerClassement = ChargerClassementUseCase(
    _leaderboardRepository,
  );
  late final _enregistrerResultat = EnregistrerResultatUseCase(
    _leaderboardRepository,
    _profilRepository,
  );

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
          uid: 'uid_apercu_local', // faux uid, sans vrai compte Firebase
          chargerListeQuiz: _chargerListeQuiz,
          validerReponse: _validerReponse,
          chargerProfil: _chargerProfil,
          chargerClassement: _chargerClassement,
          enregistrerResultat: _enregistrerResultat,
          onDeconnexion: () => setState(() => _etape = _Etape.connexion),
        );
    }
  }
}
