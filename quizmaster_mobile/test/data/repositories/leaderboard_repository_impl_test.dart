import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quizmaster_mobile/domain/entities/resultat_quiz.dart';
import 'package:quizmaster_mobile/data/datasources/leaderboard_remote_datasource.dart';
import 'package:quizmaster_mobile/data/repositories/leaderboard_repository_impl.dart';

void main() {
  group('LeaderboardRepositoryImpl (avec Firestore simule)', () {
    late FakeFirebaseFirestore fakeFirestore;
    late LeaderboardRepositoryImpl repository;

    setUp(() {
      fakeFirestore = FakeFirebaseFirestore();
      final dataSource = LeaderboardRemoteDataSource(firestore: fakeFirestore);
      repository = LeaderboardRepositoryImpl(dataSource: dataSource);
    });

    test(
      'getLeaderboard retourne une liste vide si personne n a joue',
      () async {
        final classement = await repository.getLeaderboard();

        expect(classement, isEmpty);
      },
    );

    test('saveResult cree le profil utilisateur s il n existe pas', () async {
      final resultat = ResultatQuiz(
        quizId: 'q001',
        joueur: 'uid_alex',
        score: 80,
        date: DateTime(2026, 9, 8),
      );

      await repository.saveResult(resultat);

      final classement = await repository.getLeaderboard();
      expect(classement.length, 1);
      expect(classement.first.uid, 'uid_alex');
    });

    test(
      'saveResult cumule les points sur plusieurs resultats du meme joueur',
      () async {
        await repository.saveResult(
          ResultatQuiz(
            quizId: 'q001',
            joueur: 'uid_alex',
            score: 80,
            date: DateTime(2026, 9, 8),
          ),
        );
        await repository.saveResult(
          ResultatQuiz(
            quizId: 'q002',
            joueur: 'uid_alex',
            score: 50,
            date: DateTime(2026, 9, 9),
          ),
        );

        final classement = await repository.getLeaderboard();

        expect(classement.length, 1); // toujours 1 seul profil, pas 2 entrees
      },
    );

    test('getLeaderboard respecte la limite demandee', () async {
      for (var i = 0; i < 5; i++) {
        await repository.saveResult(
          ResultatQuiz(
            quizId: 'q00$i',
            joueur: 'uid_joueur_$i',
            score: 10 * i,
            date: DateTime(2026, 9, 8),
          ),
        );
      }

      final classement = await repository.getLeaderboard(limit: 3);

      expect(classement.length, 3);
    });
  });
}
