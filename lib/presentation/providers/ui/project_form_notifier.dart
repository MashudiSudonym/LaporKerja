import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../domain/entities/project_entity.dart';
import '../../../domain/usecases/project/add_project/add_project_params.dart';
import '../../../domain/usecases/project/update_project/update_project_params.dart';
import '../usecases/project_usecases_provider.dart';

part 'project_form_notifier.g.dart';

/// AsyncNotifier for project form operations
@riverpod
class ProjectFormNotifier extends _$ProjectFormNotifier {
  @override
  FutureOr<void> build() {
    // No initial state needed
  }

  Future<void> addProject(String name, String? description) async {
    state = const AsyncLoading();

    final project = ProjectEntity(
      id: 0,
      projectName: name,
      description: description,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      isDeleted: false,
    );

    final params = AddProjectParams(project);

    final addProjectUseCase = ref.read(addProjectUseCaseProvider);
    final result = await addProjectUseCase(params);

    if (result.isFailed) {
      state = AsyncError(result.errorMessage!, StackTrace.current);
      throw Exception(result.errorMessage);
    } else {
      state = const AsyncData(null);
    }
  }

  Future<void> updateProject(int id, String name, String? description) async {
    state = const AsyncLoading();

    final project = ProjectEntity(
      id: id,
      projectName: name,
      description: description,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      isDeleted: false,
    );

    final params = UpdateProjectParams(project);

    final updateProjectUseCase = ref.read(updateProjectUseCaseProvider);
    final result = await updateProjectUseCase(params);

    if (result.isFailed) {
      state = AsyncError(result.errorMessage!, StackTrace.current);
      throw Exception(result.errorMessage);
    } else {
      state = const AsyncData(null);
    }
  }

  Future<void> loadProject(int id) async {
    // For edit mode, load existing project
    // This would need a getProjectById use case
    // For now, assume it's passed from route
  }
}