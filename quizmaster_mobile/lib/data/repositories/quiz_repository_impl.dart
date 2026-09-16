import 'package:quizmaster_mobile/domain/entities/question.dart';

import '../../domain/entities/quiz.dart';
import '../../domain/repositories/quiz_repository.dart';
import '../datasources/quiz_local_datasource.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  @override
  Stream<List<Quiz>> watchQuizzes() {
    return FirebaseFirestore.instance
        .collection('quizzes')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map((doc) {
            final data = doc.data();
            return Quiz(
              quizId: data['quizId'],
              titre: data['titre'],
              categorie: data['categorie'],
              difficulte: data['difficulte'],
              questions: (data['questions'] as List)
                  .map(
                    (q) => Question(
                      id: q['id'],
                      enonce: q['enonce'],
                      type: q['type'],
                      options: List<String>.from(q['options']),
                      bonneReponseIndex: q['bonneReponseIndex'],
                      points: q['points'],
                    ),
                  )
                  .toList(),
            );
          }).toList(),
        );
  }
}
