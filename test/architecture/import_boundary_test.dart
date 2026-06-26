import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  group('architecture import boundaries', () {
    test('domain layer does not import data, presentation, or composition', () {
      final violations = <String>[];

      for (final file in _dartFilesUnder('lib/features')) {
        if (!file.path.normalized.contains('/domain/')) {
          continue;
        }

        for (final import in _importsIn(file)) {
          if (_isForbiddenDomainImport(import)) {
            violations.add('${file.path}: $import');
          }
        }
      }

      expect(
        violations,
        isEmpty,
        reason:
            'Domain modules must stay independent of data, presentation, '
            'routing, dependency composition, and transport details.',
      );
    });

    test('DTOs stay inside data layer', () {
      final violations = <String>[];

      for (final file in _dartFilesUnder('lib')) {
        if (file.path.normalized.contains('/data/')) {
          continue;
        }

        for (final import in _importsIn(file)) {
          if (import.contains('/data/dtos/')) {
            violations.add('${file.path}: $import');
          }
        }
      }

      expect(
        violations,
        isEmpty,
        reason:
            'DTOs are data adapters and must not leak into domain, '
            'presentation, routing, or app shell code.',
      );
    });

    test(
      'get_it and injectable imports stay inside dependency composition',
      () {
        final violations = <String>[];

        for (final file in _dartFilesUnder('lib')) {
          if (file.path.normalized.startsWith('lib/app/di/')) {
            continue;
          }

          for (final import in _importsIn(file)) {
            if (import == 'package:get_it/get_it.dart' ||
                import == 'package:injectable/injectable.dart') {
              violations.add('${file.path}: $import');
            }
          }
        }

        expect(
          violations,
          isEmpty,
          reason: 'Service locator and injectable usage belongs in lib/app/di.',
        );
      },
    );

    test('core runtime modules do not import feature presentation', () {
      final violations = <String>[];

      for (final file in _dartFilesUnder('lib/core')) {
        for (final import in _importsIn(file)) {
          if (import.contains('/features/') &&
              import.contains('/presentation/')) {
            violations.add('${file.path}: $import');
          }
        }
      }

      expect(
        violations,
        isEmpty,
        reason:
            'Core runtime modules must not know about feature presentation. '
            'Feature UI wiring belongs in app routing or dependency '
            'composition.',
      );
    });

    test('routing does not import feature data implementations', () {
      final violations = <String>[];

      for (final file in _dartFilesUnderAny([
        'lib/app/routing',
        'lib/core/routing',
      ])) {
        for (final import in _importsIn(file)) {
          if (import.contains('/features/') && import.contains('/data/')) {
            violations.add('${file.path}: $import');
          }
        }
      }

      expect(
        violations,
        isEmpty,
        reason:
            'Routing may depend on route contracts and presentation builders, '
            'but not concrete feature data implementations.',
      );
    });
  });
}

Iterable<File> _dartFilesUnderAny(Iterable<String> paths) sync* {
  for (final path in paths) {
    yield* _dartFilesUnder(path);
  }
}

Iterable<File> _dartFilesUnder(String path) {
  return Directory(path)
      .listSync(recursive: true)
      .whereType<File>()
      .where((file) => file.path.endsWith('.dart'));
}

Iterable<String> _importsIn(File file) {
  final importPattern = RegExp(
    r'''^import\s+['"]([^'"]+)['"];''',
    multiLine: true,
  );

  return importPattern
      .allMatches(file.readAsStringSync())
      .map((match) => match.group(1)!);
}

bool _isForbiddenDomainImport(String import) {
  if (import.startsWith('dart:')) {
    return false;
  }

  return import.startsWith('package:flutter/') ||
      import.startsWith('package:flutter_bloc/') ||
      import == 'package:get_it/get_it.dart' ||
      import == 'package:injectable/injectable.dart' ||
      import == 'package:go_router/go_router.dart' ||
      import.contains('/data/') ||
      import.contains('/presentation/') ||
      import.contains('/routing/') ||
      import.contains('/di/') ||
      import.contains('/remote_exception.dart');
}

extension on String {
  String get normalized => replaceAll(r'\', '/');
}
