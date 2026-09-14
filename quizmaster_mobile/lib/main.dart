import 'package:flutter/material.dart';
import 'package:quizmaster_mobile/core/config/app_router.dart';

void main() {
  runApp(const MyApp());
}

final blueColor = const Color.fromARGB(255, 3, 157, 246);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Quiz Master',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: blueColor),
        // Elevated Button theme
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            minimumSize: Size(double.infinity, 55),
            shape: RoundedRectangleBorder(borderRadius: .circular(12)),
            // side: BorderSide()
          ),
        ),
        // Text Button theme
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            // backgroundColor: Theme.of(context).colorScheme.primary,
            minimumSize: Size(double.infinity, 55),
            shape: RoundedRectangleBorder(borderRadius: .circular(12)),
            side: BorderSide(width: 1, color: blueColor),
          ),
        ),
        textTheme: TextTheme(
          titleLarge: TextStyle(fontWeight: .bold, fontSize: 28),
          headlineSmall: TextStyle(fontWeight: .bold, fontSize: 20),
          bodyLarge: TextStyle(
            fontWeight: .normal,
            color: Theme.of(context).colorScheme.onSecondaryContainer,
          ),
        ),
      ),

      darkTheme: ThemeData.dark(useMaterial3: true),
      themeMode: ThemeMode.light,
      routerConfig: routes,
    );
  }
}
