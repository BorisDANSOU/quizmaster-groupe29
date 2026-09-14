import 'package:go_router/go_router.dart';
import 'package:quizmaster_mobile/core/config/router_name.dart';
import 'package:quizmaster_mobile/core/utils/setting.dart';
import 'package:quizmaster_mobile/presentation/screens/explore_screen.dart';
import 'package:quizmaster_mobile/presentation/screens/home_screen.dart';
import 'package:quizmaster_mobile/presentation/screens/home_shell.dart';
import 'package:quizmaster_mobile/presentation/screens/leaderboard_screen.dart';
import 'package:quizmaster_mobile/presentation/screens/login_screen.dart';
import 'package:quizmaster_mobile/presentation/screens/profile_screen.dart';
import 'package:quizmaster_mobile/presentation/screens/quiz_screen.dart';
import 'package:quizmaster_mobile/presentation/screens/result_screen.dart';
import 'package:quizmaster_mobile/presentation/screens/signup_screen.dart';
import 'package:quizmaster_mobile/presentation/screens/splash_screen.dart';

final GoRouter routes = GoRouter(
  initialLocation: "/home",
  // redirect: (context, state) {
  //   if (!Setting.isAuthenticated) return "/login";
  //   if (Setting.isLoading) return "/splash";
  //   return "/home";
  // },
  routes: <RouteBase>[
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return HomeShell(navigationShell: navigationShell);
      },

      branches: [
        // 1 tab
        StatefulShellBranch(
          routes: [
            GoRoute(
              name: RouterName.home,
              path: '/home',
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),

        // 2 tab
        StatefulShellBranch(
          routes: [
            GoRoute(
              name: RouterName.explore,
              path: '/explore',
              builder: (context, state) => const ExploreScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              name: RouterName.leaderboard,
              path: "/leaderboard",
              builder: (context, state) => const LeaderboardScreen(),
            ),
          ],
        ),
        // 4 tab
        StatefulShellBranch(
          routes: [
            GoRoute(
              name: RouterName.profile,
              path: "/profile",
              builder: (context, state) => const ProfileScreen(),
            ),
          ],
        ),
      ],
    ),

    GoRoute(
      name: RouterName.splash,
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),

    GoRoute(
      name: RouterName.result,
      path: "/result",
      builder: (context, state) => const ResultScreen(),
    ),
    GoRoute(
      name: RouterName.quiz,
      path: "/quiz",
      builder: (context, state) => const QuizScreen(),
    ),

    GoRoute(
      name: RouterName.login,
      path: "/login",
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      name: RouterName.signup,
      path: "/signup",
      builder: (context, state) => const SignupScreen(),
    ),
  ],
);
