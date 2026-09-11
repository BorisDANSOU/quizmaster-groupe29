import 'package:go_router/go_router.dart';
import 'package:quizmaster_mobile/core/config/route_name.dart';
import 'package:quizmaster_mobile/features/auth/presentation/register_page.dart';
import 'package:quizmaster_mobile/features/auth/presentation/sign_in_page.dart';
import 'package:quizmaster_mobile/features/profile/presentation/profile_page.dart';
import 'package:quizmaster_mobile/features/quiz/presentation/quiz_page.dart';

final GoRouter routes = GoRouter(
  initialLocation: "/sign-in",
  routes: <RouteBase>[
    // Main app
    GoRoute(
      name: RouteName.home,
      path: "/",
      builder: (context, state) => SignInPage(),
    ),
    GoRoute(
      name: RouteName.quiz,
      path: "/quiz",
      builder: (context, state) => QuizPage(),
    ),
    GoRoute(
      name: RouteName.profile,
      path: "/profile",
      builder: (context, state) => ProfilePage(),
    ),

    // Authentication
    GoRoute(
      name: RouteName.signIn,
      path: "/sign-in",
      builder: (context, state) => SignInPage(),
    ),
    GoRoute(
      name: RouteName.register,
      path: "/register",
      builder: (context, state) => RegisterPage(),
    ),
  ],
);
