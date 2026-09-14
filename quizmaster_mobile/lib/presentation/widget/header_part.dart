import 'package:flutter/material.dart';

class HeaderPart extends StatelessWidget {
  const HeaderPart({super.key, required this.title, required this.onTap});
  final String title;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: .spaceBetween,
      children: [
        Text(title, style: theme.textTheme.headlineSmall),
        InkWell(
          onTap: onTap,
          child: Row(
            children: [
              Text(
                "Tout voir",
                style: TextStyle(color: Colors.blueAccent, fontWeight: .bold),
              ),
              Icon(Icons.arrow_forward_ios, color: Colors.blueAccent, size: 16),
            ],
          ),
        ),
      ],
    );
  }
}
