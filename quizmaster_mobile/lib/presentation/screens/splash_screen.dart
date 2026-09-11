import 'package:flutter/material.dart';
import 'package:quizmaster_mobile/presentation/widget/logo_widget.dart';
import 'package:quizmaster_mobile/presentation/widget/rich_text_widget.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      body: Center(
        child: Column(
          crossAxisAlignment: .center,
          mainAxisAlignment: .center,
          children: [
            Spacer(),
            //  Icon for the app logo
            LogoWidget(),
            SizedBox(height: 8),
            // App name with different colors for "Quiz" and "Master"
            RichTextWidget(),
            SizedBox(height: 16),

            // Row for the three words "Apprendre", "Teste", and "Progresse"
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 8,
              children: [
                Text("Apprendre", style: textStyle),
                Text("Teste", style: textStyle),
                Text("Progresse", style: textStyle),
              ],
            ),
            Spacer(),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 16),
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).colorScheme.primary,
                  ),
                ),
                SizedBox(height: 16),
                Text("Chargement...", style: textStyle),
              ],
            ),
            SizedBox(height: 14),
          ],
        ),
      ),
    );
  }
}
