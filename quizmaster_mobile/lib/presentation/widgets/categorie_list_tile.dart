import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class CategorieListTile extends StatelessWidget {
  const CategorieListTile({
    super.key,
    required this.nom,
    required this.resume,
    required this.icone,
    required this.couleur,
    required this.onTap,
  });

  final String nom;
  final String resume;
  final IconData icone;
  final Color couleur;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.lightSurface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: couleur,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icone, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nom,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    resume,
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
