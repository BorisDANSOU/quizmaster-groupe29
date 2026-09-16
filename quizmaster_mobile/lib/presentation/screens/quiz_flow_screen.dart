import 'package:flutter/material.dart';
import 'quiz_screen.dart';
import 'result_screen.dart';

/// Gere le deroulement complet d'un quiz : question par question,
/// puis affiche le resultat final.
class QuizFlowScreen extends StatefulWidget {
  const QuizFlowScreen({super.key, required this.onTerminer});

  final VoidCallback onTerminer;

  @override
  State<QuizFlowScreen> createState() => _QuizFlowScreenState();
}

class _QuestionExemple {
  const _QuestionExemple(this.enonce, this.options, this.bonneReponseIndex);
  final String enonce;
  final List<String> options;
  final int bonneReponseIndex;
}

class _QuizFlowScreenState extends State<QuizFlowScreen> {
  static const _questions = [
    _QuestionExemple(
      'Quelle est la durée recommandée d\'une sieste pour un adulte ?',
      ['10 à 20 minutes', '30 à 60 minutes', '1 à 2 heures', '3 à 4 heures'],
      1,
    ),
    _QuestionExemple(
      'Combien de litres d\'eau un adulte devrait-il boire par jour ?',
      ['0.5 litre', '1.5 à 2 litres', '4 litres'],
      1,
    ),
  ];

  int _indexQuestion = 0;
  int _bonnesReponses = 0;
  bool _quizTermine = false;

  void _repondre(int index) {
    if (index == _questions[_indexQuestion].bonneReponseIndex) {
      _bonnesReponses++;
    }
  }

  void _questionSuivante() {
    if (_indexQuestion < _questions.length - 1) {
      setState(() => _indexQuestion++);
    } else {
      setState(() => _quizTermine = true);
    }
  }

  void _recommencer() {
    setState(() {
      _indexQuestion = 0;
      _bonnesReponses = 0;
      _quizTermine = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_quizTermine) {
      return ResultScreen(
        bonnesReponses: _bonnesReponses,
        totalQuestions: _questions.length,
        onRecommencer: _recommencer,
        onRetourAccueil: widget.onTerminer,
      );
    }

    final question = _questions[_indexQuestion];
    return QuizScreen(
      categorie: 'Santé & Bien-être',
      numeroQuestion: _indexQuestion + 1,
      totalQuestions: _questions.length,
      enonce: question.enonce,
      options: question.options,
      bonneReponseIndex: question.bonneReponseIndex,
      onReponseSelectionnee: _repondre,
      onQuestionSuivante: _questionSuivante,
      onFermer: widget.onTerminer,
    );
  }
}
