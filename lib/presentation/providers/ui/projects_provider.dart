import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../domain/entities/project_entity.dart';
import '../../../domain/usecases/project/add_project/add_project_params.dart';
import '../../../domain/usecases/project/delete_project/delete_project_params.dart';
import '../../../domain/usecases/project/update_project/update_project_params.dart';
import '../usecases/project_usecases_provider.dart';

part 'projects_provider.g.dart';

@riverpod
class ProjectsNotifier extends _$ProjectsNotifier {
  @override
  Stream<List<ProjectEntity>> build() {
    final getProjects = ref.watch(getProjectsUseCaseProvider);
    return getProjects();
  }

  Future<void> addProject(AddProjectParams params) async {
    final addProject = ref.read(addProjectUseCaseProvider);
    final result = await addProject(params);
    if (result.isFailed) {
      throw Exception(result.errorMessage);
    }
    ref.invalidateSelf();
  }

  Future<void> updateProject(UpdateProjectParams params) async {
    final updateProject = ref.read(updateProjectUseCaseProvider);
    final result = await updateProject(params);
    if (result.isFailed) {
      throw Exception(result.errorMessage);
    }
    ref.invalidateSelf();
  }

  Future<void> deleteProject(DeleteProjectParams params) async {
    final deleteProject = ref.read(deleteProjectUseCaseProvider);
    final result = await deleteProject(params);
    if (result.isFailed) {
      throw Exception(result.errorMessage);
    }
    ref.invalidateSelf();
  }
}