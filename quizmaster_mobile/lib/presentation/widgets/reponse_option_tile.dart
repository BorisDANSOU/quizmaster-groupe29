import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Etat visuel d'une option de reponse pendant le quiz.
enum EtatReponse { neutre, selectionnee, correcte, incorrecte }

class ReponseOptionTile extends StatelessWidget {
  const ReponseOptionTile({
    super.key,
    required this.lettre,
    required this.texte,
    required this.etat,
    required this.onTap,
  });

  final String lettre;
  final String texte;
  final EtatReponse etat;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final (couleurFond, couleurBordure, couleurTexte, icone) = switch (etat) {
      EtatReponse.neutre => (
        AppColors.darkCard,
        AppColors.darkCardBorder,
        Colors.white,
        null,
      ),
      EtatReponse.selectionnee => (
        AppColors.darkCard,
        AppColors.primaryBlue,
        Colors.white,
        null,
      ),
      EtatReponse.correcte => (
        AppColors.success,
        AppColors.success,
        Colors.white,
        Icons.check,
      ),
      EtatReponse.incorrecte => (
        AppColors.danger,
        AppColors.danger,
        Colors.white,
        Icons.close,
      ),
    };

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: couleurFond,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: couleurBordure, width: 1.5),
        ),
        child: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                lettre,
                style: TextStyle(
                  color: couleurTexte,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                texte,
                style: TextStyle(color: couleurTexte, fontSize: 14),
              ),
            ),
            if (icone != null) Icon(icone, color: Colors.white, size: 20),
          ],
        ),
      ),
    );
  }
}
