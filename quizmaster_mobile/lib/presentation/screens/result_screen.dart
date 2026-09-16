import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Ecran affiche a la fin d'un quiz : score final, pourcentage,
/// et repartition bonnes/mauvaises reponses.
class ResultScreen extends StatelessWidget {
  const ResultScreen({
    super.key,
    required this.bonnesReponses,
    required this.totalQuestions,
    required this.onRecommencer,
    required this.onRetourAccueil,
  });

  final int bonnesReponses;
  final int totalQuestions;
  final VoidCallback onRecommencer;
  final VoidCallback onRetourAccueil;

  int get _mauvaisesReponses => totalQuestions - bonnesReponses;
  int get _pourcentage => totalQuestions == 0
      ? 0
      : ((bonnesReponses / totalQuestions) * 100).round();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Spacer(flex: 2),
              _buildTrophee(),
              const SizedBox(height: 24),
              const Text(
                'Bravo !',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Tu as terminé ce quiz avec succès.',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondaryDark,
                ),
              ),
              const SizedBox(height: 32),
              _buildCarteScore(),
              const SizedBox(height: 24),
              _buildDetailReponses(),
              const Spacer(flex: 3),
              _buildBoutons(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTrophee() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.darkCard,
      ),
      child: const Icon(Icons.emoji_events, color: AppColors.or, size: 52),
    );
  }

  Widget _buildCarteScore() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          RichText(
            text: TextSpan(
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.success,
              ),
              children: [
                TextSpan(
                  text: '$bonnesReponses',
                  style: const TextStyle(fontSize: 40),
                ),
                TextSpan(
                  text: '/$totalQuestions',
                  style: const TextStyle(fontSize: 22),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$_pourcentage%',
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondaryLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailReponses() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildIndicateur(
          icone: Icons.check_circle,
          couleur: AppColors.success,
          label: 'Bonnes réponses',
          valeur: bonnesReponses,
        ),
        const SizedBox(width: 32),
        _buildIndicateur(
          icone: Icons.cancel,
          couleur: AppColors.danger,
          label: 'Mauvaises réponses',
          valeur: _mauvaisesReponses,
        ),
      ],
    );
  }

  Widget _buildIndicateur({
    required IconData icone,
    required Color couleur,
    required String label,
    required int valeur,
  }) {
    return Row(
      children: [
        Icon(icone, color: couleur, size: 18),
        const SizedBox(width: 6),
        Text(
          'label',
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textSecondaryDark,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          '$valeur',
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildBoutons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: onRecommencer,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Recommencer',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: OutlinedButton(
            onPressed: onRetourAccueil,
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.darkCardBorder),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Text(
              'Retour à l\'accueil',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
