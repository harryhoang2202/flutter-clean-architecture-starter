import 'package:flutter_clean_architecture_starter/features/projects/domain/entities/project.dart';

class ProjectDto {
  const ProjectDto({required this.id, required this.name});

  final String id;
  final String name;

  ProjectDto copyWith({String? name}) {
    return ProjectDto(id: id, name: name ?? this.name);
  }

  Project toDomain() {
    return Project(id: id, name: name);
  }
}
