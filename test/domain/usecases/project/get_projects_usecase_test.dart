import 'package:flutter_test/flutter_test.dart';
import 'package:lapor_kerja/domain/entities/project_entity.dart';
import 'package:lapor_kerja/domain/repositories/project_repository.dart';
import 'package:lapor_kerja/domain/usecases/project/get_projects_usecase.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_projects_usecase_test.mocks.dart';

@GenerateMocks([ProjectRepository], customMocks: [MockSpec<ProjectRepository>(as: #MockProjectRepositoryForGet)])
void main() {
  late GetProjectsUseCase useCase;
  late MockProjectRepositoryForGet mockRepository;

  setUp(() {
    mockRepository = MockProjectRepositoryForGet();
    useCase = GetProjectsUseCase(mockRepository);
  });

  group('GetProjectsUseCase', () {
    test('should return stream from repository.watchAllProjects', () {
      // Arrange
      final projects = [
        ProjectEntity(
          id: 1,
          projectName: 'Project 1',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          isDeleted: false,
        ),
      ];
      when(mockRepository.watchAllProjects()).thenAnswer((_) => Stream.value(projects));

      // Act
      final result = useCase.call();

      // Assert
      expect(result, isA<Stream<List<ProjectEntity>>>());
      verify(mockRepository.watchAllProjects()).called(1);
    });
  });
}