import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const _seeds = Color.fromARGB(255, 8, 30, 232);

  static ThemeData get light {
    final scheme = ColorScheme.fromSeed(seedColor: _seeds);

    return _base(scheme);
  }

  static ThemeData get dark {
    final scheme = ColorScheme.fromSeed(seedColor: _seeds, brightness: .dark);
    return _base(scheme);
  }

  static ThemeData _base(ColorScheme scheme) {
    return ThemeData(useMaterial3: true, colorScheme: scheme);
  }
}
