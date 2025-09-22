import 'package:drift/drift.dart';
import '../app_database.dart';
import '../../../models/local/incomes.dart';

part 'incomes_dao.g.dart';

@DriftAccessor(tables: [Incomes])
class IncomesDao extends DatabaseAccessor<AppDatabase> with _$IncomesDaoMixin {
  IncomesDao(super.attachedDatabase);

  Stream<List<Income>> watchAllIncomes() {
    return (select(incomes)..where((i) => i.isDeleted.equals(false))).watch();
  }

  Stream<List<Income>> watchIncomesForProject(int projectId) {
    return (select(incomes)
          ..where((i) => i.projectId.equals(projectId) & i.isDeleted.equals(false)))
        .watch();
  }

  Future<List<Income>> getUnsyncedIncomes() {
    return (select(incomes)..where((i) => i.isSynced.equals(false))).get();
  }

  Future<int> upsertIncome(IncomesCompanion entry) {
    return into(incomes).insertOnConflictUpdate(entry);
  }

  Future<int> softDeleteIncome(int id) {
    return (update(incomes)..where((i) => i.id.equals(id))).write(
      IncomesCompanion(
        isDeleted: const Value(true),
        lastModified: Value(DateTime.now()),
      ),
    );
  }

  Future<Income?> getIncomeById(int id) {
    return (select(incomes)..where((i) => i.id.equals(id))).getSingleOrNull();
  }

  Future<Income?> getIncomeByRemoteId(String remoteId) {
    return (select(incomes)..where((i) => i.remoteId.equals(remoteId))).getSingleOrNull();
  }
}
