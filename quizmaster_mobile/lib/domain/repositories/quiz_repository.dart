import '../entities/quiz.dart';

abstract class QuizRepository {
  Future<List<Quiz>> getQuizzes();
  Future<Quiz?> getQuizById(String quizId);
  Future<List<Quiz>> searchQuizzes({
    String? query,
    String? category,
    String? difficulty,
  });
}
