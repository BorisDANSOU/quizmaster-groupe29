import 'package:flutter/material.dart';

class ListtileWidget extends StatelessWidget {
  const ListtileWidget({
    super.key,
    this.title,
    required this.subtitle,
    required this.progress,
    required this.icon,
    required this.color,
  });
  final String? title;
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
            Expanded(
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: .1),
                      borderRadius: .circular(8),
                    ),
                    padding: .all(12),
                    child: Icon(icon, color: color),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: .start,
                      children: [
                        Text(
                          title?.toUpperCase() ?? "",
                          style: TextStyle(
                            fontWeight: .bold,
                            fontSize: 12,
                            color: color.withValues(alpha: 0.8),
                          ),
                        ),
                        Text(
                          subtitle,
                          maxLines: 1,
                          style: TextStyle(
                            fontWeight: .bold,
                            fontSize: 16,

                            overflow: .ellipsis,
                          ),
                        ),
                        Text(progress, style: theme.textTheme.bodyLarge),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Icon(Icons.arrow_forward_ios, color: theme.colorScheme.secondary),
          ],
        ),
      ),
    );
  }
}
