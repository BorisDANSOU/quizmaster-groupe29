import '../entities/question.dart';

class ValiderReponseUseCase {
  const ValiderReponseUseCase();

  bool call(Question question, int reponseIndex) {
    return question.bonneReponseIndex == reponseIndex;
  }
}
