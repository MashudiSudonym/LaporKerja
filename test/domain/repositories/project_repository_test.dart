import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:lapor_kerja/core/utils/result.dart';
import 'package:lapor_kerja/domain/entities/project_entity.dart';
import 'package:lapor_kerja/domain/repositories/project_repository.dart';

@GenerateMocks([ProjectRepository])
import 'project_repository_test.mocks.dart';

void main() {
  late MockProjectRepository mockProjectRepository;

  setUp(() {
    mockProjectRepository = MockProjectRepository();
    provideDummy<Result<ProjectEntity>>(Result.failed('dummy'));
    provideDummy<Result<void>>(Result.failed('dummy'));
    provideDummy<Result<List<ProjectEntity>>>(Result.failed('dummy'));
  });

  group('ProjectRepository', () {
    final testProject = ProjectEntity(
      id: 1,
      projectName: 'Test Project',
      description: 'Test Description',
      clientId: 1,
      startDate: DateTime(2023, 1, 1),
      deadline: DateTime(2023, 12, 31),
      status: 'ongoing',
      createdAt: DateTime(2023, 1, 1),
      updatedAt: DateTime(2023, 1, 1),
      isDeleted: false,
    );

    test('should watch all projects', () {
      when(mockProjectRepository.watchAllProjects()).thenAnswer((_) => Stream.value([testProject]));
      expect(mockProjectRepository.watchAllProjects(), isA<Stream<List<ProjectEntity>>>());
    });

    test('should get project by id', () async {
      when(mockProjectRepository.getProjectById(1)).thenAnswer((_) async => Result.success(testProject));
      final result = await mockProjectRepository.getProjectById(1);
      expect(result.isSuccess, true);
      expect(result.resultValue, testProject);
    });

    test('should create project', () async {
      when(mockProjectRepository.createProject(testProject)).thenAnswer((_) async => Result.success(null));
      await mockProjectRepository.createProject(testProject);
      verify(mockProjectRepository.createProject(testProject)).called(1);
    });

    test('should update project', () async {
      when(mockProjectRepository.updateProject(testProject)).thenAnswer((_) async => Result.success(null));
      await mockProjectRepository.updateProject(testProject);
      verify(mockProjectRepository.updateProject(testProject)).called(1);
    });

    test('should soft delete project', () async {
      when(mockProjectRepository.softDeleteProject(1)).thenAnswer((_) async => Result.success(null));
      await mockProjectRepository.softDeleteProject(1);
      verify(mockProjectRepository.softDeleteProject(1)).called(1);
    });

    test('should get unsynced projects', () async {
      when(mockProjectRepository.getUnsyncedProjects()).thenAnswer((_) async => Result.success([testProject]));
      final result = await mockProjectRepository.getUnsyncedProjects();
      expect(result.isSuccess, true);
      expect(result.resultValue, [testProject]);
    });

    test('should mark project as synced', () async {
      when(mockProjectRepository.markProjectAsSynced(1)).thenAnswer((_) async => Result.success(null));
      await mockProjectRepository.markProjectAsSynced(1);
      verify(mockProjectRepository.markProjectAsSynced(1)).called(1);
    });
  });
}