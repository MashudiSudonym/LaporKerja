import 'package:flutter_test/flutter_test.dart';
import 'package:lapor_kerja/domain/entities/income_entity.dart';
import 'package:lapor_kerja/data/datasources/local/app_database.dart';
import 'package:lapor_kerja/data/models/local/incomes.dart';
import 'package:lapor_kerja/data/mappers/income_mapper.dart';

void main() {
  group('IncomeMapper', () {
    final now = DateTime.now();

    test('toEntity converts Income to IncomeEntity', () {
      final income = Income(
        id: 1,
        remoteId: 'remote-1',
        isSynced: true,
        lastModified: now,
        isDeleted: false,
        projectId: 2,
        amount: 1000.0,
        paymentStatus: 'paid',
        paymentDate: now.add(const Duration(days: 1)),
        createdAt: now,
        updatedAt: now,
      );

      final entity = income.toEntity();

      expect(entity.id, 1);
      expect(entity.projectId, 2);
      expect(entity.amount, 1000.0);
      expect(entity.paymentStatus, 'paid');
      expect(entity.paymentDate, now.add(const Duration(days: 1)));
      expect(entity.createdAt, now);
      expect(entity.updatedAt, now);
      expect(entity.isDeleted, false);
    });

    test('toCompanion converts IncomeEntity to IncomesCompanion with id > 0', () {
      final entity = IncomeEntity(
        id: 1,
        projectId: 2,
        amount: 1000.0,
        paymentStatus: 'paid',
        paymentDate: now.add(const Duration(days: 1)),
        createdAt: now,
        updatedAt: now,
        isDeleted: false,
      );

      final companion = entity.toCompanion();

      expect(companion.id.value, 1);
      expect(companion.projectId.value, 2);
      expect(companion.amount.value, 1000.0);
      expect(companion.paymentStatus.value, 'paid');
      expect(companion.paymentDate.value, now.add(const Duration(days: 1)));
      expect(companion.createdAt.value, now);
      expect(companion.updatedAt.value, now);
      expect(companion.isDeleted.value, false);
    });

    test('toCompanion converts IncomeEntity to IncomesCompanion with id == 0', () {
      final entity = IncomeEntity(
        id: 0,
        projectId: 2,
        amount: 500.0,
        paymentStatus: null,
        paymentDate: null,
        createdAt: now,
        updatedAt: now,
        isDeleted: false,
      );

      final companion = entity.toCompanion();

      expect(companion.projectId.value, 2);
      expect(companion.amount.value, 500.0);
      expect(companion.paymentStatus.value, 'unpaid'); // default

      expect(companion.createdAt.value, now);
      expect(companion.updatedAt.value, now);
      expect(companion.isDeleted.value, false);
    });
  });
}