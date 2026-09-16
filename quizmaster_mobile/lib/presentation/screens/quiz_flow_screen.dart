import 'package:flutter/material.dart';
import '../../domain/entities/quiz.dart';
import '../../domain/usecases/valider_reponse_usecase.dart';
import 'quiz_screen.dart';
import 'result_screen.dart';

/// Gere le deroulement complet d'un quiz reel : question par question,
/// puis affiche le resultat final. Utilise ValiderReponseUseCase pour
/// la logique de correction (pas de comparaison faite ici directement).
class QuizFlowScreen extends StatefulWidget {
  const QuizFlowScreen({
    super.key,
    required this.quiz,
    required this.validerReponse,
    required this.onTerminer,
  });

  final Quiz quiz;
  final ValiderReponseUseCase validerReponse;
  final VoidCallback onTerminer;

  @override
  State<QuizFlowScreen> createState() => _QuizFlowScreenState();
}

class _QuizFlowScreenState extends State<QuizFlowScreen> {
  int _indexQuestion = 0;
  int _bonnesReponses = 0;
  bool _quizTermine = false;

  void _repondre(int index) {
    final question = widget.quiz.questions[_indexQuestion];
    if (widget.validerReponse.call(question, index)) {
      _bonnesReponses++;
    }
  }

  void _questionSuivante() {
    if (_indexQuestion < widget.quiz.questions.length - 1) {
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
        totalQuestions: widget.quiz.questions.length,
        onRecommencer: _recommencer,
        onRetourAccueil: widget.onTerminer,
      );
    }

    final question = widget.quiz.questions[_indexQuestion];
    return QuizScreen(
      categorie: widget.quiz.categorie,
      numeroQuestion: _indexQuestion + 1,
      totalQuestions: widget.quiz.questions.length,
      enonce: question.enonce,
      options: question.options,
      bonneReponseIndex: question.bonneReponseIndex,
      onReponseSelectionnee: _repondre,
      onQuestionSuivante: _questionSuivante,
      onFermer: widget.onTerminer,
    );
  }
}
