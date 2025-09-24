import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:drift/drift.dart';
import 'package:lapor_kerja/core/utils/result.dart';
import 'package:lapor_kerja/data/datasources/local/app_database.dart';
import 'package:lapor_kerja/data/datasources/local/dao/tasks_dao.dart';
import 'package:lapor_kerja/data/mappers/task_mapper.dart';
import 'package:lapor_kerja/data/services/supabase_service.dart';
import 'package:lapor_kerja/domain/entities/task_entity.dart';
import 'package:lapor_kerja/domain/repositories/task_repository.dart';

import '../../core/constants/constants.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TasksDao _tasksDao;
  final SupabaseService _supabaseService;
  final Connectivity _connectivity;

  TaskRepositoryImpl(this._tasksDao, this._supabaseService, this._connectivity);

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
      // Save locally first
      final companion = task.toCompanion();
      final companionWithUnsynced = companion.copyWith(isSynced: const Value(false));
      await _tasksDao.upsertTask(companionWithUnsynced);

      // Try to sync to Supabase if online
      final connectivityResult = await _connectivity.checkConnectivity();
      if (connectivityResult != ConnectivityResult.none) {
        try {
          await _supabaseService.upsert('tasks', task.toJson());
          await markTaskAsSynced(task.id);
        } catch (e) {
          Constants.logger.e('Failed to sync task on create: $e');
          // isSynced remains false
        }
      }

      return const Result.success(null);
    } catch (e) {
      return Result.failed('Failed to create task: $e');
    }
  }

  @override
  Future<Result<void>> updateTask(TaskEntity task) async {
    try {
      // Save locally first
      final companion = task.toCompanion();
      final companionWithUnsynced = companion.copyWith(isSynced: const Value(false));
      await _tasksDao.upsertTask(companionWithUnsynced);

      // Try to sync to Supabase if online
      final connectivityResult = await _connectivity.checkConnectivity();
      if (connectivityResult != ConnectivityResult.none) {
        try {
          await _supabaseService.upsert('tasks', task.toJson());
          await markTaskAsSynced(task.id);
        } catch (e) {
          Constants.logger.e('Failed to sync task on update: $e');
          // isSynced remains false
        }
      }

      return const Result.success(null);
    } catch (e) {
      return Result.failed('Failed to update task: $e');
    }
  }

  @override
  Future<Result<void>> softDeleteTask(int id) async {
    try {
      // Get task before deleting
      final taskResult = await getTaskById(id);
      if (taskResult.isFailed) return taskResult;

      final task = taskResult.resultValue!;
      final updatedTask = task.copyWith(isDeleted: true);

      // Save locally first
      final companion = updatedTask.toCompanion();
      final companionWithUnsynced = companion.copyWith(isSynced: const Value(false));
      await _tasksDao.upsertTask(companionWithUnsynced);

      // Try to sync to Supabase if online
      final connectivityResult = await _connectivity.checkConnectivity();
      if (connectivityResult != ConnectivityResult.none) {
        try {
          await _supabaseService.upsert('tasks', updatedTask.toJson());
          await markTaskAsSynced(id);
        } catch (e) {
          Constants.logger.e('Failed to sync task on delete: $e');
          // isSynced remains false
        }
      }

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

  /// Sync all unsynced tasks to Supabase
  Future<void> syncAllTasks() async {
    final unsyncedResult = await getUnsyncedTasks();
    if (unsyncedResult.isFailed) return;

    final unsyncedTasks = unsyncedResult.resultValue!;
    await _supabaseService.syncTasks(unsyncedTasks);

    // Mark all as synced
    for (final task in unsyncedTasks) {
      await markTaskAsSynced(task.id);
    }
  }
}