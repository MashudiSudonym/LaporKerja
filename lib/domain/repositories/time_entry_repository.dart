import '../../domain/entities/time_entry_entity.dart';

abstract class TimeEntryRepository {
  Stream<List<TimeEntryEntity>> watchTimeEntriesForTask(int taskId);
  Future<TimeEntryEntity?> getTimeEntryById(int id);
  Future<void> createTimeEntry(TimeEntryEntity timeEntry);
  Future<void> updateTimeEntry(TimeEntryEntity timeEntry);
  Future<void> softDeleteTimeEntry(int id);
  Future<List<TimeEntryEntity>> getUnsyncedTimeEntries();
  Future<void> markTimeEntryAsSynced(int id);
}