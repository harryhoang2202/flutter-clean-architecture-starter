import 'package:flutter_clean_architecture_starter/core/result/result.dart';
import 'package:flutter_clean_architecture_starter/features/projects/domain/entities/project.dart';

abstract class ProjectsRepository {
  Future<Result<List<Project>>> loadProjects();
}
