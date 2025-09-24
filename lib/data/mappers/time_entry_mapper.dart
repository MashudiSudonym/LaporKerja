import 'package:drift/drift.dart';
import 'package:lapor_kerja/domain/entities/time_entry_entity.dart';
import 'package:lapor_kerja/data/datasources/local/app_database.dart';

extension TimeEntryMapper on TimeEntry {
  TimeEntryEntity toEntity() {
    return TimeEntryEntity(
      id: id,
      taskId: taskId,
      startTime: startTime,
      endTime: endTime,
      duration: endTime?.difference(startTime),
      createdAt: createdAt,
      updatedAt: updatedAt,
      isDeleted: isDeleted,
    );
  }
}

extension TimeEntryEntityMapper on TimeEntryEntity {
  TimeEntriesCompanion toCompanion() {
    return TimeEntriesCompanion(
      id: id == 0 ? const Value.absent() : Value(id),
      taskId: Value(taskId),
      startTime: Value(startTime),
      endTime: Value(endTime),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      isDeleted: Value(isDeleted),
    );
  }
}