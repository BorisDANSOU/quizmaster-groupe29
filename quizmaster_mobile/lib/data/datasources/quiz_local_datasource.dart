import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../../domain/entities/quiz.dart';

class QuizLocalDataSource {
  const QuizLocalDataSource({this.assetPath = 'assets/quizzes.json'});

  final String assetPath;

  Future<List<Quiz>> loadQuizzes() async {
    try {
      final raw = await rootBundle.loadString(assetPath);
      final decoded = jsonDecode(raw);

      List<dynamic> quizzesList = const <dynamic>[];
      if (decoded is List) {
        quizzesList = decoded;
      } else if (decoded is Map && decoded['quizzes'] is List) {
        quizzesList = decoded['quizzes'] as List;
      }

      return quizzesList
          .map(
            (entry) => Quiz.fromJson(Map<String, dynamic>.from(entry as Map)),
          )
          .toList();
    } on FlutterError {
      return const <Quiz>[];
    } on FormatException {
      return const <Quiz>[];
    }
  }

  Future<Quiz?> getQuizById(String quizId) async {
    final quizzes = await loadQuizzes();
    try {
      return quizzes.firstWhere((quiz) => quiz.quizId == quizId);
    } catch (_) {
      return null;
    }
  }

  Future<List<Quiz>> searchQuizzes({
    String? query,
    String? category,
    String? difficulty,
  }) async {
    final quizzes = await loadQuizzes();
    final normalizedQuery = query?.trim().toLowerCase();

    return quizzes.where((quiz) {
      final title = quiz.titre.toLowerCase();
      final quizCategory = quiz.categorie.toLowerCase();
      final quizDifficulty = quiz.difficulte.toLowerCase();

      final matchesQuery =
          normalizedQuery == null ||
          normalizedQuery.isEmpty ||
          title.contains(normalizedQuery);
      final matchesCategory =
          category == null ||
          category.isEmpty ||
          quizCategory == category.toLowerCase();
      final matchesDifficulty =
          difficulty == null ||
          difficulty.isEmpty ||
          quizDifficulty == difficulty.toLowerCase();

      return matchesQuery && matchesCategory && matchesDifficulty;
    }).toList();
  }
}
