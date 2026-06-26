import 'package:flutter_clean_architecture_starter/core/error/failure.dart';
import 'package:flutter_clean_architecture_starter/core/result/result.dart';
import 'package:flutter_clean_architecture_starter/features/projects/domain/entities/project.dart';
import 'package:flutter_clean_architecture_starter/features/projects/domain/repositories/projects_repository.dart';
import 'package:flutter_clean_architecture_starter/features/projects/domain/use_cases/create_project.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('CreateProject calls repository with Project name', () async {
    final repository = _SpyProjectsRepository(
      createResult: const Result.success(
        Project(id: 'mobile-app', name: 'Mobile App'),
      ),
    );
    final createProject = CreateProject(repository);

    final result = await createProject(
      const CreateProjectParams(name: 'Mobile App'),
    );

    expect(repository.createProjectCalls, ['Mobile App']);
    expect(result, isA<Success<Project>>());
    expect(
      result.valueOrNull,
      const Project(id: 'mobile-app', name: 'Mobile App'),
    );
  });

  test(
    'CreateProject validates required name before calling repository',
    () async {
      final repository = _SpyProjectsRepository(
        createResult: const Result.success(
          Project(id: 'unused', name: 'Unused'),
        ),
      );
      final createProject = CreateProject(repository);

      final result = await createProject(
        const CreateProjectParams(name: '   '),
      );

      expect(repository.createProjectCalls, isEmpty);
      expect(result, isA<FailureResult<Project>>());

      final failure = result.failureOrNull;
      expect(failure, isA<ValidationFailure>());
      expect(failure?.message, 'Project name is required.');
      expect((failure as ValidationFailure).fieldErrors, {
        'name': 'Project name is required.',
      });
    },
  );
}

class _SpyProjectsRepository implements ProjectsRepository {
  _SpyProjectsRepository({required this.createResult});

  final Result<Project> createResult;
  final List<String> createProjectCalls = [];

  @override
  Future<Result<List<Project>>> loadProjects() {
    throw UnimplementedError();
  }

  @override
  Future<Result<Project>> createProject({required String name}) async {
    createProjectCalls.add(name);
    return createResult;
  }

  @override
  Future<Result<Project>> updateProject({
    required String projectId,
    required String name,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<Result<void>> deleteProject({required String projectId}) {
    throw UnimplementedError();
  }
}
