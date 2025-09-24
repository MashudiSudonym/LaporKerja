import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../domain/entities/task_entity.dart';
import '../../../domain/usecases/task/add_task/add_task_params.dart';
import '../../../domain/usecases/task/update_task/update_task_params.dart';
import '../usecases/task_usecases_provider.dart';

part 'task_form_notifier.g.dart';

/// AsyncNotifier for task form operations
@riverpod
class TaskFormNotifier extends _$TaskFormNotifier {
  @override
  FutureOr<void> build() {
    // No initial state needed
  }

  Future<void> addTask(int projectId, String taskName, String? description, String? status, DateTime? deadline) async {
    state = const AsyncLoading();

    final task = TaskEntity(
      id: 0,
      projectId: projectId,
      taskName: taskName,
      description: description,
      status: status,
      deadline: deadline,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      isDeleted: false,
    );

    final params = AddTaskParams(task);

    final addTaskUseCase = ref.read(addTaskUseCaseProvider);
    final result = await addTaskUseCase(params);

    if (result.isFailed) {
      state = AsyncError(result.errorMessage!, StackTrace.current);
      throw Exception(result.errorMessage);
    } else {
      state = const AsyncData(null);
    }
  }

  Future<void> updateTask(int id, int projectId, String taskName, String? description, String? status, DateTime? deadline) async {
    state = const AsyncLoading();

    final task = TaskEntity(
      id: id,
      projectId: projectId,
      taskName: taskName,
      description: description,
      status: status,
      deadline: deadline,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      isDeleted: false,
    );

    final params = UpdateTaskParams(task);

    final updateTaskUseCase = ref.read(updateTaskUseCaseProvider);
    final result = await updateTaskUseCase(params);

    if (result.isFailed) {
      state = AsyncError(result.errorMessage!, StackTrace.current);
      throw Exception(result.errorMessage);
    } else {
      state = const AsyncData(null);
    }
  }
}