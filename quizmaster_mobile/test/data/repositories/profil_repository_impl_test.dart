import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quizmaster_mobile/domain/entities/profil_utilisateur.dart';
import 'package:quizmaster_mobile/data/datasources/profil_remote_datasource.dart';
import 'package:quizmaster_mobile/data/repositories/profil_repository_impl.dart';

void main() {
  group('ProfilRepositoryImpl (avec Firestore simule)', () {
    late FakeFirebaseFirestore fakeFirestore;
    late ProfilRepositoryImpl repository;

    setUp(() {
      fakeFirestore = FakeFirebaseFirestore();
      final dataSource = ProfilRemoteDataSource(firestore: fakeFirestore);
      repository = ProfilRepositoryImpl(dataSource: dataSource);
    });

    test('getProfile retourne null si le profil n existe pas', () async {
      final profil = await repository.getProfile('uid_inconnu');

      expect(profil, isNull);
    });

    test(
      'createOrUpdateProfile puis getProfile renvoie les bonnes donnees',
      () async {
        final profil = const ProfilUtilisateur(
          uid: 'uid_test',
          nom: 'Alex K.',
          email: 'alex@test.com',
          quizJoues: 5,
          meilleureSerie: 3,
          tauxReussite: 70,
          historique: [],
        );

        await repository.createOrUpdateProfile('uid_test', profil);
        final profilLu = await repository.getProfile('uid_test');

        expect(profilLu, isNotNull);
        expect(profilLu!.nom, 'Alex K.');
        expect(profilLu.quizJoues, 5);
      },
    );

    test(
      'saveHistoryEntry ajoute bien une entree dans la sous-collection',
      () async {
        final entry = HistoriqueQuiz(
          quizId: 'q001',
          titre: 'Bien-etre au quotidien',
          score: 80,
          date: DateTime(2026, 9, 8),
        );

        await repository.saveHistoryEntry('uid_test', entry);
        final historique = await repository.getHistory('uid_test');

        expect(historique.length, 1);
        expect(historique.first.titre, 'Bien-etre au quotidien');
        expect(historique.first.score, 80);
      },
    );

    test(
      'getHistory retourne les entrees triees par date decroissante',
      () async {
        await repository.saveHistoryEntry(
          'uid_test',
          HistoriqueQuiz(
            quizId: 'q001',
            titre: 'Ancien quiz',
            score: 50,
            date: DateTime(2026, 1, 1),
          ),
        );
        await repository.saveHistoryEntry(
          'uid_test',
          HistoriqueQuiz(
            quizId: 'q002',
            titre: 'Quiz recent',
            score: 90,
            date: DateTime(2026, 9, 8),
          ),
        );

        final historique = await repository.getHistory('uid_test');

        expect(historique.length, 2);
        expect(
          historique.first.titre,
          'Quiz recent',
        ); // le plus recent en premier
      },
    );
  });
}
