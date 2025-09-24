import 'package:drift/drift.dart';
import 'package:lapor_kerja/domain/entities/income_entity.dart';
import 'package:lapor_kerja/data/datasources/local/app_database.dart';

extension IncomeMapper on Income {
  IncomeEntity toEntity() {
    return IncomeEntity(
      id: id,
      projectId: projectId,
      amount: amount,
      paymentStatus: paymentStatus,
      paymentDate: paymentDate,
      createdAt: createdAt,
      updatedAt: updatedAt,
      isDeleted: isDeleted,
    );
  }
}

extension IncomeEntityMapper on IncomeEntity {
  IncomesCompanion toCompanion() {
    return IncomesCompanion(
      id: id == 0 ? const Value.absent() : Value(id),
      projectId: Value(projectId),
      amount: Value(amount),
      paymentStatus: Value(paymentStatus ?? 'unpaid'),
      paymentDate: Value(paymentDate),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      isDeleted: Value(isDeleted),
    );
  }
}