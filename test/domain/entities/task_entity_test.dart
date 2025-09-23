import 'package:flutter_test/flutter_test.dart';
import 'package:lapor_kerja/domain/entities/task_entity.dart';

void main() {
  group('TaskEntity', () {
    final testTask = TaskEntity(
      id: 1,
      projectId: 1,
      taskName: 'Test Task',
      description: 'A test task',
      status: 'pending',
      deadline: DateTime(2023, 12, 31),
      createdAt: DateTime(2023, 1, 1),
      updatedAt: DateTime(2023, 1, 1),
      isDeleted: false,
    );

    test('should create TaskEntity instance', () {
      expect(testTask.id, 1);
      expect(testTask.projectId, 1);
      expect(testTask.taskName, 'Test Task');
      expect(testTask.description, 'A test task');
      expect(testTask.status, 'pending');
      expect(testTask.isDeleted, false);
    });

    test('should serialize to JSON', () {
      final json = testTask.toJson();
      expect(json['id'], 1);
      expect(json['projectId'], 1);
      expect(json['taskName'], 'Test Task');
      expect(json['description'], 'A test task');
      expect(json['status'], 'pending');
      expect(json['isDeleted'], false);
    });

    test('should deserialize from JSON', () {
      final json = {
        'id': 1,
        'projectId': 1,
        'taskName': 'Test Task',
        'description': 'A test task',
        'status': 'pending',
        'deadline': '2023-12-31T00:00:00.000',
        'createdAt': '2023-01-01T00:00:00.000',
        'updatedAt': '2023-01-01T00:00:00.000',
        'isDeleted': false,
      };
      final task = TaskEntity.fromJson(json);
      expect(task, testTask);
    });

    test('should support equality', () {
      final task2 = TaskEntity(
        id: 1,
        projectId: 1,
        taskName: 'Test Task',
        description: 'A test task',
        status: 'pending',
        deadline: DateTime(2023, 12, 31),
        createdAt: DateTime(2023, 1, 1),
        updatedAt: DateTime(2023, 1, 1),
        isDeleted: false,
      );
      expect(testTask, task2);
    });

    test('should support copyWith', () {
      final updatedTask = testTask.copyWith(taskName: 'Updated Task');
      expect(updatedTask.taskName, 'Updated Task');
      expect(updatedTask.id, testTask.id);
    });
  });
}