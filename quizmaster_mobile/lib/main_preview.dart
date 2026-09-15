import 'package:flutter/material.dart';
import 'presentation/screens/signup_screen.dart';

void main() {
  runApp(const ApercuApp());
}

class ApercuApp extends StatelessWidget {
  const ApercuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SignupScreen(
        onInscription: (nom, email, motDePasse) async {
          debugPrint('Inscription : $nom / $email / $motDePasse');
        },
        onNaviguerVersConnexion: () {
          debugPrint('Naviguer vers connexion');
        },
      ),
    );
  }
}
