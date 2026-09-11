import 'package:go_router/go_router.dart';
import 'package:quizmaster_mobile/presentation/screens/home_screen.dart';
import 'package:quizmaster_mobile/presentation/screens/login_screen.dart';
import 'package:quizmaster_mobile/presentation/screens/profile_screen.dart';
import 'package:quizmaster_mobile/presentation/screens/quiz_screen.dart';
import 'package:quizmaster_mobile/presentation/screens/result_screen.dart';
import 'package:quizmaster_mobile/presentation/screens/signup_screen.dart';
import 'package:quizmaster_mobile/presentation/screens/splash_screen.dart';

final GoRouter routes = GoRouter(
  initialLocation: "/splash",
  routes: <RouteBase>[
    GoRoute(path: '/splash', builder: (context, state) => const SplashScreen()),
    GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
    GoRoute(path: '/quiz', builder: (context, state) => const QuizScreen()),
    GoRoute(path: "/result", builder: (context, state) => const ResultScreen()),
    GoRoute(
      path: "/profile",
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(path: "/login", builder: (context, state) => const LoginScreen()),
    GoRoute(path: "/signup", builder: (context, state) => const SignupScreen()),
  ],
);
