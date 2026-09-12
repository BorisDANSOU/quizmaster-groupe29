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

void main() {
  testWidgets('QuizMaster app renders the startup screen', (tester) async {
    await tester.pumpWidget(
      QuizMasterApp(
        authRepository: AuthRepositoryImpl(dataSource: AuthRemoteDataSource()),
        quizRepository: QuizRepositoryImpl(
          dataSource: const QuizLocalDataSource(assetPath: 'assets/quizzes.json'),
        ),
        profilRepository: ProfilRepositoryImpl(
          dataSource: ProfilRemoteDataSource(),
        ),
        leaderboardRepository: LeaderboardRepositoryImpl(
          dataSource: LeaderboardRemoteDataSource(),
        ),
      ),
    );

    expect(find.text('Connexion'), findsAtLeastNWidgets(1));
  });
}
