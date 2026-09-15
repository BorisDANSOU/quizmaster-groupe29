import 'package:flutter/material.dart';
import 'presentation/screens/login_screen.dart';

void main() {
  runApp(const ApercuApp());
}

class ApercuApp extends StatelessWidget {
  const ApercuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(
        onConnexion: (email, motDePasse) async {
          debugPrint('Connexion : $email / $motDePasse');
        },
        onConnexionGoogle: () async {
          debugPrint('Connexion Google');
        },
        onNaviguerVersInscription: () {
          debugPrint('Naviguer vers inscription');
        },
        onMotDePasseOublie: () {
          debugPrint('Mot de passe oublie');
        },
      ),
    );
  }
}
