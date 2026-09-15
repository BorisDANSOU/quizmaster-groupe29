import 'package:flutter/material.dart';
import 'presentation/screens/explore_screen.dart';
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
      home: ExploreScreen(
        categories: const [
          CategorieExploreData(
            nom: 'Education',
            resume: '12 quiz • 3 niveaux',
            icone: Icons.school,
            couleur: AppColors.categorieEducation,
          ),
          CategorieExploreData(
            nom: 'Santé & Bien-être',
            resume: '10 quiz • 3 niveaux',
            icone: Icons.favorite,
            couleur: AppColors.categorieSante,
          ),
          CategorieExploreData(
            nom: 'Mode de vie',
            resume: '8 quiz • 3 niveaux',
            icone: Icons.auto_awesome,
            couleur: AppColors.categorieModeDeVie,
          ),
          CategorieExploreData(
            nom: 'Développement personnel',
            resume: '6 quiz • 3 niveaux',
            icone: Icons.person,
            couleur: AppColors.categorieDeveloppement,
          ),
        ],
        onTapCategorie: (c) => debugPrint('Categorie: ${c.nom}'),
        onRetour: () => debugPrint('Retour'),
        onChangerOnglet: (i) => debugPrint('Onglet: $i'),
        onRecherche: (texte) => debugPrint('Recherche: $texte'),
      ),
    );
  }
}
