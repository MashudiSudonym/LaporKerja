import '../../domain/entities/income_entity.dart';

abstract interface class IncomeRepository {
  Stream<List<IncomeEntity>> watchAllIncomes();
  Stream<List<IncomeEntity>> watchIncomesForProject(int projectId);
  Future<IncomeEntity?> getIncomeById(int id);
  Future<void> createIncome(IncomeEntity income);
  Future<void> updateIncome(IncomeEntity income);
  Future<void> softDeleteIncome(int id);
  Future<List<IncomeEntity>> getUnsyncedIncomes();
  Future<void> markIncomeAsSynced(int id);
}
