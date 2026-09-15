import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Barre de navigation par onglets, partagee par les 4 ecrans principaux
/// (Accueil, Explorer, Classement, Profil).
class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({
    super.key,
    required this.indexActuel,
    required this.onTap,
  });

  final int indexActuel;
  final ValueChanged<int> onTap;

  static const _items = [
    (icone: Icons.home_rounded, label: 'Accueil'),
    (icone: Icons.search_rounded, label: 'Explorer'),
    (icone: Icons.emoji_events_rounded, label: 'Classement'),
    (icone: Icons.person_rounded, label: 'Profil'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFF0F1F3))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(_items.length, (index) {
          final actif = index == indexActuel;
          final item = _items[index];
          return GestureDetector(
            onTap: () => onTap(index),
            behavior: HitTestBehavior.opaque,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  item.icone,
                  color: actif
                      ? AppColors.primaryBlue
                      : AppColors.textSecondaryLight,
                  size: 24,
                ),
                const SizedBox(height: 4),
                Text(
                  item.label,
                  style: TextStyle(
                    fontSize: 11,
                    color: actif
                        ? AppColors.primaryBlue
                        : AppColors.textSecondaryLight,
                    fontWeight: actif ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
