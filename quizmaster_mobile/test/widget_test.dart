import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:quizmaster_mobile/data/datasources/auth_remote_datasource.dart';
import 'package:quizmaster_mobile/data/datasources/leaderboard_remote_datasource.dart';
import 'package:quizmaster_mobile/data/datasources/profil_remote_datasource.dart';
import 'package:quizmaster_mobile/data/datasources/quiz_local_datasource.dart';
import 'package:quizmaster_mobile/data/repositories/auth_repository_impl.dart';
import 'package:quizmaster_mobile/data/repositories/leaderboard_repository_impl.dart';
import 'package:quizmaster_mobile/data/repositories/profil_repository_impl.dart';
import 'package:quizmaster_mobile/data/repositories/quiz_repository_impl.dart';
import 'package:quizmaster_mobile/main.dart';
import 'package:quizmaster_mobile/presentation/screens/splash_screen.dart';

void main() {
  testWidgets('QuizMaster app renders the startup screen', (tester) async {
    // Simule Firebase Auth ET Firestore, sans jamais toucher au vrai Firebase.
    final fakeFirestore = FakeFirebaseFirestore();
    final authRemoteDataSource = AuthRemoteDataSource(
      firebaseAuth: MockFirebaseAuth(),
    );

    await tester.pumpWidget(
      QuizMasterApp(
        authRepository: AuthRepositoryImpl(dataSource: authRemoteDataSource),
        quizRepository: QuizRepositoryImpl(
          dataSource: const QuizLocalDataSource(
            assetPath: 'assets/quizzes.json',
          ),
        ),
        profilRepository: ProfilRepositoryImpl(
          dataSource: ProfilRemoteDataSource(firestore: fakeFirestore),
        ),
        leaderboardRepository: LeaderboardRepositoryImpl(
          dataSource: LeaderboardRemoteDataSource(firestore: fakeFirestore),
        ),
      ),
    );

    await tester.pump();
    expect(find.byType(SplashScreen), findsOneWidget);

    await tester.pump(const Duration(seconds: 2));

    expect(find.text('Se connecter'), findsOneWidget);
    expect(find.text('Bienvenue !'), findsOneWidget);
  });
}
