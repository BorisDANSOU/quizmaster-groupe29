import 'package:flutter/material.dart';

class CategoryWidget extends StatelessWidget {
  const CategoryWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const .symmetric(horizontal: 22, vertical: 16),
        child: Column(
          spacing: 6,
          children: [
            // Logo
            Container(
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: .circular(8),
              ),
              padding: .all(12),
              child: Icon(icon, color: color, size: 28),
            ),
            Text(title, style: TextStyle(fontWeight: .bold)),
            Text(subtitle, style: theme.textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}
