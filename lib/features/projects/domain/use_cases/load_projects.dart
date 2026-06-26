import 'package:flutter_clean_architecture_starter/core/result/result.dart';
import 'package:flutter_clean_architecture_starter/core/use_cases/use_case.dart';
import 'package:flutter_clean_architecture_starter/features/projects/domain/entities/project.dart';
import 'package:flutter_clean_architecture_starter/features/projects/domain/repositories/projects_repository.dart';

class LoadProjects extends UseCase<List<Project>, NoParams> {
  const LoadProjects(this._repository);

  final ProjectsRepository _repository;

  @override
  Future<Result<List<Project>>> call(NoParams params) {
    return _repository.loadProjects();
  }
}
