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
  Future<List<Quiz>> getQuizzes() async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection('quizzes').get();
      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.map((doc) => _mapFirestoreDocToQuiz(doc.data())).toList();
      }
    } catch (e) {
      print('Erreur lors de la récupération des quiz Firestore : $e');
    }
    // Fallback sur le JSON local si Firestore est vide ou inaccessible
    return _dataSource.loadQuizzes();
  }

  @override
  Future<Quiz?> getQuizById(String quizId) async {
    try {
      final doc = await FirebaseFirestore.instance.collection('quizzes').doc(quizId).get();
      if (doc.exists && doc.data() != null) {
        return _mapFirestoreDocToQuiz(doc.data()!);
      }
    } catch (e) {
      print('Erreur lors de la récupération du quiz $quizId sur Firestore : $e');
    }
    return _dataSource.getQuizById(quizId);
  }

  @override
  Future<List<Quiz>> searchQuizzes({
    String? query,
    String? category,
    String? difficulty,
  }) async {
    // On réutilise d'abord tous les quiz de Firebase (ou le fallback local via getQuizzes)
    final tousLesQuiz = await getQuizzes();
    final normalizedQuery = query?.trim().toLowerCase();

    return tousLesQuiz.where((quiz) {
      final title = quiz.titre.toLowerCase();
      final quizCategory = quiz.categorie.toLowerCase();
      final quizDifficulty = quiz.difficulte.toLowerCase();

      final matchesQuery = normalizedQuery == null ||
          normalizedQuery.isEmpty ||
          title.contains(normalizedQuery);
      final matchesCategory = category == null ||
          category.isEmpty ||
          quizCategory == category.toLowerCase();
      final matchesDifficulty = difficulty == null ||
          difficulty.isEmpty ||
          quizDifficulty == difficulty.toLowerCase();

      return matchesQuery && matchesCategory && matchesDifficulty;
    }).toList();
  }

  @override
  Stream<List<Quiz>> watchQuizzes() {
    return FirebaseFirestore.instance
        .collection('quizzes')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => _mapFirestoreDocToQuiz(doc.data()))
              .toList(),
        )
        .handleError((error, stackTrace) {
          print('Erreur lors de l\'écoute Firestore des quiz : $error');
          return _dataSource.loadQuizzes();
        });
  }

  Quiz _mapFirestoreDocToQuiz(Map<String, dynamic> data) {
    return Quiz(
      quizId: data['quizId'] ?? '',
      titre: data['titre'] ?? '',
      categorie: data['categorie'] ?? '',
      difficulte: data['difficulte'] ?? '',
      questions: (data['questions'] as List? ?? [])
          .map(
            (q) => Question(
              id: q['id'] ?? '',
              enonce: q['enonce'] ?? '',
              type: q['type'] ?? 'qcm',
              options: List<String>.from(q['options'] ?? []),
              bonneReponseIndex: (q['bonneReponseIndex'] as num? ?? 0).toInt(),
              points: (q['points'] as num? ?? 10).toInt(),
            ),
          )
          .toList(),
    );
  }
}
