import 'package:flutter_test/flutter_test.dart';
import 'package:lapor_kerja/domain/entities/income_entity.dart';

void main() {
  group('IncomeEntity', () {
    final testIncome = IncomeEntity(
      id: 1,
      projectId: 1,
      amount: 1000.0,
      paymentStatus: 'paid',
      paymentDate: DateTime(2023, 1, 1),
      createdAt: DateTime(2023, 1, 1),
      updatedAt: DateTime(2023, 1, 1),
      isDeleted: false,
    );

    test('should create IncomeEntity instance', () {
      expect(testIncome.id, 1);
      expect(testIncome.projectId, 1);
      expect(testIncome.amount, 1000.0);
      expect(testIncome.paymentStatus, 'paid');
      expect(testIncome.isDeleted, false);
    });

    test('should serialize to JSON', () {
      final json = testIncome.toJson();
      expect(json['id'], 1);
      expect(json['projectId'], 1);
      expect(json['amount'], 1000.0);
      expect(json['paymentStatus'], 'paid');
      expect(json['isDeleted'], false);
    });

    test('should deserialize from JSON', () {
      final json = {
        'id': 1,
        'projectId': 1,
        'amount': 1000.0,
        'paymentStatus': 'paid',
        'paymentDate': '2023-01-01T00:00:00.000',
        'createdAt': '2023-01-01T00:00:00.000',
        'updatedAt': '2023-01-01T00:00:00.000',
        'isDeleted': false,
      };
      final income = IncomeEntity.fromJson(json);
      expect(income, testIncome);
    });

    test('should support equality', () {
      final income2 = IncomeEntity(
        id: 1,
        projectId: 1,
        amount: 1000.0,
        paymentStatus: 'paid',
        paymentDate: DateTime(2023, 1, 1),
        createdAt: DateTime(2023, 1, 1),
        updatedAt: DateTime(2023, 1, 1),
        isDeleted: false,
      );
      expect(testIncome, income2);
    });

    test('should support copyWith', () {
      final updatedIncome = testIncome.copyWith(amount: 2000.0);
      expect(updatedIncome.amount, 2000.0);
      expect(updatedIncome.id, testIncome.id);
    });
  });
}