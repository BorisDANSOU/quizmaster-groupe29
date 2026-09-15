import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Champ de texte reutilisable, avec icone, label flottant et
/// support optionnel d'un bouton pour afficher/masquer le mot de passe.
class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.icon,
    this.obscureText = false,
    this.onToggleObscure,
    this.keyboardType,
    this.errorText,
  });

  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final bool obscureText;
  final VoidCallback? onToggleObscure;
  final TextInputType? keyboardType;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: const TextStyle(color: AppColors.textPrimaryLight, fontSize: 15),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: AppColors.textSecondaryLight),
        prefixIcon: Icon(icon, color: AppColors.textSecondaryLight, size: 20),
        suffixIcon: onToggleObscure != null
            ? IconButton(
                icon: Icon(
                  obscureText
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: AppColors.textSecondaryLight,
                  size: 20,
                ),
                onPressed: onToggleObscure,
              )
            : null,
        filled: true,
        fillColor: AppColors.lightSurface,
        errorText: errorText,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: AppColors.primaryBlue,
            width: 1.5,
          ),
        ),
      ),
    );
  }
}
