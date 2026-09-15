import 'package:flutter/material.dart';
import 'presentation/screens/quiz_screen.dart';

void main() {
  runApp(const ApercuApp());
}

class ApercuApp extends StatelessWidget {
  const ApercuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: QuizScreen(
        categorie: 'Santé & Bien-être',
        numeroQuestion: 3,
        totalQuestions: 10,
        enonce:
            'Quelle est la durée recommandée d\'une sieste pour un adulte ?',
        options: const [
          '10 à 20 minutes',
          '30 à 60 minutes',
          '1 à 2 heures',
          '3 à 4 heures',
        ],
        bonneReponseIndex: 1,
        onReponseSelectionnee: (index) => debugPrint('Reponse: $index'),
        onQuestionSuivante: () => debugPrint('Question suivante'),
        onFermer: () => debugPrint('Fermer'),
      ),
    );
  }
}
