import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Chip de filtre reutilisable (categorie ou difficulte), avec etat
/// selectionne/non-selectionne. Utilise sur l'ecran Explorer.
class FilterChipCustom extends StatelessWidget {
  const FilterChipCustom({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
        decoration: BoxDecoration(
          color: selected ? AppColors.textPrimaryLight : AppColors.lightSurface,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : AppColors.textPrimaryLight,
          ),
        ),
      ),
    );
  }
}
