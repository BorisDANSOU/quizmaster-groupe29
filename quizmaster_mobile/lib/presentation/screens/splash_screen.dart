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
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        widget.onInitialisationTerminee?.call();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.darkBackground,
              Color(0xFF101B2E),
              Color(0xFF122B3D),
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Positioned(
                top: 80,
                left: -30,
                child: _buildGlow(
                  80,
                  const Color(0xFF4F7CFF).withValues(alpha: 0.3),
                ),
              ),
              Positioned(
                bottom: 120,
                right: -20,
                child: _buildGlow(
                  120,
                  const Color(0xFF7C3AED).withValues(alpha: 0.22),
                ),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildLogo(),
                    const SizedBox(height: 24),
                    _buildTitre(),
                    const SizedBox(height: 10),
                    const Text(
                      'Apprends • Teste • Progresse',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondaryDark,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 36),
                    _buildIllustrationLivre(),
                    const SizedBox(height: 32),
                    _buildIndicateurChargement(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGlow(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 104,
      height: 104,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primaryBlue, AppColors.primaryBlueDark],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryBlue.withValues(alpha: 0.45),
            blurRadius: 36,
            spreadRadius: 2,
          ),
        ],
      ),
      child: const Icon(Icons.school_rounded, color: Colors.white, size: 52),
    );
  }

  Widget _buildTitre() {
    return RichText(
      text: const TextSpan(
        style: TextStyle(fontSize: 34, fontWeight: FontWeight.w800),
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
    return Container(
      width: 110,
      height: 110,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: const Icon(
        Icons.auto_stories_rounded,
        size: 68,
        color: AppColors.primaryBlue,
      ),
    );
  }

  Widget _buildIndicateurChargement() {
    return Column(
      children: [
        const SizedBox(
          width: 30,
          height: 30,
          child: CircularProgressIndicator(
            strokeWidth: 2.8,
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryBlue),
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'INITIALISATION',
          style: TextStyle(
            fontSize: 11,
            letterSpacing: 2,
            color: AppColors.textSecondaryDark,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
