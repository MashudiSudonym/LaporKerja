import 'package:drift/drift.dart';
import '../app_database.dart';
import '../../../models/local/time_entries.dart';

part 'time_entries_dao.g.dart';

@DriftAccessor(tables: [TimeEntries])
class TimeEntriesDao extends DatabaseAccessor<AppDatabase>
    with _$TimeEntriesDaoMixin {
  TimeEntriesDao(super.db);

  Stream<List<TimeEntry>> watchAllTimeEntries() {
    return select(timeEntries).watch();
  }

  Stream<List<TimeEntry>> watchTimeEntriesForTask(int taskId) {
    return (select(
      timeEntries,
    )..where((te) => te.taskId.equals(taskId))).watch();
  }

  Future<List<TimeEntry>> getUnsyncedTimeEntries() {
    return (select(
      timeEntries,
    )..where((te) => te.isSynced.equals(false))).get();
  }

  Future<int> upsertTimeEntry(TimeEntriesCompanion entry) {
    return into(timeEntries).insertOnConflictUpdate(entry);
  }

  Future<int> softDeleteTimeEntry(int id) {
    return (update(timeEntries)..where((te) => te.id.equals(id))).write(
      TimeEntriesCompanion(
        isDeleted: const Value(true),
        lastModified: Value(DateTime.now()),
      ),
    );
  }
}
