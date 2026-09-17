import 'dart:async';

import 'package:flutter/material.dart';
import '../../domain/entities/profil_utilisateur.dart';
import '../../domain/entities/quiz.dart';
import '../../domain/entities/resultat_quiz.dart';
import '../../domain/usecases/charger_classement_usecase.dart';
import '../../domain/usecases/charger_liste_quiz_usecase.dart';
import '../../domain/usecases/charger_profil_usecase.dart';
import '../../domain/usecases/enregistrer_resultat_usecase.dart';
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
    required this.uid,
    required this.chargerListeQuiz,
    required this.validerReponse,
    required this.chargerProfil,
    required this.chargerClassement,
    required this.enregistrerResultat,
    required this.onDeconnexion,
    required this.nomUtilisateur,
    required this.emailUtilisateur,
    required this.onModifierNom,
  });

  final String uid;
  final ChargerListeQuizUseCase chargerListeQuiz;
  final ValiderReponseUseCase validerReponse;
  final ChargerProfilUsecase chargerProfil;
  final ChargerClassementUseCase chargerClassement;
  final EnregistrerResultatUseCase enregistrerResultat;
  final VoidCallback onDeconnexion;
  final String nomUtilisateur;
  final String emailUtilisateur;
  final Future<void> Function(String nom) onModifierNom;

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _ongletActuel = 0;
  List<Quiz> _quizzes = [];
  ProfilUtilisateur? _profil;
  List<ProfilUtilisateur> _classement = [];
  bool _chargement = true;
  StreamSubscription<List<Quiz>>? _quizzesSubscription;

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
    _quizzesSubscription = widget.chargerListeQuiz.watch().listen((quizzes) {
      if (!mounted) return;
      setState(() {
        _quizzes = quizzes;
      });
    });
    _chargerTout();
  }

  @override
  void dispose() {
    _quizzesSubscription?.cancel();
    super.dispose();
  }

  Future<void> _chargerTout() async {
    final resultats = await Future.wait([
      widget.chargerListeQuiz.call(),
      widget.chargerProfil.call(widget.uid),
      widget.chargerClassement.call(limit: 20),
    ]);

    if (!mounted) return;
    setState(() {
      _quizzes = resultats[0] as List<Quiz>;
      final profilCharge = resultats[1] as ProfilUtilisateur?;
      _profil = profilCharge == null
          ? ProfilUtilisateur(
              uid: widget.uid,
              nom: widget.nomUtilisateur,
              email: widget.emailUtilisateur,
              quizJoues: 0,
              meilleureSerie: 0,
              tauxReussite: 0,
              historique: const [],
            )
          : profilCharge.copyWith(
              nom: profilCharge.nom.isEmpty
                  ? widget.nomUtilisateur
                  : profilCharge.nom,
              email: profilCharge.email.isEmpty
                  ? widget.emailUtilisateur
                  : profilCharge.email,
            );
      _classement = resultats[2] as List<ProfilUtilisateur>;
      _chargement = false;
    });
  }

  Future<void> _rafraichirProfilEtClassement() async {
    final profil = await widget.chargerProfil.call(widget.uid);
    final classement = await widget.chargerClassement.call(limit: 20);
    if (!mounted) return;
    setState(() {
      _profil = profil;
      _classement = classement;
    });
  }

  void _changerOnglet(int index) => setState(() => _ongletActuel = index);

  Future<void> _editerProfil() async {
    final controller = TextEditingController(text: _profil?.nom);
    final nom = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Modifier le nom'),
        content: TextField(
          controller: controller,
          autofocus: true,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(labelText: 'Nom'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(controller.text.trim()),
            child: const Text('Enregistrer'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (!mounted || nom == null || nom.isEmpty) return;
    try {
      await widget.onModifierNom(nom);
      if (!mounted) return;
      setState(() => _profil = _profil?.copyWith(nom: nom));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Impossible de modifier le nom.')),
      );
    }
  }

  void _demarrerQuiz(Quiz quiz) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => QuizFlowScreen(
          quiz: quiz,
          validerReponse: widget.validerReponse,
          onTerminer: () => Navigator.of(context).pop(),
          onQuizTermine: (score, totalQuestions) async {
            await widget.enregistrerResultat.call(
              ResultatQuiz(
                quizId: quiz.quizId,
                joueur: widget.uid,
                score: score,
                date: DateTime.now(),
              ),
              titreQuiz: quiz.titre,
              totalQuestions: totalQuestions,
            );
            await _rafraichirProfilEtClassement();
          },
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
          nomUtilisateur: _profil?.nom ?? '',
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
          podium: _classement
              .take(3)
              .toList()
              .asMap()
              .entries
              .map(
                (e) => JoueurClassement(
                  uid: e.value.uid,
                  rang: e.key + 1,
                  nom: e.value.nom,
                  points: e.value.quizJoues,
                ),
              )
              .toList(),
          classement: _classement
              .skip(3)
              .toList()
              .asMap()
              .entries
              .map(
                (e) => JoueurClassement(
                  uid: e.value.uid,
                  rang: e.key + 4,
                  nom: e.value.nom,
                  points: e.value.quizJoues,
                ),
              )
              .toList(),
          onChangerOnglet: _changerOnglet,
          uidUtilisateurActuel: widget.uid,
        ),
        ProfileScreen(
          nom: _profil?.nom ?? '',
          email: _profil?.email ?? '',
          quizJoues: _profil?.quizJoues ?? 0,
          meilleureSerie: _profil?.meilleureSerie ?? 0,
          tauxReussite: _profil?.tauxReussite ?? 0,
          historique: (_profil?.historique ?? [])
              .map(
                (h) => HistoriqueItemData(
                  categorie: '',
                  titre: h.titre,
                  quandEtDuree: h.date.toLocal().toString(),
                  pourcentage: h.score,
                  icone: Icons.quiz,
                  couleur: AppColors.primaryBlue,
                ),
              )
              .toList(),
          onEditer: _editerProfil,
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
