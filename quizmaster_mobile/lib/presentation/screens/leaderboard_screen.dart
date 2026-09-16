import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/podium_item.dart';
import '../widgets/classement_row.dart';
import '../widgets/bottom_nav_bar.dart';

/// Ecran Classement global : podium des 3 premiers (fond sombre),
/// suivi de la liste des autres joueurs (fond clair).
class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({
    super.key,
    required this.podium,
    required this.classement,
    required this.onChangerOnglet,
    this.uidUtilisateurActuel,
  });

  final List<JoueurClassement> podium; // exactement 3 elements attendus
  final List<JoueurClassement> classement; // rang 4 et au-dela
  final ValueChanged<int> onChangerOnglet;
  final String? uidUtilisateurActuel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildEnTeteSombre(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          const SizedBox(height: 16),
                          ...classement.map(
                            (joueur) => ClassementRow(
                              rang: joueur.rang,
                              nom: joueur.nom,
                              points: joueur.points,
                              photoUrl: joueur.photoUrl,
                              estUtilisateurActuel:
                                  joueur.uid == uidUtilisateurActuel,
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            AppBottomNavBar(indexActuel: 2, onTap: onChangerOnglet),
          ],
        ),
      ),
    );
  }

  Widget _buildEnTeteSombre() {
    // On suppose que podium[0] = 1ere place, podium[1] = 2eme, podium[2] = 3eme
    final premier = podium.isNotEmpty ? podium[0] : null;
    final deuxieme = podium.length > 1 ? podium[1] : null;
    final troisieme = podium.length > 2 ? podium[2] : null;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
      decoration: const BoxDecoration(
        color: AppColors.darkBackground,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.public, color: Colors.white, size: 18),
              SizedBox(width: 8),
              Text(
                'Classement global',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Les meilleurs joueurs de la communauté',
            style: TextStyle(fontSize: 12, color: AppColors.textSecondaryDark),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (deuxieme != null)
                PodiumItem(
                  rang: 2,
                  nom: deuxieme.nom,
                  points: deuxieme.points,
                  photoUrl: deuxieme.photoUrl,
                ),
              if (premier != null)
                PodiumItem(
                  rang: 1,
                  nom: premier.nom,
                  points: premier.points,
                  photoUrl: premier.photoUrl,
                ),
              if (troisieme != null)
                PodiumItem(
                  rang: 3,
                  nom: troisieme.nom,
                  points: troisieme.points,
                  photoUrl: troisieme.photoUrl,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class JoueurClassement {
  const JoueurClassement({
    required this.uid,
    required this.rang,
    required this.nom,
    required this.points,
    this.photoUrl,
  });

  final String uid;
  final int rang;
  final String nom;
  final int points;
  final String? photoUrl;
}
