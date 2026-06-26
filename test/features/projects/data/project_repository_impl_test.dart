import 'package:flutter_clean_architecture_starter/core/error/failure.dart';
import 'package:flutter_clean_architecture_starter/core/result/result.dart';
import 'package:flutter_clean_architecture_starter/features/projects/data/datasources/fake_projects_remote_data_source.dart';
import 'package:flutter_clean_architecture_starter/features/projects/data/repositories/projects_repository_impl.dart';
import 'package:flutter_clean_architecture_starter/features/projects/domain/entities/project.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('repository creates, updates, and deletes Projects', () async {
    final repository = ProjectsRepositoryImpl(
      remoteDataSource: FakeProjectsRemoteDataSource(projects: []),
    );

    final createResult = await repository.createProject(name: 'Mobile App');
    expect(
      createResult.valueOrNull,
      const Project(id: 'mobile-app', name: 'Mobile App'),
    );

    final updateResult = await repository.updateProject(
      projectId: 'mobile-app',
      name: 'Mobile App v2',
    );
    expect(
      updateResult.valueOrNull,
      const Project(id: 'mobile-app', name: 'Mobile App v2'),
    );

    final deleteResult = await repository.deleteProject(
      projectId: 'mobile-app',
    );
    expect(deleteResult, isA<Success<void>>());

    final loadResult = await repository.loadProjects();
    expect(loadResult.valueOrNull, isEmpty);
  });

  test('repository maps fake remote project failure into a Failure', () async {
    final repository = ProjectsRepositoryImpl(
      remoteDataSource: FakeProjectsRemoteDataSource.unavailable(),
    );

    final result = await repository.loadProjects();

    expect(result, isA<FailureResult<List<Project>>>());
    expect(result.failureOrNull, isA<RemoteFailure>());
    expect(result.failureOrNull?.message, 'Projects source is unavailable.');
  });
}
