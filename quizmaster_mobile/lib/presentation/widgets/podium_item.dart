import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Represente une des 3 premieres places du classement (podium),
/// avec avatar, medaille et couronne pour la 1ere place.
class PodiumItem extends StatelessWidget {
  const PodiumItem({
    super.key,
    required this.rang,
    required this.nom,
    required this.points,
    this.photoUrl,
  });

  final int rang; // 1, 2 ou 3
  final String nom;
  final int points;
  final String? photoUrl;

  Color get _couleurMedaille => switch (rang) {
    1 => AppColors.or,
    2 => AppColors.argent,
    _ => AppColors.bronze,
  };

  double get _tailleAvatar => rang == 1 ? 64 : 52;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (rang == 1) ...[
          const Icon(Icons.emoji_events, color: AppColors.or, size: 22),
          const SizedBox(height: 4),
        ],
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: _tailleAvatar,
              height: _tailleAvatar,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: _couleurMedaille, width: 2.5),
                image: photoUrl != null
                    ? DecorationImage(
                        image: NetworkImage(photoUrl!),
                        fit: BoxFit.cover,
                      )
                    : null,
                color: AppColors.darkCard,
              ),
              child: photoUrl == null
                  ? const Icon(Icons.person, color: Colors.white54)
                  : null,
            ),
            Positioned(
              bottom: -4,
              right: -4,
              child: Container(
                width: 22,
                height: 22,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _couleurMedaille,
                  border: Border.all(color: AppColors.darkBackground, width: 2),
                ),
                child: Text(
                  '$rang',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          nom,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        Text(
          '$points pts',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: _couleurMedaille,
          ),
        ),
      ],
    );
  }
}
