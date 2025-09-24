import 'package:flutter_test/flutter_test.dart';
import 'package:lapor_kerja/core/utils/result.dart';
import 'package:lapor_kerja/domain/repositories/project_repository.dart';
import 'package:lapor_kerja/domain/usecases/project/delete_project/delete_project_params.dart';
import 'package:lapor_kerja/domain/usecases/project/delete_project/delete_project_usecase.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'delete_project_usecase_test.mocks.dart';

@GenerateMocks([ProjectRepository], customMocks: [MockSpec<ProjectRepository>(as: #MockProjectRepositoryForDelete)])
void main() {
  late DeleteProjectUseCase useCase;
  late MockProjectRepositoryForDelete mockRepository;

  setUp(() {
    mockRepository = MockProjectRepositoryForDelete();
    useCase = DeleteProjectUseCase(mockRepository);
  });

  setUpAll(() {
    provideDummy<Result<void>>(const Result.failed('dummy'));
  });

  group('DeleteProjectUseCase', () {
    test('should call repository.softDeleteProject with correct id', () async {
      // Arrange
      const id = 1;
      final params = DeleteProjectParams(id);
      when(mockRepository.softDeleteProject(id)).thenAnswer((_) async => const Result.success(null));

      // Act
      final result = await useCase.call(params);

      // Assert
      verify(mockRepository.softDeleteProject(id)).called(1);
      expect(result.isSuccess, true);
    });
  });
}