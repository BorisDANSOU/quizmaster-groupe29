import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quizmaster_mobile/core/config/router_name.dart';
import 'package:quizmaster_mobile/presentation/widget/category_card_widget.dart';
import 'package:quizmaster_mobile/presentation/widget/continue_widget.dart';
import 'package:quizmaster_mobile/presentation/widget/header_part.dart';
import 'package:quizmaster_mobile/presentation/widget/listtile_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    void redirectToCategoryPage() {
      context.pushNamed(RouterName.explore);
    }

    void redirectToQuizPage() {
      context.pushNamed(RouterName.quiz);
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const .symmetric(horizontal: 18),
            child: Column(
              children: [
                // -------------- Costum AppBar -------------------
                Container(
                  child: Row(
                    mainAxisAlignment: .spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: .start,
                        children: [
                          Text("Bon Retour", style: theme.textTheme.titleLarge),
                          Text(
                            "Pret a relever a nouveau defis?",
                            style: theme.textTheme.bodyLarge,
                          ),
                        ],
                      ),
                      Container(
                        padding: .all(6),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHigh,
                          borderRadius: .circular(50),
                        ),
                        child: Icon(
                          Icons.notifications_none_outlined,
                          size: 28,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 18),
                // ----------Continue with the Quiz you did not yet finished --------------------
                InkWell(
                  onTap: redirectToQuizPage,
                  child: ContinueWidget(
                    title: "Continuer le quiz",
                    subtitle: "Sante et bien etre",
                    progress: "3/10",
                    icon: Icons.quiz,
                    color: Colors.blueAccent,
                  ),
                ),
                SizedBox(height: 24),
                //------------ Display category of the quiz ------------------------
                HeaderPart(title: "Categories", onTap: redirectToCategoryPage),
                SizedBox(height: 12),
                // ++++
                Row(
                  mainAxisAlignment: .spaceBetween,
                  children: [
                    CategoryWidget(
                      title: "Education",
                      subtitle: "12 quiz",
                      icon: Icons.school,
                      color: Colors.blueAccent,
                    ),
                    CategoryWidget(
                      title: "Sante",
                      subtitle: "8 quiz",
                      icon: Icons.health_and_safety_rounded,
                      color: Colors.green,
                    ),
                    CategoryWidget(
                      title: "Technologie",
                      subtitle: "15 quiz",
                      icon: Icons.computer,
                      color: Colors.purple,
                    ),
                  ],
                ),
                SizedBox(height: 24),
                //-------------- Display of the quiz recent -------------------------
                HeaderPart(title: "Quiz recent", onTap: () {}),
                SizedBox(height: 12),
                ListtileWidget(
                  title: 'Sante & Bien-Etre',
                  subtitle: 'Alimentation et nutrition ',
                  progress: 'Score: 80% 5min',
                  icon: Icons.health_and_safety_rounded,
                  color: Colors.green,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
