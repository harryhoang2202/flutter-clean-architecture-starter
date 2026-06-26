import 'package:flutter_clean_architecture_starter/core/result/result.dart';
import 'package:flutter_clean_architecture_starter/features/projects/domain/entities/project.dart';

abstract class ProjectsRepository {
  Future<Result<List<Project>>> loadProjects();

  Future<Result<Project>> createProject({required String name});

  Future<Result<Project>> updateProject({
    required String projectId,
    required String name,
  });

  Future<Result<void>> deleteProject({required String projectId});
}
