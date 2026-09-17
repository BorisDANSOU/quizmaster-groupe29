import 'dart:io';

import 'package:test/test.dart';

void main() {
  group('Workspace documentation', () {
    test('the root README exists and describes the full project', () {
      final readme = File('README.md');

      expect(readme.existsSync(), isTrue);

      final content = readme.readAsStringSync();
      expect(content, contains('QuizMaster'));
      expect(content, contains('quizmaster_cli'));
      expect(content, contains('quizmaster_mobile'));
      expect(content, contains('Firebase'));
    });

    test('the workspace contains the expected project folders', () {
      final cliDir = Directory('quizmaster_cli');
      final mobileDir = Directory('quizmaster_mobile');

      expect(cliDir.existsSync(), isTrue);
      expect(mobileDir.existsSync(), isTrue);
      expect(File('quizmaster_cli/README.md').existsSync(), isTrue);
      expect(File('quizmaster_mobile/README.md').existsSync(), isTrue);
    });
  });
}
