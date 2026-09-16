import 'package:flutter/material.dart';
import 'presentation/screens/leaderboard_screen.dart';

void main() {
  runApp(const ApercuApp());
}

class ApercuApp extends StatelessWidget {
  const ApercuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LeaderboardScreen(
        podium: const [
          JoueurClassement(uid: '1', rang: 1, nom: 'Alex K.', points: 3120),
          JoueurClassement(uid: '2', rang: 2, nom: 'Sophie L.', points: 2840),
          JoueurClassement(uid: '3', rang: 3, nom: 'Mamadou S.', points: 2680),
        ],
        classement: const [
          JoueurClassement(uid: '4', rang: 4, nom: 'Amina D.', points: 2450),
          JoueurClassement(uid: '5', rang: 5, nom: 'Lucas P.', points: 2380),
          JoueurClassement(uid: '6', rang: 6, nom: 'Sarah B.', points: 2210),
          JoueurClassement(uid: '7', rang: 7, nom: 'Thomas R.', points: 2080),
        ],
        onChangerOnglet: (i) => debugPrint('Onglet: $i'),
      ),
    );
  }
}
