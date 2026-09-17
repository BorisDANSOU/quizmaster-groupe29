import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Carte horizontale representant un quiz (recent ou en cours),
/// avec une pastille de couleur, le nom de la categorie, le titre,
/// et un sous-texte (score ou progression).
class QuizRecentCard extends StatelessWidget {
  const QuizRecentCard({
    super.key,
    required this.categorie,
    required this.titre,
    required this.sousTexte,
    required this.couleurCategorie,
    required this.icone,
    required this.onTap,
  });

  final String categorie;
  final String titre;
  final String sousTexte;
  final Color couleurCategorie;
  final IconData icone;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.lightSurface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: couleurCategorie,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icone, color: Colors.white, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    categorie.toUpperCase(),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                      color: couleurCategorie,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    titre,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    sousTexte,
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
}
