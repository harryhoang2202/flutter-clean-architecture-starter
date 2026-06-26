import 'package:flutter_clean_architecture_starter/core/result/result.dart';
import 'package:flutter_clean_architecture_starter/core/use_cases/use_case.dart';
import 'package:flutter_clean_architecture_starter/features/projects/domain/entities/project.dart';
import 'package:flutter_clean_architecture_starter/features/projects/domain/repositories/projects_repository.dart';

class UpdateProject extends UseCase<Project, UpdateProjectParams> {
  const UpdateProject(this._repository);

  final ProjectsRepository _repository;

  @override
  Future<Result<Project>> call(UpdateProjectParams params) {
    return _repository.updateProject(
      projectId: params.projectId,
      name: params.name,
    );
  }
}

class UpdateProjectParams {
  const UpdateProjectParams({required this.projectId, required this.name});

  final String projectId;
  final String name;
}
