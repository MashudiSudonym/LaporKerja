import '../../domain/entities/task_entity.dart';

abstract class TaskRepository {
  Stream<List<TaskEntity>> watchTasksForProject(int projectId);
  Future<TaskEntity?> getTaskById(int id);
  Future<void> createTask(TaskEntity task);
  Future<void> updateTask(TaskEntity task);
  Future<void> softDeleteTask(int id);
  Future<List<TaskEntity>> getUnsyncedTasks();
  Future<void> markTaskAsSynced(int id);
}