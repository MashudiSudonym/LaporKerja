import 'package:drift/drift.dart';
import '../app_database.dart';
import '../../../models/local/tasks.dart';

part 'tasks_dao.g.dart';

@DriftAccessor(tables: [Tasks])
class TasksDao extends DatabaseAccessor<AppDatabase> with _$TasksDaoMixin {
  TasksDao(super.db);

  Stream<List<Task>> watchAllTasks() {
    return select(tasks).watch();
  }

  Stream<List<Task>> watchTasksForProject(int projectId) {
    return (select(tasks)..where((t) => t.projectId.equals(projectId))).watch();
  }

  Future<List<Task>> getUnsyncedTasks() {
    return (select(tasks)..where((t) => t.isSynced.equals(false))).get();
  }

  Future<int> upsertTask(TasksCompanion entry) {
    return into(tasks).insertOnConflictUpdate(entry);
  }

  Future<int> softDeleteTask(int id) {
    return (update(tasks)..where((t) => t.id.equals(id))).write(
      TasksCompanion(
        isDeleted: const Value(true),
        lastModified: Value(DateTime.now()),
      ),
    );
  }
}
