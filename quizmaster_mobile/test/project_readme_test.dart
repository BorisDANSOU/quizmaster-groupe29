import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Mobile documentation', () {
    test('the mobile README exists and describes the app lifecycle', () {
      final readme = File('README.md');

      expect(readme.existsSync(), isTrue);

      final content = readme.readAsStringSync();
      expect(content.toLowerCase(), contains('quizmaster mobile'));
      expect(content, contains('Flutter'));
      expect(content, contains('Firebase'));
      expect(content, contains('flutter run'));
    });
  });
}
