import 'package:flutter/material.dart';
import "package:go_router/go_router.dart";
import 'package:quizmaster_mobile/core/config/router_name.dart';
import 'package:quizmaster_mobile/presentation/widget/logo_widget.dart';
import 'package:quizmaster_mobile/presentation/widget/rich_text_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = "";
  String _password = "";

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainer,
      body: Container(
        padding: .symmetric(horizontal: 12),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: .center,
          mainAxisAlignment: .spaceEvenly,
          children: [
            SizedBox(height: 16),
            // 1. Logo and content
            Container(
              color: Colors.transparent,
              child: Column(
                children: [
                  LogoWidget(),
                  RichTextWidget(), // Row for the three words "Apprendre", "Teste", and "Progresse"
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 8,
                    children: [
                      Text("Apprendre", style: textStyle),
                      Text("Teste", style: textStyle),
                      Text("Progresse", style: textStyle),
                    ],
                  ),
                ],
              ),
            ),

            // 2. Formulaire
            Form(
              key: _formKey,
              child: Column(
                children: [
                  // Text of welcoming
                  Text(
                    "Bienvenue !",
                    style: TextStyle(fontSize: 28, fontWeight: .bold),
                  ),
                  Text(
                    "Connecte-toi pour acceder a ton espace et reveler de nouveaux defis.",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: .normal,
                      color: theme.colorScheme.secondary,
                    ),
                  ),
                  SizedBox(height: 45),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Adresse e-mail",
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Enter your username";
                      }
                      if (!value.contains("@")) {
                        return 'ce champ doit containir "@"';
                      }

                      return null;
                    },
                    onSaved: ((newValue) {
                      _email = newValue ?? "";
                    }),
                  ),

                  SizedBox(height: 16),

                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Mot de pass",
                      prefixIcon: Icon(Icons.lock_outline),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Enter your password";
                      }
                      if (value.length < 6) {
                        return 'Minimum de 6 chaine de caractere';
                      }

                      return null;
                    },
                    onSaved: ((newValue) {
                      _password = newValue ?? "";
                    }),
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Spacer(),
                      Text(
                        "Mot de passe oublie?",
                        textAlign: .end,
                        style: TextStyle(
                          color: Colors.blueAccent,
                          fontWeight: .bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 18),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        // Ajouter ton logic
                        debugPrint("credential $_email, $_password");
                      }
                    },
                    child: Text(
                      "Se connecter",
                      style: TextStyle(
                        fontWeight: .bold,
                        color: theme.colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 18),
            //  3 Part
            TextButton(
              style: TextButton.styleFrom(
                side: BorderSide(
                  width: 1,
                  color: theme.colorScheme.onPrimaryFixedVariant,
                ),
              ),
              onPressed: () {},
              child: Text("Continuer avec Google"),
            ),
            InkWell(
              onTap: () {
                context.go(RouterName.signup);
                debugPrint("Navigated");
              },
              child: Row(
                mainAxisAlignment: .center,
                crossAxisAlignment: .center,
                children: [
                  Text(
                    "Pas encore de compte?",
                    style: TextStyle(color: theme.colorScheme.secondary),
                  ),
                  SizedBox(width: 4),
                  Text(
                    "S'inscrire",
                    textAlign: .end,
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontWeight: .bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
