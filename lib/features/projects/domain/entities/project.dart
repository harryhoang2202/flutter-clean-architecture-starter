import 'package:equatable/equatable.dart';

class Project extends Equatable {
  const Project({required this.id, required this.name});

  final String id;
  final String name;

  @override
  List<Object> get props => [id, name];
}
