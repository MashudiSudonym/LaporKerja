import 'package:drift/drift.dart';
import 'package:lapor_kerja/core/utils/result.dart';
import 'package:lapor_kerja/data/datasources/local/app_database.dart';
import 'package:lapor_kerja/data/datasources/local/dao/incomes_dao.dart';
import 'package:lapor_kerja/data/mappers/income_mapper.dart';
import 'package:lapor_kerja/data/services/supabase_service.dart';
import 'package:lapor_kerja/domain/entities/income_entity.dart';
import 'package:lapor_kerja/domain/repositories/income_repository.dart';

class IncomeRepositoryImpl implements IncomeRepository {
  final IncomesDao _incomesDao;
  final SupabaseService _supabaseService;

  IncomeRepositoryImpl(this._incomesDao, this._supabaseService);

  @override
  Stream<List<IncomeEntity>> watchAllIncomes() {
    return _incomesDao.watchAllIncomes().map(
          (incomes) => incomes.map((income) => income.toEntity()).toList(),
        );
  }

  @override
  Stream<List<IncomeEntity>> watchIncomesForProject(int projectId) {
    return _incomesDao.watchIncomesForProject(projectId).map(
          (incomes) => incomes.map((income) => income.toEntity()).toList(),
        );
  }

  @override
  Future<Result<IncomeEntity>> getIncomeById(int id) async {
    try {
      final income = await _incomesDao.getIncomeById(id);
      if (income == null) {
        return const Result.failed('Income not found');
      }
      return Result.success(income.toEntity());
    } catch (e) {
      return Result.failed('Failed to get income: $e');
    }
  }

  @override
  Future<Result<void>> createIncome(IncomeEntity income) async {
    try {
      await _incomesDao.upsertIncome(income.toCompanion());
      // Try to sync in background
      _supabaseService.syncIncomes(this);
      return const Result.success(null);
    } catch (e) {
      return Result.failed('Failed to create income: $e');
    }
  }

  @override
  Future<Result<void>> updateIncome(IncomeEntity income) async {
    try {
      await _incomesDao.upsertIncome(income.toCompanion());
      return const Result.success(null);
    } catch (e) {
      return Result.failed('Failed to update income: $e');
    }
  }

  @override
  Future<Result<void>> softDeleteIncome(int id) async {
    try {
      await _incomesDao.softDeleteIncome(id);
      return const Result.success(null);
    } catch (e) {
      return Result.failed('Failed to delete income: $e');
    }
  }

  @override
  Future<Result<List<IncomeEntity>>> getUnsyncedIncomes() async {
    try {
      final incomes = await _incomesDao.getUnsyncedIncomes();
      final entities = incomes.map((i) => i.toEntity()).toList();
      return Result.success(entities);
    } catch (e) {
      return Result.failed('Failed to get unsynced incomes: $e');
    }
  }

  @override
  Future<Result<void>> markIncomeAsSynced(int id) async {
    try {
      await _incomesDao.upsertIncome(
        IncomesCompanion(
          id: Value(id),
          isSynced: const Value(true),
          lastModified: Value(DateTime.now()),
        ),
      );
      return const Result.success(null);
    } catch (e) {
      return Result.failed('Failed to mark income as synced: $e');
    }
  }
}