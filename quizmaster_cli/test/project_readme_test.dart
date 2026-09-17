import 'dart:io';

import 'package:test/test.dart';

void main() {
  group('CLI documentation', () {
    test('the CLI README exists and documents the main workflow', () {
      final readme = File('README.md');

      expect(readme.existsSync(), isTrue);

      final content = readme.readAsStringSync();
      expect(content.toLowerCase(), contains('quizmaster cli'));
      expect(content, contains('dart run'));
      expect(content, contains('data'));
      expect(content, contains('JSON'));
    });
  });
}
