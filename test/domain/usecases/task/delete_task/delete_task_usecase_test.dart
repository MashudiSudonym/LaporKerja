import 'package:flutter_test/flutter_test.dart';
import 'package:lapor_kerja/core/utils/result.dart';
import 'package:lapor_kerja/domain/repositories/task_repository.dart';
import 'package:lapor_kerja/domain/usecases/task/delete_task/delete_task_params.dart';
import 'package:lapor_kerja/domain/usecases/task/delete_task/delete_task_usecase.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'delete_task_usecase_test.mocks.dart';

@GenerateMocks([TaskRepository], customMocks: [MockSpec<TaskRepository>(as: #MockTaskRepositoryForDelete)])
void main() {
  late DeleteTaskUseCase useCase;
  late MockTaskRepositoryForDelete mockRepository;

  setUp(() {
    mockRepository = MockTaskRepositoryForDelete();
    useCase = DeleteTaskUseCase(mockRepository);
  });

  setUpAll(() {
    provideDummy<Result<void>>(const Result.failed('dummy'));
  });

  group('DeleteTaskUseCase', () {
    test('should call repository.softDeleteTask with correct id', () async {
      // Arrange
      const id = 1;
      final params = DeleteTaskParams(id);
      when(mockRepository.softDeleteTask(id)).thenAnswer((_) async => const Result.success(null));

      // Act
      final result = await useCase.call(params);

      // Assert
      verify(mockRepository.softDeleteTask(id)).called(1);
      expect(result.isSuccess, true);
    });
  });
}