import 'package:flutter/material.dart';
import 'presentation/screens/result_screen.dart';

void main() {
  runApp(const ApercuApp());
}

class ApercuApp extends StatelessWidget {
  const ApercuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ResultScreen(
        bonnesReponses: 8,
        totalQuestions: 10,
        onRecommencer: () => debugPrint('Recommencer'),
        onRetourAccueil: () => debugPrint('Retour accueil'),
      ),
    );
  }
}
