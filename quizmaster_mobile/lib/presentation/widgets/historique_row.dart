import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class HistoriqueRow extends StatelessWidget {
  const HistoriqueRow({
    super.key,
    required this.categorie,
    required this.titre,
    required this.quandEtDuree,
    required this.pourcentage,
    required this.icone,
    required this.couleurIcone,
    required this.couleurScore,
    required this.onTap,
  });

  final String categorie;
  final String titre;
  final String quandEtDuree;
  final int pourcentage;
  final IconData icone;
  final Color couleurIcone;
  final Color couleurScore;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: couleurIcone,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icone, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    categorie,
                    style: TextStyle(
                      fontSize: 11,
                      color: couleurIcone,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    titre,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    quandEtDuree,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondaryLight,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '$pourcentage%',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: couleurScore,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
