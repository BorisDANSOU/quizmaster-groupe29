import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/categorie_card.dart';
import '../widgets/quiz_recent_card.dart';
import '../widgets/bottom_nav_bar.dart';

/// Ecran d'accueil (Dashboard). Recoit les donnees via constructeur
/// (pas de logique metier ici) : sera alimente par quiz_provider.dart
/// une fois la couche presentation reliee aux usecases.
class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    required this.nomUtilisateur,
    required this.quizEnCours,
    required this.categories,
    required this.quizRecents,
    required this.onTapQuizEnCours,
    required this.onTapCategorie,
    required this.onTapQuizRecent,
    required this.onTapVoirToutesCategories,
    required this.onTapVoirTousQuizRecents,
    required this.onChangerOnglet,
  });

  final String nomUtilisateur;
  final QuizEnCoursData? quizEnCours;
  final List<CategorieData> categories;
  final List<QuizRecentData> quizRecents;
  final VoidCallback onTapQuizEnCours;
  final ValueChanged<CategorieData> onTapCategorie;
  final ValueChanged<QuizRecentData> onTapQuizRecent;
  final VoidCallback onTapVoirToutesCategories;
  final VoidCallback onTapVoirTousQuizRecents;
  final ValueChanged<int> onChangerOnglet;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    _buildEnTete(),
                    const SizedBox(height: 20),
                    if (quizEnCours != null) ...[
                      _buildCarteQuizEnCours(),
                      const SizedBox(height: 24),
                    ],
                    _buildSectionTitre('Catégories', onTapVoirToutesCategories),
                    const SizedBox(height: 12),
                    _buildGrilleCategories(),
                    const SizedBox(height: 24),
                    _buildSectionTitre(
                      'Quiz récents',
                      onTapVoirTousQuizRecents,
                    ),
                    const SizedBox(height: 12),
                    ...quizRecents.map(
                      (quiz) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: QuizRecentCard(
                          categorie: quiz.categorie,
                          titre: quiz.titre,
                          sousTexte: quiz.sousTexte,
                          couleurCategorie: quiz.couleur,
                          icone: quiz.icone,
                          onTap: () => onTapQuizRecent(quiz),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            AppBottomNavBar(indexActuel: 0, onTap: onChangerOnglet),
          ],
        ),
      ),
    );
  }

  Widget _buildEnTete() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Bon Retour',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 2),
            Text(
              'Prêt à relever un nouveau défi ?',
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondaryLight,
              ),
            ),
          ],
        ),
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.lightSurface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.notifications_none_rounded, size: 20),
        ),
      ],
    );
  }

  Widget _buildCarteQuizEnCours() {
    final data = quizEnCours!;
    return GestureDetector(
      onTap: onTapQuizEnCours,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.lightSurface,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: data.couleur,
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Continuer le quiz',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    data.categorie,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondaryLight,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${data.progression} • ${data.difficulte}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondaryLight,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: AppColors.textSecondaryLight,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitre(String titre, VoidCallback onVoirTout) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          titre,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
        GestureDetector(
          onTap: onVoirTout,
          child: const Row(
            children: [
              Text(
                'Tout voir',
                style: TextStyle(fontSize: 13, color: AppColors.primaryBlue),
              ),
              Icon(Icons.chevron_right, size: 16, color: AppColors.primaryBlue),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGrilleCategories() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: categories.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.85,
      ),
      itemBuilder: (context, index) {
        final categorie = categories[index];
        return CategorieCard(
          nom: categorie.nom,
          nombreQuiz: categorie.nombreQuiz,
          icone: categorie.icone,
          couleur: categorie.couleur,
          onTap: () => onTapCategorie(categorie),
        );
      },
    );
  }
}

class QuizEnCoursData {
  const QuizEnCoursData({
    required this.categorie,
    required this.progression,
    required this.difficulte,
    required this.couleur,
  });

  final String categorie;
  final String progression;
  final String difficulte;
  final Color couleur;
}

class CategorieData {
  const CategorieData({
    required this.nom,
    required this.nombreQuiz,
    required this.icone,
    required this.couleur,
  });

  final String nom;
  final int nombreQuiz;
  final IconData icone;
  final Color couleur;
}

class QuizRecentData {
  const QuizRecentData({
    required this.categorie,
    required this.titre,
    required this.sousTexte,
    required this.couleur,
    required this.icone,
  });

  final String categorie;
  final String titre;
  final String sousTexte;
  final Color couleur;
  final IconData icone;
}
