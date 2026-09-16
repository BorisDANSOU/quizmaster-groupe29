import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/quiz.dart';
import '../../data/repositories/quiz_repository_impl.dart';
import '../../data/datasources/quiz_local_datasource.dart';

final quizRepositoryProvider = Provider(
  (ref) => QuizRepositoryImpl(
    dataSource: const QuizLocalDataSource(assetPath: 'assets/quizzes.json'),
  ),
);

/// Flux temps reel : se met a jour automatiquement des qu'un quiz
/// est publie depuis le CLI, sans recharger manuellement.
final quizzesStreamProvider = StreamProvider<List<Quiz>>((ref) {
  return ref.watch(quizRepositoryProvider).watchQuizzes();
});
