import 'package:flutter_test/flutter_test.dart';
import 'package:lapor_kerja/domain/entities/project_entity.dart';
import 'package:lapor_kerja/data/datasources/local/app_database.dart';
import 'package:lapor_kerja/data/models/local/projects.dart';
import 'package:lapor_kerja/data/mappers/project_mapper.dart';

void main() {
  group('ProjectMapper', () {
    final now = DateTime.now();

    test('toEntity converts Project to ProjectEntity', () {
      final project = Project(
        id: 1,
        remoteId: 'remote-1',
        isSynced: true,
        lastModified: now,
        isDeleted: false,
        clientId: 2,
        projectName: 'Test Project',
        description: 'Test description',
        startDate: now.subtract(const Duration(days: 1)),
        deadline: now.add(const Duration(days: 7)),
        status: 'ongoing',
        createdAt: now,
        updatedAt: now,
      );

      final entity = project.toEntity();

      expect(entity.id, 1);
      expect(entity.projectName, 'Test Project');
      expect(entity.description, 'Test description');
      expect(entity.clientId, 2);
      expect(entity.startDate, now.subtract(const Duration(days: 1)));
      expect(entity.deadline, now.add(const Duration(days: 7)));
      expect(entity.status, 'ongoing');
      expect(entity.createdAt, now);
      expect(entity.updatedAt, now);
      expect(entity.isDeleted, false);
    });

    test('toCompanion converts ProjectEntity to ProjectsCompanion with id > 0', () {
      final entity = ProjectEntity(
        id: 1,
        projectName: 'Test Project',
        description: 'Test description',
        clientId: 2,
        startDate: now.subtract(const Duration(days: 1)),
        deadline: now.add(const Duration(days: 7)),
        status: 'ongoing',
        createdAt: now,
        updatedAt: now,
        isDeleted: false,
      );

      final companion = entity.toCompanion();

      expect(companion.id.value, 1);
      expect(companion.projectName.value, 'Test Project');
      expect(companion.description.value, 'Test description');
      expect(companion.clientId.value, 2);
      expect(companion.startDate.value, now.subtract(const Duration(days: 1)));
      expect(companion.deadline.value, now.add(const Duration(days: 7)));
      expect(companion.status.value, 'ongoing');
      expect(companion.createdAt.value, now);
      expect(companion.updatedAt.value, now);
      expect(companion.isDeleted.value, false);
    });

    test('toCompanion converts ProjectEntity to ProjectsCompanion with id == 0', () {
      final entity = ProjectEntity(
        id: 0,
        projectName: 'New Project',
        description: null,
        clientId: null,
        startDate: null,
        deadline: null,
        status: null,
        createdAt: now,
        updatedAt: now,
        isDeleted: false,
      );

      final companion = entity.toCompanion();

      expect(companion.projectName.value, 'New Project');

      expect(companion.status.value, 'ongoing'); // default
      expect(companion.createdAt.value, now);
      expect(companion.updatedAt.value, now);
      expect(companion.isDeleted.value, false);
    });
  });
}