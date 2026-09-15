import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Ecran de demarrage : affiche le logo pendant que l'app verifie
/// si une session utilisateur est deja active (auto-connexion).

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, this.onInitialisationTerminee});

  /// Callback appele une fois la verification terminee.
  /// Prendra en parametre l'etat de connexion une fois Firebase branche.
  final VoidCallback? onInitialisationTerminee;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Simule une verification de session ; sera remplace par
    // authStateChanges() de Firebase Auth en Phase 3.
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        widget.onInitialisationTerminee?.call();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 3),
            _buildLogo(),
            const SizedBox(height: 24),
            _buildTitre(),
            const SizedBox(height: 8),
            const Text(
              'Apprends • Teste • Progresse',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textSecondaryDark,
                letterSpacing: 0.5,
              ),
            ),
            const Spacer(flex: 2),
            _buildIllustrationLivre(),
            const Spacer(flex: 3),
            _buildIndicateurChargement(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 96,
      height: 96,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primaryBlue, AppColors.primaryBlueDark],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryBlue.withOpacity(0.4),
            blurRadius: 30,
            spreadRadius: 4,
          ),
        ],
      ),
      child: const Icon(Icons.school_rounded, color: Colors.white, size: 48),
    );
  }

  Widget _buildTitre() {
    return RichText(
      text: const TextSpan(
        style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        children: [
          TextSpan(
            text: 'Quiz',
            style: TextStyle(color: Colors.white),
          ),
          TextSpan(
            text: 'Master',
            style: TextStyle(color: AppColors.primaryBlue),
          ),
        ],
      ),
    );
  }

  Widget _buildIllustrationLivre() {
    // Approximation de l'illustration du livre ouvert avec des icones
    // Flutter, en attendant un vrai asset SVG si le groupe en fournit un.
    return const Icon(
      Icons.auto_stories_rounded,
      size: 80,
      color: AppColors.primaryBlue,
    );
  }

  Widget _buildIndicateurChargement() {
    return Column(
      children: [
        const SizedBox(
          width: 28,
          height: 28,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryBlue),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'INITIALISATION',
          style: const TextStyle(
            fontSize: 11,
            letterSpacing: 2,
            color: AppColors.textSecondaryDark,
          ),
        ),
      ],
    );
  }
}
