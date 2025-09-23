import '../../core/utils/result.dart';
import '../../domain/entities/income_entity.dart';

abstract interface class IncomeRepository {
  Stream<List<IncomeEntity>> watchAllIncomes();
  Stream<List<IncomeEntity>> watchIncomesForProject(int projectId);
  Future<Result<IncomeEntity>> getIncomeById(int id);
  Future<Result<void>> createIncome(IncomeEntity income);
  Future<Result<void>> updateIncome(IncomeEntity income);
  Future<Result<void>> softDeleteIncome(int id);
  Future<Result<List<IncomeEntity>>> getUnsyncedIncomes();
  Future<Result<void>> markIncomeAsSynced(int id);
}
