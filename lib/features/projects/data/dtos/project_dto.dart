import 'package:flutter_clean_architecture_starter/features/projects/domain/entities/project.dart';

class ProjectDto {
  const ProjectDto({required this.id, required this.name});

  final String id;
  final String name;

  Project toDomain() {
    return Project(id: id, name: name);
  }
}
