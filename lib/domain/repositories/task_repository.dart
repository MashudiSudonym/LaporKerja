import '../../core/utils/result.dart';
import '../../domain/entities/task_entity.dart';

abstract class TaskRepository {
  Stream<List<TaskEntity>> watchTasksForProject(int projectId);
  Future<Result<TaskEntity>> getTaskById(int id);
  Future<Result<void>> createTask(TaskEntity task);
  Future<Result<void>> updateTask(TaskEntity task);
  Future<Result<void>> softDeleteTask(int id);
  Future<Result<List<TaskEntity>>> getUnsyncedTasks();
  Future<Result<void>> markTaskAsSynced(int id);
}