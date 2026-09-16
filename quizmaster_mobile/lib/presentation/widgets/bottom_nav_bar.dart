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
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.borderSoft),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryBlue.withValues(alpha: 0.08),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(_items.length, (index) {
          final actif = index == indexActuel;
          final item = _items[index];
          return Expanded(
            child: GestureDetector(
              onTap: () => onTap(index),
              behavior: HitTestBehavior.opaque,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 10),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: actif ? AppColors.primaryBlueSoft : Colors.transparent,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      item.icone,
                      color: actif
                          ? AppColors.primaryBlue
                          : AppColors.textSecondaryLight,
                      size: 22,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      item.label,
                      style: TextStyle(
                        fontSize: 11,
                        color: actif
                            ? AppColors.primaryBlue
                            : AppColors.textSecondaryLight,
                        fontWeight: actif ? FontWeight.w700 : FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
