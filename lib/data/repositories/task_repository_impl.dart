import 'package:drift/drift.dart';
import 'package:lapor_kerja/core/utils/result.dart';
import 'package:lapor_kerja/data/datasources/local/app_database.dart';
import 'package:lapor_kerja/data/datasources/local/dao/tasks_dao.dart';
import 'package:lapor_kerja/data/mappers/task_mapper.dart';
import 'package:lapor_kerja/data/services/supabase_service.dart';
import 'package:lapor_kerja/domain/entities/task_entity.dart';
import 'package:lapor_kerja/domain/repositories/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TasksDao _tasksDao;
  final SupabaseService _supabaseService;

  TaskRepositoryImpl(this._tasksDao, this._supabaseService);

  @override
  Stream<List<TaskEntity>> watchAllTasks() {
    return _tasksDao.watchAllTasks().map(
          (tasks) => tasks
              .where((task) => !task.isDeleted)
              .map((task) => task.toEntity())
              .toList(),
        );
  }

  @override
  Stream<List<TaskEntity>> watchTasksForProject(int projectId) {
    return _tasksDao.watchTasksForProject(projectId).map(
          (tasks) => tasks
              .where((task) => !task.isDeleted)
              .map((task) => task.toEntity())
              .toList(),
        );
  }

  @override
  Future<Result<TaskEntity>> getTaskById(int id) async {
    try {
      final tasks = await _tasksDao.watchTasksForProject(0).first; // Get all tasks
      final task = tasks.where((t) => t.id == id && !t.isDeleted).firstOrNull;

      if (task == null) {
        return const Result.failed('Task not found');
      }

      return Result.success(task.toEntity());
    } catch (e) {
      return Result.failed('Failed to get task: $e');
    }
  }

  @override
  Future<Result<void>> createTask(TaskEntity task) async {
    try {
      await _tasksDao.upsertTask(task.toCompanion());
      // Try to sync in background
      _supabaseService.syncTasks(this);
      return const Result.success(null);
    } catch (e) {
      return Result.failed('Failed to create task: $e');
    }
  }

  @override
  Future<Result<void>> updateTask(TaskEntity task) async {
    try {
      await _tasksDao.upsertTask(task.toCompanion());
      return const Result.success(null);
    } catch (e) {
      return Result.failed('Failed to update task: $e');
    }
  }

  @override
  Future<Result<void>> softDeleteTask(int id) async {
    try {
      await _tasksDao.softDeleteTask(id);
      return const Result.success(null);
    } catch (e) {
      return Result.failed('Failed to delete task: $e');
    }
  }

  @override
  Future<Result<List<TaskEntity>>> getUnsyncedTasks() async {
    try {
      final tasks = await _tasksDao.getUnsyncedTasks();
      final entities = tasks.map((t) => t.toEntity()).toList();
      return Result.success(entities);
    } catch (e) {
      return Result.failed('Failed to get unsynced tasks: $e');
    }
  }

  @override
  Future<Result<void>> markTaskAsSynced(int id) async {
    try {
      await _tasksDao.upsertTask(
        TasksCompanion(
          id: Value(id),
          isSynced: const Value(true),
          lastModified: Value(DateTime.now()),
        ),
      );
      return const Result.success(null);
    } catch (e) {
      return Result.failed('Failed to mark task as synced: $e');
    }
  }
}