import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class RichTextWidget extends StatelessWidget {
  const RichTextWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.onSurface,
        ),
        text: "",
        children: [
          TextSpan(text: "Quiz", style: TextStyle(fontSize: 28)),
          TextSpan(
            text: "Master",
            style: TextStyle(
              fontSize: 28,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
