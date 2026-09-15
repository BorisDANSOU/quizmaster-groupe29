import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Carte carree affichant une categorie de quiz (icone + nom + nombre de quiz).
/// Reutilisee sur l'ecran Accueil (grille compacte) et sur Explorer (liste).
class CategorieCard extends StatelessWidget {
  const CategorieCard({
    super.key,
    required this.nom,
    required this.nombreQuiz,
    required this.icone,
    required this.couleur,
    required this.onTap,
  });

  final String nom;
  final int nombreQuiz;
  final IconData icone;
  final Color couleur;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: AppColors.lightSurface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: couleur,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icone, color: Colors.white, size: 22),
            ),
            const SizedBox(height: 8),
            Text(
              nom,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 2),
            Text(
              '$nombreQuiz quiz',
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textSecondaryLight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
