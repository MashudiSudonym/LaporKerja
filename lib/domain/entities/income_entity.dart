import 'package:freezed_annotation/freezed_annotation.dart';

part 'income_entity.freezed.dart';
part 'income_entity.g.dart';

@freezed
abstract class IncomeEntity with _$IncomeEntity {
  const factory IncomeEntity({
    required int id,
    required int projectId,
    required double amount,
    String? paymentStatus,
    DateTime? paymentDate,
    required DateTime createdAt,
    required DateTime updatedAt,
    required bool isDeleted,
  }) = _IncomeEntity;

  factory IncomeEntity.fromJson(Map<String, dynamic> json) =>
      _$IncomeEntityFromJson(json);
}
