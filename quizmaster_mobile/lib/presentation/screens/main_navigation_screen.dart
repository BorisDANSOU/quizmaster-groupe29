import 'package:flutter/material.dart';
import '../../domain/entities/quiz.dart';
import '../../domain/usecases/charger_liste_quiz_usecase.dart';
import '../../domain/usecases/valider_reponse_usecase.dart';
import '../theme/app_colors.dart';
import 'home_screen.dart';
import 'explore_screen.dart';
import 'leaderboard_screen.dart';
import 'profile_screen.dart';
import 'quiz_flow_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({
    super.key,
    required this.chargerListeQuiz,
    required this.validerReponse,
    required this.onDeconnexion,
  });

  final ChargerListeQuizUseCase chargerListeQuiz;
  final ValiderReponseUseCase validerReponse;
  final VoidCallback onDeconnexion;

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _ongletActuel = 0;
  List<Quiz> _quizzes = [];
  bool _chargement = true;

  static const _couleursCategories = {
    'Education': AppColors.categorieEducation,
    'Sante_Bien_Etre': AppColors.categorieSante,
    'Mode_De_Vie': AppColors.categorieModeDeVie,
    'Developpement_Personnel': AppColors.categorieDeveloppement,
  };
  static const _iconesCategories = {
    'Education': Icons.school,
    'Sante_Bien_Etre': Icons.favorite,
    'Mode_De_Vie': Icons.auto_awesome,
    'Developpement_Personnel': Icons.person,
  };

  @override
  void initState() {
    super.initState();
    _chargerQuiz();
  }

  Future<void> _chargerQuiz() async {
    final quizzes = await widget.chargerListeQuiz.call();
    if (!mounted) return;
    setState(() {
      _quizzes = quizzes;
      _chargement = false;
    });
  }

  void _changerOnglet(int index) => setState(() => _ongletActuel = index);

  void _demarrerQuiz(Quiz quiz) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => QuizFlowScreen(
          quiz: quiz,
          validerReponse: widget.validerReponse,
          onTerminer: () => Navigator.of(context).pop(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_chargement) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final categoriesUniques = _quizzes.map((q) => q.categorie).toSet().toList();

    return IndexedStack(
      index: _ongletActuel,
      children: [
        HomeScreen(
          nomUtilisateur: '',
          quizEnCours: null,
          categories: categoriesUniques
              .map(
                (cat) => CategorieData(
                  nom: cat,
                  nombreQuiz: _quizzes.where((q) => q.categorie == cat).length,
                  icone: _iconesCategories[cat] ?? Icons.quiz,
                  couleur: _couleursCategories[cat] ?? AppColors.primaryBlue,
                ),
              )
              .toList(),
          quizRecents: _quizzes
              .take(3)
              .map(
                (q) => QuizRecentData(
                  categorie: q.categorie,
                  titre: q.titre,
                  sousTexte:
                      '${q.questions.length} questions • ${q.difficulte}',
                  couleur:
                      _couleursCategories[q.categorie] ?? AppColors.primaryBlue,
                  icone: _iconesCategories[q.categorie] ?? Icons.quiz,
                ),
              )
              .toList(),
          onTapQuizEnCours: () {},
          onTapCategorie: (c) => _changerOnglet(1),
          onTapQuizRecent: (data) {
            final quiz = _quizzes.firstWhere((q) => q.titre == data.titre);
            _demarrerQuiz(quiz);
          },
          onTapVoirToutesCategories: () => _changerOnglet(1),
          onTapVoirTousQuizRecents: () {},
          onChangerOnglet: _changerOnglet,
        ),
        ExploreScreen(
          categories: categoriesUniques
              .map(
                (cat) => CategorieExploreData(
                  nom: cat,
                  resume:
                      '${_quizzes.where((q) => q.categorie == cat).length} quiz',
                  icone: _iconesCategories[cat] ?? Icons.quiz,
                  couleur: _couleursCategories[cat] ?? AppColors.primaryBlue,
                ),
              )
              .toList(),
          onTapCategorie: (c) {
            final quizzesDeCategorie = _quizzes
                .where((q) => q.categorie == c.nom)
                .toList();
            if (quizzesDeCategorie.isNotEmpty) {
              _demarrerQuiz(quizzesDeCategorie.first);
            }
          },
          onRetour: () => _changerOnglet(0),
          onChangerOnglet: _changerOnglet,
          onRecherche: (texte) {},
        ),
        LeaderboardScreen(
          podium: const [],
          classement: const [],
          onChangerOnglet: _changerOnglet,
        ),
        ProfileScreen(
          nom: '',
          email: '',
          quizJoues: 0,
          meilleureSerie: 0,
          tauxReussite: 0,
          historique: const [],
          onEditer: () {},
          onVoirToutHistorique: () {},
          onTapHistorique: (item) {},
          onParametres: () {},
          onAide: () {},
          onDeconnexion: widget.onDeconnexion,
          onChangerOnglet: _changerOnglet,
        ),
      ],
    );
  }
}
