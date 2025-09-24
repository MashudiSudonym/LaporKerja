import 'package:flutter_test/flutter_test.dart';
import 'package:lapor_kerja/core/utils/result.dart';
import 'package:lapor_kerja/domain/entities/task_entity.dart';
import 'package:lapor_kerja/domain/repositories/task_repository.dart';
import 'package:lapor_kerja/domain/usecases/task/add_task/add_task_params.dart';
import 'package:lapor_kerja/domain/usecases/task/add_task/add_task_usecase.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'add_task_usecase_test.mocks.dart';

@GenerateMocks([TaskRepository], customMocks: [MockSpec<TaskRepository>(as: #MockTaskRepositoryForAdd)])
void main() {
  late AddTaskUseCase useCase;
  late MockTaskRepositoryForAdd mockRepository;

  setUp(() {
    mockRepository = MockTaskRepositoryForAdd();
    useCase = AddTaskUseCase(mockRepository);
  });

  setUpAll(() {
    provideDummy<Result<void>>(const Result.failed('dummy'));
  });

  group('AddTaskUseCase', () {
    test('should call repository.createTask with correct params', () async {
      // Arrange
      final task = TaskEntity(
        id: 1,
        projectId: 1,
        taskName: 'Test Task',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isDeleted: false,
      );
      final params = AddTaskParams(task);
      when(mockRepository.createTask(task)).thenAnswer((_) async => const Result.success(null));

      // Act
      final result = await useCase.call(params);

      // Assert
      verify(mockRepository.createTask(task)).called(1);
      expect(result.isSuccess, true);
    });
  });
}

