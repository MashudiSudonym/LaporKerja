import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../domain/usecases/project/add_project/add_project_usecase.dart';
import '../../../domain/usecases/project/delete_project/delete_project_usecase.dart';
import '../../../domain/usecases/project/get_projects_usecase.dart';
import '../../../domain/usecases/project/update_project/update_project_usecase.dart';
import '../repositories/project_repository_provider.dart';

part 'project_usecases_provider.g.dart';

@riverpod
AddProjectUseCase addProjectUseCase(Ref ref) {
  final repo = ref.watch(projectRepositoryProvider);
  return AddProjectUseCase(repo);
}

@riverpod
UpdateProjectUseCase updateProjectUseCase(Ref ref) {
  final repo = ref.watch(projectRepositoryProvider);
  return UpdateProjectUseCase(repo);
}

@riverpod
DeleteProjectUseCase deleteProjectUseCase(Ref ref) {
  final repo = ref.watch(projectRepositoryProvider);
  return DeleteProjectUseCase(repo);
}

@riverpod
GetProjectsUseCase getProjectsUseCase(Ref ref) {
  final repo = ref.watch(projectRepositoryProvider);
  return GetProjectsUseCase(repo);
}