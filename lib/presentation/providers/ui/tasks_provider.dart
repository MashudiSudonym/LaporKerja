import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../domain/entities/task_entity.dart';
import '../../../domain/usecases/task/add_task/add_task_params.dart';
import '../../../domain/usecases/task/delete_task/delete_task_params.dart';
import '../../../domain/usecases/task/update_task/update_task_params.dart';
import '../usecases/task_usecases_provider.dart';

part 'tasks_provider.g.dart';

@riverpod
class TasksNotifier extends _$TasksNotifier {
  @override
  Stream<List<TaskEntity>> build() {
    final getTasks = ref.watch(getTasksUseCaseProvider);
    return getTasks();
  }

  Future<void> addTask(AddTaskParams params) async {
    final addTask = ref.read(addTaskUseCaseProvider);
    final result = await addTask(params);
    if (result.isFailed) {
      throw Exception(result.errorMessage);
    }
    ref.invalidateSelf();
  }

  Future<void> updateTask(UpdateTaskParams params) async {
    final updateTask = ref.read(updateTaskUseCaseProvider);
    final result = await updateTask(params);
    if (result.isFailed) {
      throw Exception(result.errorMessage);
    }
    ref.invalidateSelf();
  }

  Future<void> deleteTask(DeleteTaskParams params) async {
    final deleteTask = ref.read(deleteTaskUseCaseProvider);
    final result = await deleteTask(params);
    if (result.isFailed) {
      throw Exception(result.errorMessage);
    }
    ref.invalidateSelf();
  }
}