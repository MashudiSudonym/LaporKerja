import 'package:flutter_test/flutter_test.dart';
import 'package:lapor_kerja/domain/entities/time_entry_entity.dart';
import 'package:lapor_kerja/data/datasources/local/app_database.dart';
import 'package:lapor_kerja/data/models/local/time_entries.dart';
import 'package:lapor_kerja/data/mappers/time_entry_mapper.dart';

void main() {
  group('TimeEntryMapper', () {
    final now = DateTime.now();
    final endTime = now.add(const Duration(hours: 2));

    test('toEntity converts TimeEntry to TimeEntryEntity with duration', () {
      final timeEntry = TimeEntry(
        id: 1,
        remoteId: 'remote-1',
        isSynced: true,
        lastModified: now,
        isDeleted: false,
        taskId: 2,
        startTime: now,
        endTime: endTime,
        createdAt: now,
        updatedAt: now,
      );

      final entity = timeEntry.toEntity();

      expect(entity.id, 1);
      expect(entity.taskId, 2);
      expect(entity.startTime, now);
      expect(entity.endTime, endTime);
      expect(entity.duration, const Duration(hours: 2));
      expect(entity.createdAt, now);
      expect(entity.updatedAt, now);
      expect(entity.isDeleted, false);
    });

    test('toEntity converts TimeEntry to TimeEntryEntity without endTime', () {
      final timeEntry = TimeEntry(
        id: 1,
        remoteId: 'remote-1',
        isSynced: true,
        lastModified: now,
        isDeleted: false,
        taskId: 2,
        startTime: now,
        endTime: null,
        createdAt: now,
        updatedAt: now,
      );

      final entity = timeEntry.toEntity();

      expect(entity.id, 1);
      expect(entity.taskId, 2);
      expect(entity.startTime, now);
      expect(entity.endTime, null);
      expect(entity.duration, null);
      expect(entity.createdAt, now);
      expect(entity.updatedAt, now);
      expect(entity.isDeleted, false);
    });

    test('toCompanion converts TimeEntryEntity to TimeEntriesCompanion with id > 0', () {
      final entity = TimeEntryEntity(
        id: 1,
        taskId: 2,
        startTime: now,
        endTime: endTime,
        duration: const Duration(hours: 2),
        createdAt: now,
        updatedAt: now,
        isDeleted: false,
      );

      final companion = entity.toCompanion();

      expect(companion.id.value, 1);
      expect(companion.taskId.value, 2);
      expect(companion.startTime.value, now);
      expect(companion.endTime.value, endTime);
      expect(companion.createdAt.value, now);
      expect(companion.updatedAt.value, now);
      expect(companion.isDeleted.value, false);
    });

    test('toCompanion converts TimeEntryEntity to TimeEntriesCompanion with id == 0', () {
      final entity = TimeEntryEntity(
        id: 0,
        taskId: 2,
        startTime: now,
        endTime: null,
        duration: null,
        createdAt: now,
        updatedAt: now,
        isDeleted: false,
      );

      final companion = entity.toCompanion();

      expect(companion.taskId.value, 2);
      expect(companion.startTime.value, now);

      expect(companion.createdAt.value, now);
      expect(companion.updatedAt.value, now);
      expect(companion.isDeleted.value, false);
    });
  });
}