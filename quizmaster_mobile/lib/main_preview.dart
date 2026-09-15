import 'package:flutter/material.dart';
import 'presentation/screens/home_screen.dart';
import 'presentation/theme/app_colors.dart';

void main() {
  runApp(const ApercuApp());
}

class ApercuApp extends StatelessWidget {
  const ApercuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(
        nomUtilisateur: 'Alex',
        quizEnCours: const QuizEnCoursData(
          categorie: 'Santé & Bien-être',
          progression: '7/10',
          difficulte: 'Facile',
          couleur: AppColors.categorieSante,
        ),
        categories: const [
          CategorieData(
            nom: 'Education',
            nombreQuiz: 12,
            icone: Icons.school,
            couleur: AppColors.categorieEducation,
          ),
          CategorieData(
            nom: 'Santé',
            nombreQuiz: 10,
            icone: Icons.favorite,
            couleur: AppColors.categorieSante,
          ),
          CategorieData(
            nom: 'Mode de vie',
            nombreQuiz: 8,
            icone: Icons.auto_awesome,
            couleur: AppColors.categorieModeDeVie,
          ),
        ],
        quizRecents: [
          QuizRecentData(
            categorie: 'Santé & Bien-être',
            titre: 'Alimentation équilibrée',
            sousTexte: 'Score : 80% • 5 min',
            couleur: AppColors.categorieSante,
            icone: Icons.favorite,
          ),
        ],
        onTapQuizEnCours: () => debugPrint('Continuer quiz'),
        onTapCategorie: (c) => debugPrint('Categorie: ${c.nom}'),
        onTapQuizRecent: (q) => debugPrint('Quiz: ${q.titre}'),
        onTapVoirToutesCategories: () => debugPrint('Voir toutes categories'),
        onTapVoirTousQuizRecents: () => debugPrint('Voir tous quiz recents'),
        onChangerOnglet: (i) => debugPrint('Onglet: $i'),
      ),
    );
  }
}
