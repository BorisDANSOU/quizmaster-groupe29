import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Styles de texte centralises, pour garder une hierarchie typographique
/// coherente sur tout l'app (titres, corps, labels).
class AppTextStyles {
  AppTextStyles._();

  static const titreEcranSombre = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimaryDark,
  );

  static const titreEcranClair = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimaryLight,
  );

  static const sousTitreSombre = TextStyle(
    fontSize: 14,
    color: AppColors.textSecondaryDark,
  );

  static const sousTitreClair = TextStyle(
    fontSize: 14,
    color: AppColors.textSecondaryLight,
  );

  static const labelPetit = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
  );
}
