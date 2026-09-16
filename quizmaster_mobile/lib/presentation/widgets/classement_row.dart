import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Une ligne du classement, pour les rangs au-dela du podium (4eme et plus).
class ClassementRow extends StatelessWidget {
  const ClassementRow({
    super.key,
    required this.rang,
    required this.nom,
    required this.points,
    this.photoUrl,
    this.estUtilisateurActuel = false,
  });

  final int rang;
  final String nom;
  final int points;
  final String? photoUrl;
  final bool estUtilisateurActuel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
      decoration: estUtilisateurActuel
          ? BoxDecoration(
              color: AppColors.primaryBlue.withOpacity(0.06),
              borderRadius: BorderRadius.circular(10),
            )
          : null,
      child: Row(
        children: [
          SizedBox(
            width: 24,
            child: Text(
              '$rang',
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondaryLight,
              ),
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.lightSurface,
            backgroundImage: photoUrl != null ? NetworkImage(photoUrl!) : null,
            child: photoUrl == null ? const Icon(Icons.person, size: 16) : null,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              nom,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
          Text(
            '$points',
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
