import 'package:flutter_test/flutter_test.dart';
import 'package:lapor_kerja/domain/entities/project_entity.dart';

void main() {
  group('ProjectEntity', () {
    final testProject = ProjectEntity(
      id: 1,
      projectName: 'Test Project',
      description: 'A test project',
      clientId: 1,
      startDate: DateTime(2023, 1, 1),
      deadline: DateTime(2023, 12, 31),
      status: 'active',
      createdAt: DateTime(2023, 1, 1),
      updatedAt: DateTime(2023, 1, 1),
      isDeleted: false,
    );

    test('should create ProjectEntity instance', () {
      expect(testProject.id, 1);
      expect(testProject.projectName, 'Test Project');
      expect(testProject.description, 'A test project');
      expect(testProject.status, 'active');
      expect(testProject.isDeleted, false);
    });

    test('should serialize to JSON', () {
      final json = testProject.toJson();
      expect(json['id'], 1);
      expect(json['projectName'], 'Test Project');
      expect(json['description'], 'A test project');
      expect(json['status'], 'active');
      expect(json['isDeleted'], false);
    });

    test('should deserialize from JSON', () {
      final json = {
        'id': 1,
        'projectName': 'Test Project',
        'description': 'A test project',
        'clientId': 1,
        'startDate': '2023-01-01T00:00:00.000',
        'deadline': '2023-12-31T00:00:00.000',
        'status': 'active',
        'createdAt': '2023-01-01T00:00:00.000',
        'updatedAt': '2023-01-01T00:00:00.000',
        'isDeleted': false,
      };
      final project = ProjectEntity.fromJson(json);
      expect(project, testProject);
    });

    test('should support equality', () {
      final project2 = ProjectEntity(
        id: 1,
        projectName: 'Test Project',
        description: 'A test project',
        clientId: 1,
        startDate: DateTime(2023, 1, 1),
        deadline: DateTime(2023, 12, 31),
        status: 'active',
        createdAt: DateTime(2023, 1, 1),
        updatedAt: DateTime(2023, 1, 1),
        isDeleted: false,
      );
      expect(testProject, project2);
    });

    test('should support copyWith', () {
      final updatedProject = testProject.copyWith(projectName: 'Updated Project');
      expect(updatedProject.projectName, 'Updated Project');
      expect(updatedProject.id, testProject.id);
    });
  });
}