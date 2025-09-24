import 'package:flutter_test/flutter_test.dart';
import 'package:lapor_kerja/domain/entities/task_entity.dart';
import 'package:lapor_kerja/data/datasources/local/app_database.dart';
import 'package:lapor_kerja/data/mappers/task_mapper.dart';

void main() {
  group('TaskMapper', () {
    final now = DateTime.now();

    test('toEntity converts Task to TaskEntity', () {
      final task = Task(
        id: 1,
        remoteId: 'remote-1',
        isSynced: true,
        lastModified: now,
        isDeleted: false,
        projectId: 2,
        taskName: 'Test Task',
        description: 'Test description',
        status: 'in_progress',
        deadline: now.add(const Duration(days: 3)),
        createdAt: now,
        updatedAt: now,
      );

      final entity = task.toEntity();

      expect(entity.id, 1);
      expect(entity.projectId, 2);
      expect(entity.taskName, 'Test Task');
      expect(entity.description, 'Test description');
      expect(entity.status, 'in_progress');
      expect(entity.deadline, now.add(const Duration(days: 3)));
      expect(entity.createdAt, now);
      expect(entity.updatedAt, now);
      expect(entity.isDeleted, false);
    });

    test('toCompanion converts TaskEntity to TasksCompanion with id > 0', () {
      final entity = TaskEntity(
        id: 1,
        projectId: 2,
        taskName: 'Test Task',
        description: 'Test description',
        status: 'in_progress',
        deadline: now.add(const Duration(days: 3)),
        createdAt: now,
        updatedAt: now,
        isDeleted: false,
      );

      final companion = entity.toCompanion();

      expect(companion.id.value, 1);
      expect(companion.projectId.value, 2);
      expect(companion.taskName.value, 'Test Task');
      expect(companion.description.value, 'Test description');
      expect(companion.status.value, 'in_progress');
      expect(companion.deadline.value, now.add(const Duration(days: 3)));
      expect(companion.createdAt.value, now);
      expect(companion.updatedAt.value, now);
      expect(companion.isDeleted.value, false);
    });

    test('toCompanion converts TaskEntity to TasksCompanion with id == 0', () {
      final entity = TaskEntity(
        id: 0,
        projectId: 2,
        taskName: 'New Task',
        description: null,
        status: null,
        deadline: null,
        createdAt: now,
        updatedAt: now,
        isDeleted: false,
      );

      final companion = entity.toCompanion();

      expect(companion.projectId.value, 2);
      expect(companion.taskName.value, 'New Task');
      expect(companion.status.value, 'todo'); // default
      expect(companion.createdAt.value, now);
      expect(companion.updatedAt.value, now);
      expect(companion.isDeleted.value, false);
    });
  });
}
