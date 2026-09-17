import '../entities/quiz.dart';
import '../repositories/quiz_repository.dart';

class ChargerQuizUseCase {
  const ChargerQuizUseCase(this._quizRepository);

  final QuizRepository _quizRepository;

  Future<Quiz?> call(String quizId) {
    return _quizRepository.getQuizById(quizId);
  }
}
