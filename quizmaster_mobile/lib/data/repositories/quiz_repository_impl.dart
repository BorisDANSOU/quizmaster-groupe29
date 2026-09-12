import '../../domain/entities/quiz.dart';
import '../../domain/repositories/quiz_repository.dart';
import '../datasources/quiz_local_datasource.dart';

class QuizRepositoryImpl implements QuizRepository {
  QuizRepositoryImpl({QuizLocalDataSource? dataSource})
    : _dataSource = dataSource ?? const QuizLocalDataSource();

  final QuizLocalDataSource _dataSource;

  @override
  Future<List<Quiz>> getQuizzes() {
    return _dataSource.loadQuizzes();
  }

  @override
  Future<Quiz?> getQuizById(String quizId) {
    return _dataSource.getQuizById(quizId);
  }

  @override
  Future<List<Quiz>> searchQuizzes({
    String? query,
    String? category,
    String? difficulty,
  }) {
    return _dataSource.searchQuizzes(
      query: query,
      category: category,
      difficulty: difficulty,
    );
  }
}
