import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:lapor_kerja/core/utils/result.dart';
import 'package:lapor_kerja/domain/entities/task_entity.dart';
import 'package:lapor_kerja/domain/repositories/task_repository.dart';

@GenerateMocks([TaskRepository])
import 'task_repository_test.mocks.dart';

void main() {
  late MockTaskRepository mockTaskRepository;

  setUp(() {
    mockTaskRepository = MockTaskRepository();
    provideDummy<Result<TaskEntity>>(Result.failed('dummy'));
    provideDummy<Result<void>>(Result.failed('dummy'));
    provideDummy<Result<List<TaskEntity>>>(Result.failed('dummy'));
  });

  group('TaskRepository', () {
    final testTask = TaskEntity(
      id: 1,
      projectId: 1,
      taskName: 'Test Task',
      description: 'Test Description',
      status: 'pending',
      deadline: DateTime(2023, 12, 31),
      createdAt: DateTime(2023, 1, 1),
      updatedAt: DateTime(2023, 1, 1),
      isDeleted: false,
    );

    test('should watch tasks for project', () {
      when(mockTaskRepository.watchTasksForProject(1)).thenAnswer((_) => Stream.value([testTask]));
      expect(mockTaskRepository.watchTasksForProject(1), isA<Stream<List<TaskEntity>>>());
    });

    test('should get task by id', () async {
      when(mockTaskRepository.getTaskById(1)).thenAnswer((_) async => Result.success(testTask));
      final result = await mockTaskRepository.getTaskById(1);
      expect(result.isSuccess, true);
      expect(result.resultValue, testTask);
    });

    test('should create task', () async {
      when(mockTaskRepository.createTask(testTask)).thenAnswer((_) async => Result.success(null));
      await mockTaskRepository.createTask(testTask);
      verify(mockTaskRepository.createTask(testTask)).called(1);
    });

    test('should update task', () async {
      when(mockTaskRepository.updateTask(testTask)).thenAnswer((_) async => Result.success(null));
      await mockTaskRepository.updateTask(testTask);
      verify(mockTaskRepository.updateTask(testTask)).called(1);
    });

    test('should soft delete task', () async {
      when(mockTaskRepository.softDeleteTask(1)).thenAnswer((_) async => Result.success(null));
      await mockTaskRepository.softDeleteTask(1);
      verify(mockTaskRepository.softDeleteTask(1)).called(1);
    });

    test('should get unsynced tasks', () async {
      when(mockTaskRepository.getUnsyncedTasks()).thenAnswer((_) async => Result.success([testTask]));
      final result = await mockTaskRepository.getUnsyncedTasks();
      expect(result.isSuccess, true);
      expect(result.resultValue, [testTask]);
    });

    test('should mark task as synced', () async {
      when(mockTaskRepository.markTaskAsSynced(1)).thenAnswer((_) async => Result.success(null));
      await mockTaskRepository.markTaskAsSynced(1);
      verify(mockTaskRepository.markTaskAsSynced(1)).called(1);
    });
  });
}