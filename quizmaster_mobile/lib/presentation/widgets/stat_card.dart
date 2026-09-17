import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Une des 3 statistiques affichees en haut du Profil
/// (quiz joues, meilleure serie, taux de reussite).
class StatCard extends StatelessWidget {
  const StatCard({super.key, required this.valeur, required this.label});

  final String valeur;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            valeur,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textSecondaryLight,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
