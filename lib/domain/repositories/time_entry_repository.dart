import '../../core/utils/result.dart';
import '../../domain/entities/time_entry_entity.dart';

abstract class TimeEntryRepository {
  Stream<List<TimeEntryEntity>> watchTimeEntriesForTask(int taskId);
  Future<Result<TimeEntryEntity>> getTimeEntryById(int id);
  Future<Result<void>> createTimeEntry(TimeEntryEntity timeEntry);
  Future<Result<void>> updateTimeEntry(TimeEntryEntity timeEntry);
  Future<Result<void>> softDeleteTimeEntry(int id);
  Future<Result<List<TimeEntryEntity>>> getUnsyncedTimeEntries();
  Future<Result<void>> markTimeEntryAsSynced(int id);
}