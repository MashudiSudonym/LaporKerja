import 'package:drift/drift.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:lapor_kerja/core/utils/result.dart';
import 'package:lapor_kerja/data/datasources/local/app_database.dart';
import 'package:lapor_kerja/data/datasources/local/dao/incomes_dao.dart';
import 'package:lapor_kerja/data/mappers/income_mapper.dart';
import 'package:lapor_kerja/data/repositories/income_repository_impl.dart';
import 'package:lapor_kerja/domain/entities/income_entity.dart';

@GenerateMocks([IncomesDao])
import 'income_repository_impl_test.mocks.dart';

// Helper extension for testing
extension IncomesCompanionTestHelper on IncomesCompanion {
  Income toIncome() {
    return Income(
      id: id.value,
      remoteId: remoteId.present ? remoteId.value : null,
      isSynced: isSynced.present ? isSynced.value : false,
      lastModified: lastModified.present ? lastModified.value : DateTime.now(),
      isDeleted: isDeleted.present ? isDeleted.value : false,
      projectId: projectId.value,
      amount: amount.value,
      paymentStatus: paymentStatus.present ? paymentStatus.value : 'unpaid',
      paymentDate: paymentDate.present ? paymentDate.value : null,
      createdAt: createdAt.value,
      updatedAt: updatedAt.value,
    );
  }
}

void main() {
  late MockIncomesDao mockIncomesDao;
  late IncomeRepositoryImpl repository;

  setUp(() {
    mockIncomesDao = MockIncomesDao();
    repository = IncomeRepositoryImpl(mockIncomesDao);
  });

  group('IncomeRepositoryImpl', () {
    final testIncome = IncomeEntity(
      id: 1,
      projectId: 1,
      amount: 1000.0,
      paymentStatus: 'paid',
      paymentDate: DateTime(2023, 1, 15),
      createdAt: DateTime(2023, 1, 1),
      updatedAt: DateTime(2023, 1, 1),
      isDeleted: false,
    );

    test('should create income successfully', () async {
      when(mockIncomesDao.upsertIncome(any)).thenAnswer((_) async => 1);

      final result = await repository.createIncome(testIncome);

      expect(result.isSuccess, true);
      verify(mockIncomesDao.upsertIncome(any)).called(1);
    });

    test('should get income by id successfully', () async {
      when(mockIncomesDao.getIncomeById(1))
          .thenAnswer((_) async => testIncome.toCompanion().toIncome());

      final result = await repository.getIncomeById(1);

      expect(result.isSuccess, true);
      expect(result.resultValue?.id, 1);
      expect(result.resultValue?.amount, 1000.0);
    });

    test('should return failed result when income not found', () async {
      when(mockIncomesDao.getIncomeById(999)).thenAnswer((_) async => null);

      final result = await repository.getIncomeById(999);

      expect(result.isFailed, true);
      expect(result.errorMessage, 'Income not found');
    });

    test('should update income successfully', () async {
      when(mockIncomesDao.upsertIncome(any)).thenAnswer((_) async => 1);

      final result = await repository.updateIncome(testIncome);

      expect(result.isSuccess, true);
      verify(mockIncomesDao.upsertIncome(any)).called(1);
    });

    test('should soft delete income successfully', () async {
      when(mockIncomesDao.softDeleteIncome(1)).thenAnswer((_) async => 1);

      final result = await repository.softDeleteIncome(1);

      expect(result.isSuccess, true);
      verify(mockIncomesDao.softDeleteIncome(1)).called(1);
    });

    test('should watch all incomes', () async {
      when(mockIncomesDao.watchAllIncomes()).thenAnswer((_) => Stream.value([]));

      final stream = repository.watchAllIncomes();

      expect(stream, isA<Stream<List<IncomeEntity>>>());
    });

    test('should watch incomes for project', () async {
      when(mockIncomesDao.watchIncomesForProject(1)).thenAnswer((_) => Stream.value([]));

      final stream = repository.watchIncomesForProject(1);

      expect(stream, isA<Stream<List<IncomeEntity>>>());
    });

    test('should get unsynced incomes', () async {
      when(mockIncomesDao.getUnsyncedIncomes())
          .thenAnswer((_) async => [testIncome.toCompanion().toIncome()]);

      final result = await repository.getUnsyncedIncomes();

      expect(result.isSuccess, true);
      expect(result.resultValue?.length, 1);
      expect(result.resultValue?.first.amount, 1000.0);
    });

    test('should mark income as synced', () async {
      when(mockIncomesDao.upsertIncome(any)).thenAnswer((_) async => 1);

      final result = await repository.markIncomeAsSynced(1);

      expect(result.isSuccess, true);
      verify(mockIncomesDao.upsertIncome(any)).called(1);
    });

    test('should handle database errors gracefully', () async {
      when(mockIncomesDao.upsertIncome(any)).thenThrow(Exception('DB Error'));

      final result = await repository.createIncome(testIncome);

      expect(result.isFailed, true);
      expect(result.errorMessage?.contains('Failed to create income'), true);
    });
  });
}