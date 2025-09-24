import 'package:flutter_test/flutter_test.dart';
import 'package:lapor_kerja/core/utils/result.dart';
import 'package:lapor_kerja/domain/entities/project_entity.dart';
import 'package:lapor_kerja/domain/repositories/project_repository.dart';
import 'package:lapor_kerja/domain/usecases/project/update_project/update_project_params.dart';
import 'package:lapor_kerja/domain/usecases/project/update_project/update_project_usecase.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'update_project_usecase_test.mocks.dart';

@GenerateMocks([ProjectRepository], customMocks: [MockSpec<ProjectRepository>(as: #MockProjectRepositoryForUpdate)])
void main() {
  late UpdateProjectUseCase useCase;
  late MockProjectRepositoryForUpdate mockRepository;

  setUp(() {
    mockRepository = MockProjectRepositoryForUpdate();
    useCase = UpdateProjectUseCase(mockRepository);
  });

  setUpAll(() {
    provideDummy<Result<void>>(const Result.failed('dummy'));
  });

  group('UpdateProjectUseCase', () {
    test('should call repository.updateProject with correct params', () async {
      // Arrange
      final project = ProjectEntity(
        id: 1,
        projectName: 'Updated Project',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isDeleted: false,
      );
      final params = UpdateProjectParams(project);
      when(mockRepository.updateProject(project)).thenAnswer((_) async => const Result.success(null));

      // Act
      final result = await useCase.call(params);

      // Assert
      verify(mockRepository.updateProject(project)).called(1);
      expect(result.isSuccess, true);
    });
  });
}