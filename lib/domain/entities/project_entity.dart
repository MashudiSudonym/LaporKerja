import 'package:freezed_annotation/freezed_annotation.dart';

part 'project_entity.freezed.dart';
part 'project_entity.g.dart';

@freezed
abstract class ProjectEntity with _$ProjectEntity {
  const factory ProjectEntity({
    required int id,
    required String projectName,
    String? description,
    int? clientId,
    DateTime? startDate,
    DateTime? deadline,
    String? status,
    required DateTime createdAt,
    required DateTime updatedAt,
    required bool isDeleted,
  }) = _ProjectEntity;

  factory ProjectEntity.fromJson(Map<String, dynamic> json) =>
      _$ProjectEntityFromJson(json);
}
