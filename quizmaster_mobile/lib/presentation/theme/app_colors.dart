import 'package:flutter/material.dart';

/// Couleurs de l'application QuizMaster
class AppColors {
  AppColors._();

  // Fond sombre (Splash, Quiz, Resultat, en-tete Classement)
  static const darkBackground = Color(0xFF0D1220);
  static const darkCard = Color(0xFF1B2436);
  static const darkCardBorder = Color(0xFF2A3548);

  // Fond clair (Connexion, Accueil, Explorer, Profil)
  static const lightBackground = Color(0xFFFFFFFF);
  static const lightSurface = Color(0xFFF5F6F8);

  // Couleur principale
  static const primaryBlue = Color(0xFF3E7BFA);
  static const primaryBlueDark = Color(0xFF2D5FD1);

  // Etats semantiques
  static const success = Color(0xFF22C55E);
  static const danger = Color(0xFFEF4444);

  // Categories
  static const categorieEducation = Color(0xFF22C55E);
  static const categorieSante = Color(0xFFF43F5E);
  static const categorieModeDeVie = Color(0xFFA855F7);
  static const categorieDeveloppement = Color(0xFFF59E0B);

  // Classement (medailles)
  static const or = Color(0xFFFFB800);
  static const argent = Color(0xFFC0C5CE);
  static const bronze = Color(0xFFCD7F32);

  // Textes
  static const textPrimaryDark = Color(0xFFFFFFFF);
  static const textSecondaryDark = Color(0xFF8A93A6);
  static const textPrimaryLight = Color(0xFF111827);
  static const textSecondaryLight = Color(0xFF6B7280);
}
