import 'package:flutter_test/flutter_test.dart';
import 'package:lapor_kerja/core/utils/result.dart';
import 'package:lapor_kerja/domain/entities/project_entity.dart';
import 'package:lapor_kerja/domain/repositories/project_repository.dart';
import 'package:lapor_kerja/domain/usecases/project/add_project/add_project_params.dart';
import 'package:lapor_kerja/domain/usecases/project/add_project/add_project_usecase.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'add_project_usecase_test.mocks.dart';

@GenerateMocks([ProjectRepository], customMocks: [MockSpec<ProjectRepository>(as: #MockProjectRepositoryForAdd)])
void main() {
  late AddProjectUseCase useCase;
  late MockProjectRepositoryForAdd mockRepository;

  setUp(() {
    mockRepository = MockProjectRepositoryForAdd();
    useCase = AddProjectUseCase(mockRepository);
  });

  setUpAll(() {
    provideDummy<Result<void>>(const Result.failed('dummy'));
  });

  group('AddProjectUseCase', () {
    test('should call repository.createProject with correct params', () async {
      // Arrange
      final project = ProjectEntity(
        id: 1,
        projectName: 'Test Project',
        clientId: 1,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isDeleted: false,
      );
      final params = AddProjectParams(project);
      when(mockRepository.createProject(project)).thenAnswer((_) async => const Result.success(null));

      // Act
      final result = await useCase.call(params);

      // Assert
      verify(mockRepository.createProject(project)).called(1);
      expect(result.isSuccess, true);
    });
  });
}