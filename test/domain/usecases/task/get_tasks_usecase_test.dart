import 'package:flutter_test/flutter_test.dart';
import 'package:lapor_kerja/domain/entities/task_entity.dart';
import 'package:lapor_kerja/domain/repositories/task_repository.dart';
import 'package:lapor_kerja/domain/usecases/task/get_tasks_usecase.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_tasks_usecase_test.mocks.dart';

@GenerateMocks([TaskRepository], customMocks: [MockSpec<TaskRepository>(as: #MockTaskRepositoryForGet)])
void main() {
  late GetTasksUseCase useCase;
  late MockTaskRepositoryForGet mockRepository;

  setUp(() {
    mockRepository = MockTaskRepositoryForGet();
    useCase = GetTasksUseCase(mockRepository);
  });

  group('GetTasksUseCase', () {
    test('should return stream from repository.watchAllTasks', () {
      // Arrange
      final tasks = [
        TaskEntity(
          id: 1,
          projectId: 1,
          taskName: 'Task 1',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          isDeleted: false,
        ),
      ];
      when(mockRepository.watchAllTasks()).thenAnswer((_) => Stream.value(tasks));

      // Act
      final result = useCase.call();

      // Assert
      expect(result, isA<Stream<List<TaskEntity>>>());
      verify(mockRepository.watchAllTasks()).called(1);
    });
  });
}