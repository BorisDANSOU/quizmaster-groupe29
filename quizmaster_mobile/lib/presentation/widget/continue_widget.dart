import 'package:flutter/material.dart';

class ContinueWidget extends StatelessWidget {
  const ContinueWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.progress,
    required this.icon,
    required this.color,
  });
  final String title;
  final String subtitle;
  final String progress;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: .spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: .circular(8),
                  ),
                  padding: .all(12),
                  child: Icon(icon, color: color),
                ),
                SizedBox(width: 12),
                Column(
                  crossAxisAlignment: .start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(fontWeight: .bold, fontSize: 16),
                    ),
                    Text(subtitle, style: theme.textTheme.bodyLarge),
                    Text(progress, style: theme.textTheme.bodyLarge),
                  ],
                ),
              ],
            ),

            Icon(Icons.arrow_forward_ios, color: theme.colorScheme.secondary),
          ],
        ),
      ),
    );
  }
}
