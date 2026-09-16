import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class MenuRow extends StatelessWidget {
  const MenuRow({
    super.key,
    required this.icone,
    required this.label,
    required this.onTap,
    this.estDanger = false,
  });

  final IconData icone;
  final String label;
  final VoidCallback onTap;
  final bool estDanger;

  @override
  Widget build(BuildContext context) {
    final couleur = estDanger ? AppColors.danger : AppColors.textPrimaryLight;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            Icon(icone, size: 20, color: couleur),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: couleur,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              size: 18,
              color: couleur.withOpacity(0.6),
            ),
          ],
        ),
      ),
    );
  }
}
