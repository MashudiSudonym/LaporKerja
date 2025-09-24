import 'package:flutter_test/flutter_test.dart';
import 'package:lapor_kerja/core/utils/result.dart';
import 'package:lapor_kerja/domain/entities/task_entity.dart';
import 'package:lapor_kerja/domain/repositories/task_repository.dart';
import 'package:lapor_kerja/domain/usecases/task/update_task/update_task_params.dart';
import 'package:lapor_kerja/domain/usecases/task/update_task/update_task_usecase.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'update_task_usecase_test.mocks.dart';

@GenerateMocks([TaskRepository], customMocks: [MockSpec<TaskRepository>(as: #MockTaskRepositoryForUpdate)])
void main() {
  late UpdateTaskUseCase useCase;
  late MockTaskRepositoryForUpdate mockRepository;

  setUp(() {
    mockRepository = MockTaskRepositoryForUpdate();
    useCase = UpdateTaskUseCase(mockRepository);
  });

  setUpAll(() {
    provideDummy<Result<void>>(const Result.failed('dummy'));
  });

  group('UpdateTaskUseCase', () {
    test('should call repository.updateTask with correct params', () async {
      // Arrange
      final task = TaskEntity(
        id: 1,
        projectId: 1,
        taskName: 'Updated Task',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isDeleted: false,
      );
      final params = UpdateTaskParams(task);
      when(mockRepository.updateTask(task)).thenAnswer((_) async => const Result.success(null));

      // Act
      final result = await useCase.call(params);

      // Assert
      verify(mockRepository.updateTask(task)).called(1);
      expect(result.isSuccess, true);
    });
  });
}