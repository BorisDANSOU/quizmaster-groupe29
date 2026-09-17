import '../entities/quiz.dart';
import '../repositories/quiz_repository.dart';

class ChargerListeQuizUseCase {
  const ChargerListeQuizUseCase(this._quizRepository);

  final QuizRepository _quizRepository;

  Future<List<Quiz>> call() {
    return _quizRepository.getQuizzes();
  }

  Stream<List<Quiz>> watch() {
    return _quizRepository.watchQuizzes();
  }
}
