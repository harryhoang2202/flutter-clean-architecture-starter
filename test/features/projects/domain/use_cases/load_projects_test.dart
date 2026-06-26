import 'package:flutter_clean_architecture_starter/core/result/result.dart';
import 'package:flutter_clean_architecture_starter/core/use_cases/use_case.dart';
import 'package:flutter_clean_architecture_starter/features/projects/data/datasources/fake_projects_remote_data_source.dart';
import 'package:flutter_clean_architecture_starter/features/projects/data/repositories/projects_repository_impl.dart';
import 'package:flutter_clean_architecture_starter/features/projects/domain/entities/project.dart';
import 'package:flutter_clean_architecture_starter/features/projects/domain/use_cases/load_projects.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('load Projects returns available Projects', () async {
    final repository = ProjectsRepositoryImpl(
      remoteDataSource: FakeProjectsRemoteDataSource(),
    );
    final loadProjects = LoadProjects(repository);

    final result = await loadProjects(const NoParams());

    expect(result, isA<Success<List<Project>>>());
    expect(
      result.valueOrNull,
      contains(
        const Project(id: 'reference-starter', name: 'Reference Starter'),
      ),
    );
  });
}
