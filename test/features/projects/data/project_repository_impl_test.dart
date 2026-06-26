import 'package:flutter_clean_architecture_starter/core/error/failure.dart';
import 'package:flutter_clean_architecture_starter/core/result/result.dart';
import 'package:flutter_clean_architecture_starter/features/projects/data/datasources/fake_projects_remote_data_source.dart';
import 'package:flutter_clean_architecture_starter/features/projects/data/repositories/projects_repository_impl.dart';
import 'package:flutter_clean_architecture_starter/features/projects/domain/entities/project.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
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
