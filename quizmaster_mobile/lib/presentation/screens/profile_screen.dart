import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/stat_card.dart';
import '../widgets/historique_row.dart';
import '../widgets/menu_row.dart';
import '../widgets/bottom_nav_bar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({
    super.key,
    required this.nom,
    required this.email,
    required this.quizJoues,
    required this.meilleureSerie,
    required this.tauxReussite,
    required this.historique,
    required this.onEditer,
    required this.onVoirToutHistorique,
    required this.onTapHistorique,
    required this.onParametres,
    required this.onAide,
    required this.onDeconnexion,
    required this.onChangerOnglet,
    this.photoUrl,
  });

  final String nom;
  final String email;
  final int quizJoues;
  final int meilleureSerie;
  final int tauxReussite;
  final List<HistoriqueItemData> historique;
  final VoidCallback onEditer;
  final VoidCallback onVoirToutHistorique;
  final ValueChanged<HistoriqueItemData> onTapHistorique;
  final VoidCallback onParametres;
  final VoidCallback onAide;
  final VoidCallback onDeconnexion;
  final ValueChanged<int> onChangerOnglet;
  final String? photoUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    _buildEnTete(),
                    const SizedBox(height: 20),
                    _buildCarteStats(),
                    const SizedBox(height: 24),
                    _buildSectionTitreHistorique(),
                    const SizedBox(height: 8),
                    _buildCarteHistorique(),
                    const SizedBox(height: 20),
                    _buildCarteMenu(),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            AppBottomNavBar(indexActuel: 3, onTap: onChangerOnglet),
          ],
        ),
      ),
    );
  }

  Widget _buildEnTete() {
    return Row(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: AppColors.lightSurface,
          backgroundImage: photoUrl != null ? NetworkImage(photoUrl!) : null,
          child: photoUrl == null ? const Icon(Icons.person, size: 28) : null,
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                nom,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                email,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondaryLight,
                ),
              ),
            ],
          ),
        ),
        OutlinedButton(
          onPressed: onEditer,
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Color(0xFFE5E7EB)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
          child: const Text(
            'Editer',
            style: TextStyle(fontSize: 12, color: AppColors.primaryBlue),
          ),
        ),
      ],
    );
  }

  Widget _buildCarteStats() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.lightSurface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          StatCard(valeur: '$quizJoues', label: 'Quiz joués'),
          StatCard(valeur: '$meilleureSerie', label: 'Meilleure série'),
          StatCard(valeur: '$tauxReussite%', label: 'Taux de réussite'),
        ],
      ),
    );
  }

  Widget _buildSectionTitreHistorique() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Historique des quiz',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        GestureDetector(
          onTap: onVoirToutHistorique,
          child: const Row(
            children: [
              Text(
                'Tout voir',
                style: TextStyle(fontSize: 12, color: AppColors.primaryBlue),
              ),
              Icon(Icons.chevron_right, size: 14, color: AppColors.primaryBlue),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCarteHistorique() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.lightSurface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: historique
            .map(
              (item) => HistoriqueRow(
                categorie: item.categorie,
                titre: item.titre,
                quandEtDuree: item.quandEtDuree,
                pourcentage: item.pourcentage,
                icone: item.icone,
                couleurIcone: item.couleur,
                couleurScore: item.pourcentage >= 70
                    ? AppColors.success
                    : AppColors.danger,
                onTap: () => onTapHistorique(item),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildCarteMenu() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: AppColors.lightSurface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          MenuRow(
            icone: Icons.settings_outlined,
            label: 'Paramètres',
            onTap: onParametres,
          ),
          const Divider(height: 1, color: Color(0xFFE5E7EB)),
          MenuRow(
            icone: Icons.help_outline,
            label: 'Aide et support',
            onTap: onAide,
          ),
          const Divider(height: 1, color: Color(0xFFE5E7EB)),
          MenuRow(
            icone: Icons.logout,
            label: 'Déconnexion',
            onTap: onDeconnexion,
            estDanger: true,
          ),
        ],
      ),
    );
  }
}

class HistoriqueItemData {
  const HistoriqueItemData({
    required this.categorie,
    required this.titre,
    required this.quandEtDuree,
    required this.pourcentage,
    required this.icone,
    required this.couleur,
  });

  final String categorie;
  final String titre;
  final String quandEtDuree;
  final int pourcentage;
  final IconData icone;
  final Color couleur;
}
