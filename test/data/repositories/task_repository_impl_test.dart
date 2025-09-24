import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:lapor_kerja/data/datasources/local/app_database.dart';
import 'package:lapor_kerja/data/datasources/local/dao/tasks_dao.dart';
import 'package:lapor_kerja/data/mappers/task_mapper.dart';
import 'package:lapor_kerja/data/repositories/task_repository_impl.dart';
import 'package:lapor_kerja/data/services/supabase_service.dart';
import 'package:lapor_kerja/domain/entities/task_entity.dart';

@GenerateMocks([TasksDao, SupabaseService, Connectivity])
import 'task_repository_impl_test.mocks.dart';

// Helper extension for testing
extension TasksCompanionTestHelper on TasksCompanion {
  Task toTask() {
    return Task(
      id: id.value,
      remoteId: remoteId.present ? remoteId.value : null,
      isSynced: isSynced.present ? isSynced.value : false,
      lastModified: lastModified.present ? lastModified.value : DateTime.now(),
      isDeleted: isDeleted.present ? isDeleted.value : false,
      projectId: projectId.value,
      taskName: taskName.value,
      description: description.present ? description.value : null,
      status: status.present ? status.value : 'todo',
      deadline: deadline.present ? deadline.value : null,
      createdAt: createdAt.value,
      updatedAt: updatedAt.value,
    );
  }
}

void main() {
  late MockTasksDao mockTasksDao;
  late MockSupabaseService mockSupabaseService;
  late MockConnectivity mockConnectivity;
  late TaskRepositoryImpl repository;

  setUp(() {
    mockTasksDao = MockTasksDao();
    mockSupabaseService = MockSupabaseService();
    mockConnectivity = MockConnectivity();
    repository = TaskRepositoryImpl(mockTasksDao, mockSupabaseService, mockConnectivity);
  });

  group('TaskRepositoryImpl', () {
    final testTask = TaskEntity(
      id: 1,
      projectId: 1,
      taskName: 'Test Task',
      description: 'Test Description',
      status: 'in_progress',
      deadline: DateTime(2023, 12, 31),
      createdAt: DateTime(2023, 1, 1),
      updatedAt: DateTime(2023, 1, 1),
      isDeleted: false,
    );

    test('should create task successfully', () async {
      when(mockTasksDao.upsertTask(any)).thenAnswer((_) async => 1);
      when(mockConnectivity.checkConnectivity()).thenAnswer((_) async => ConnectivityResult.none);

      final result = await repository.createTask(testTask);

      expect(result.isSuccess, true);
      verify(mockTasksDao.upsertTask(any)).called(1);
    });

    test('should get task by id successfully', () async {
      when(mockTasksDao.watchTasksForProject(any))
          .thenAnswer((_) => Stream.value([testTask.toCompanion().toTask()]));

      final result = await repository.getTaskById(1);

      expect(result.isSuccess, true);
      expect(result.resultValue?.id, 1);
      expect(result.resultValue?.taskName, 'Test Task');
    });

    test('should return failed result when task not found', () async {
      when(mockTasksDao.watchTasksForProject(any)).thenAnswer((_) => Stream.value([]));

      final result = await repository.getTaskById(999);

      expect(result.isFailed, true);
      expect(result.errorMessage, 'Task not found');
    });

    test('should update task successfully', () async {
      when(mockTasksDao.upsertTask(any)).thenAnswer((_) async => 1);
      when(mockConnectivity.checkConnectivity()).thenAnswer((_) async => ConnectivityResult.none);

      final result = await repository.updateTask(testTask);

      expect(result.isSuccess, true);
      verify(mockTasksDao.upsertTask(any)).called(1);
    });

    test('should soft delete task successfully', () async {
      // Mock getTaskById to return the task
      when(mockTasksDao.watchTasksForProject(any))
          .thenAnswer((_) => Stream.value([testTask.toCompanion().toTask()]));
      when(mockTasksDao.upsertTask(any)).thenAnswer((_) async => 1);
      when(mockConnectivity.checkConnectivity()).thenAnswer((_) async => ConnectivityResult.none);

      final result = await repository.softDeleteTask(1);

      expect(result.isSuccess, true);
      verify(mockTasksDao.upsertTask(any)).called(1);
    });

    test('should watch tasks for project and filter out deleted ones', () async {
      final deletedTask = testTask.copyWith(isDeleted: true);
      when(mockTasksDao.watchTasksForProject(1)).thenAnswer((_) =>
          Stream.value([
            testTask.toCompanion().toTask(),
            deletedTask.toCompanion().toTask(),
          ]));

      final tasks = await repository.watchTasksForProject(1).first;

      expect(tasks.length, 1);
      expect(tasks.first.taskName, 'Test Task');
    });

    test('should get unsynced tasks', () async {
      when(mockTasksDao.getUnsyncedTasks())
          .thenAnswer((_) async => [testTask.toCompanion().toTask()]);

      final result = await repository.getUnsyncedTasks();

      expect(result.isSuccess, true);
      expect(result.resultValue?.length, 1);
      expect(result.resultValue?.first.taskName, 'Test Task');
    });

    test('should mark task as synced', () async {
      when(mockTasksDao.upsertTask(any)).thenAnswer((_) async => 1);

      final result = await repository.markTaskAsSynced(1);

      expect(result.isSuccess, true);
      verify(mockTasksDao.upsertTask(any)).called(1);
    });

    test('should handle database errors gracefully', () async {
      when(mockTasksDao.upsertTask(any)).thenThrow(Exception('DB Error'));

      final result = await repository.createTask(testTask);

      expect(result.isFailed, true);
      expect(result.errorMessage?.contains('Failed to create task'), true);
    });
  });
}