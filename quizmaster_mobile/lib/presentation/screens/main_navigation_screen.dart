import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'explore_screen.dart';
import 'leaderboard_screen.dart';
import 'profile_screen.dart';

/// Conteneur des 4 onglets principaux de l'app (Accueil, Explorer,
/// Classement, Profil). Utilise IndexedStack plutot que de recreer
/// l'ecran a chaque changement d'onglet, pour conserver le scroll
/// et l'etat de chaque onglet quand on navigue entre eux.
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({
    super.key,
    required this.onDemarrerQuiz,
    required this.onDeconnexion,
  });

  final VoidCallback onDemarrerQuiz;
  final VoidCallback onDeconnexion;

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _ongletActuel = 0;

  void _changerOnglet(int index) {
    setState(() => _ongletActuel = index);
  }

  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: _ongletActuel,
      children: [
        HomeScreen(
          nomUtilisateur: 'Alex',
          quizEnCours: const QuizEnCoursData(
            categorie: 'Santé & Bien-être',
            progression: '7/10',
            difficulte: 'Facile',
            couleur: Color(0xFFF43F5E),
          ),
          categories: const [
            CategorieData(
              nom: 'Education',
              nombreQuiz: 12,
              icone: Icons.school,
              couleur: Color(0xFF22C55E),
            ),
            CategorieData(
              nom: 'Santé',
              nombreQuiz: 10,
              icone: Icons.favorite,
              couleur: Color(0xFFF43F5E),
            ),
            CategorieData(
              nom: 'Mode de vie',
              nombreQuiz: 8,
              icone: Icons.auto_awesome,
              couleur: Color(0xFFA855F7),
            ),
          ],
          quizRecents: const [
            QuizRecentData(
              categorie: 'Santé & Bien-être',
              titre: 'Alimentation équilibrée',
              sousTexte: 'Score : 80% • 5 min',
              couleur: Color(0xFFF43F5E),
              icone: Icons.favorite,
            ),
          ],
          onTapQuizEnCours: widget.onDemarrerQuiz,
          onTapCategorie: (c) => _changerOnglet(1),
          onTapQuizRecent: (q) => widget.onDemarrerQuiz(),
          onTapVoirToutesCategories: () => _changerOnglet(1),
          onTapVoirTousQuizRecents: () {},
          onChangerOnglet: _changerOnglet,
        ),
        ExploreScreen(
          categories: const [
            CategorieExploreData(
              nom: 'Education',
              resume: '12 quiz • 3 niveaux',
              icone: Icons.school,
              couleur: Color(0xFF22C55E),
            ),
            CategorieExploreData(
              nom: 'Santé & Bien-être',
              resume: '10 quiz • 3 niveaux',
              icone: Icons.favorite,
              couleur: Color(0xFFF43F5E),
            ),
            CategorieExploreData(
              nom: 'Mode de vie',
              resume: '8 quiz • 3 niveaux',
              icone: Icons.auto_awesome,
              couleur: Color(0xFFA855F7),
            ),
            CategorieExploreData(
              nom: 'Développement personnel',
              resume: '6 quiz • 3 niveaux',
              icone: Icons.person,
              couleur: Color(0xFFF59E0B),
            ),
          ],
          onTapCategorie: (c) => widget.onDemarrerQuiz(),
          onRetour: () => _changerOnglet(0),
          onChangerOnglet: _changerOnglet,
          onRecherche: (texte) {},
        ),
        LeaderboardScreen(
          podium: const [
            JoueurClassement(uid: '1', rang: 1, nom: 'Alex K.', points: 3120),
            JoueurClassement(uid: '2', rang: 2, nom: 'Sophie L.', points: 2840),
            JoueurClassement(
              uid: '3',
              rang: 3,
              nom: 'Mamadou S.',
              points: 2680,
            ),
          ],
          classement: const [
            JoueurClassement(uid: '4', rang: 4, nom: 'Amina D.', points: 2450),
            JoueurClassement(uid: '5', rang: 5, nom: 'Lucas P.', points: 2380),
          ],
          onChangerOnglet: _changerOnglet,
          uidUtilisateurActuel: '1',
        ),
        ProfileScreen(
          nom: 'Alex K.',
          email: 'alexk@mail.com',
          quizJoues: 12,
          meilleureSerie: 7,
          tauxReussite: 78,
          historique: const [
            HistoriqueItemData(
              categorie: 'Santé & Bien-être',
              titre: 'Alimentation équilibrée',
              quandEtDuree: 'Aujourd\'hui • 5 min',
              pourcentage: 80,
              icone: Icons.favorite,
              couleur: Color(0xFFF43F5E),
            ),
          ],
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
