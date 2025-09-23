import 'package:freezed_annotation/freezed_annotation.dart';

part 'task_entity.freezed.dart';
part 'task_entity.g.dart';

@freezed
abstract class TaskEntity with _$TaskEntity {
  const factory TaskEntity({
    required int id,
    required int projectId,
    required String taskName,
    String? description,
    String? status,
    DateTime? deadline,
    required DateTime createdAt,
    required DateTime updatedAt,
    required bool isDeleted,
  }) = _TaskEntity;

  factory TaskEntity.fromJson(Map<String, dynamic> json) =>
      _$TaskEntityFromJson(json);
}
