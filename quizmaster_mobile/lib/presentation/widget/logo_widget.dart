import 'package:flutter/material.dart';

TextStyle textStyle = const TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.normal,
  color: Colors.grey,
);

class LogoWidget extends StatelessWidget {
  const LogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        Icons.school,
        size: 60,
        color: Theme.of(context).colorScheme.onPrimary,
      ),
    );
  }
}
