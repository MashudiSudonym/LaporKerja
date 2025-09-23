import 'package:flutter_test/flutter_test.dart';
import 'package:lapor_kerja/domain/entities/time_entry_entity.dart';

void main() {
  group('TimeEntryEntity', () {
    final testTimeEntry = TimeEntryEntity(
      id: 1,
      taskId: 1,
      startTime: DateTime(2023, 1, 1, 9, 0),
      endTime: DateTime(2023, 1, 1, 17, 0),
      duration: Duration(hours: 8),
      createdAt: DateTime(2023, 1, 1),
      updatedAt: DateTime(2023, 1, 1),
      isDeleted: false,
    );

    test('should create TimeEntryEntity instance', () {
      expect(testTimeEntry.id, 1);
      expect(testTimeEntry.taskId, 1);
      expect(testTimeEntry.startTime, DateTime(2023, 1, 1, 9, 0));
      expect(testTimeEntry.endTime, DateTime(2023, 1, 1, 17, 0));
      expect(testTimeEntry.duration, Duration(hours: 8));
      expect(testTimeEntry.isDeleted, false);
    });

    test('should serialize to JSON', () {
      final json = testTimeEntry.toJson();
      expect(json['id'], 1);
      expect(json['taskId'], 1);
      expect(json['startTime'], '2023-01-01T09:00:00.000');
      expect(json['endTime'], '2023-01-01T17:00:00.000');
      expect(json['duration'], 28800000000); // 8 hours in microseconds
      expect(json['isDeleted'], false);
    });

    test('should deserialize from JSON', () {
      final json = {
        'id': 1,
        'taskId': 1,
        'startTime': '2023-01-01T09:00:00.000',
        'endTime': '2023-01-01T17:00:00.000',
        'duration': 28800000000,
        'createdAt': '2023-01-01T00:00:00.000',
        'updatedAt': '2023-01-01T00:00:00.000',
        'isDeleted': false,
      };
      final timeEntry = TimeEntryEntity.fromJson(json);
      expect(timeEntry, testTimeEntry);
    });

    test('should support equality', () {
      final timeEntry2 = TimeEntryEntity(
        id: 1,
        taskId: 1,
        startTime: DateTime(2023, 1, 1, 9, 0),
        endTime: DateTime(2023, 1, 1, 17, 0),
        duration: Duration(hours: 8),
        createdAt: DateTime(2023, 1, 1),
        updatedAt: DateTime(2023, 1, 1),
        isDeleted: false,
      );
      expect(testTimeEntry, timeEntry2);
    });

    test('should support copyWith', () {
      final updatedTimeEntry = testTimeEntry.copyWith(duration: Duration(hours: 9));
      expect(updatedTimeEntry.duration, Duration(hours: 9));
      expect(updatedTimeEntry.id, testTimeEntry.id);
    });
  });
}