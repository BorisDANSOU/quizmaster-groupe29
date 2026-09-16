import 'package:flutter/material.dart';
import 'presentation/screens/app_shell.dart';

void main() {
  runApp(const ApercuApp());
}

class ApercuApp extends StatelessWidget {
  const ApercuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AppShell(),
    );
  }
}
