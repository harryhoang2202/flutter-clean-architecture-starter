import 'package:flutter_clean_architecture_starter/core/result/result.dart';
import 'package:flutter_clean_architecture_starter/core/use_cases/use_case.dart';
import 'package:flutter_clean_architecture_starter/features/projects/domain/repositories/projects_repository.dart';

class DeleteProject extends UseCase<void, DeleteProjectParams> {
  const DeleteProject(this._repository);

  final ProjectsRepository _repository;

  @override
  Future<Result<void>> call(DeleteProjectParams params) {
    return _repository.deleteProject(projectId: params.projectId);
  }
}

class DeleteProjectParams {
  const DeleteProjectParams({required this.projectId});

  final String projectId;
}
