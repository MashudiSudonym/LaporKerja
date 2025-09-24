import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../domain/usecases/task/add_task/add_task_usecase.dart';
import '../../../domain/usecases/task/delete_task/delete_task_usecase.dart';
import '../../../domain/usecases/task/get_tasks_usecase.dart';
import '../../../domain/usecases/task/update_task/update_task_usecase.dart';
import '../repositories/task_repository_provider.dart';

part 'task_usecases_provider.g.dart';

@riverpod
AddTaskUseCase addTaskUseCase(Ref ref) {
  final repo = ref.watch(taskRepositoryProvider);
  return AddTaskUseCase(repo);
}

@riverpod
UpdateTaskUseCase updateTaskUseCase(Ref ref) {
  final repo = ref.watch(taskRepositoryProvider);
  return UpdateTaskUseCase(repo);
}

@riverpod
DeleteTaskUseCase deleteTaskUseCase(Ref ref) {
  final repo = ref.watch(taskRepositoryProvider);
  return DeleteTaskUseCase(repo);
}

@riverpod
GetTasksUseCase getTasksUseCase(Ref ref) {
  final repo = ref.watch(taskRepositoryProvider);
  return GetTasksUseCase(repo);
}