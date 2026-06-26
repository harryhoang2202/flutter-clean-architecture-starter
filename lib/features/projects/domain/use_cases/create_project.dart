import 'package:flutter_clean_architecture_starter/core/error/failure.dart';
import 'package:flutter_clean_architecture_starter/core/result/result.dart';
import 'package:flutter_clean_architecture_starter/core/use_cases/use_case.dart';
import 'package:flutter_clean_architecture_starter/features/projects/domain/entities/project.dart';
import 'package:flutter_clean_architecture_starter/features/projects/domain/repositories/projects_repository.dart';

class CreateProject extends UseCase<Project, CreateProjectParams> {
  const CreateProject(this._repository);

  final ProjectsRepository _repository;

  @override
  Future<Result<Project>> call(CreateProjectParams params) {
    if (params.name.trim().isEmpty) {
      return Future.value(
        const Result.failure(
          ValidationFailure(
            message: 'Project name is required.',
            fieldErrors: {'name': 'Project name is required.'},
          ),
        ),
      );
    }

    return _repository.createProject(name: params.name);
  }
}

class CreateProjectParams {
  const CreateProjectParams({required this.name});

  final String name;
}
