import 'package:freezed_annotation/freezed_annotation.dart';

part 'time_entry_entity.freezed.dart';
part 'time_entry_entity.g.dart';

@freezed
abstract class TimeEntryEntity with _$TimeEntryEntity {
  const factory TimeEntryEntity({
    required int id,
    required int taskId,
    required DateTime startTime,
    DateTime? endTime,
    Duration? duration,
    required DateTime createdAt,
    required DateTime updatedAt,
    required bool isDeleted,
  }) = _TimeEntryEntity;

  factory TimeEntryEntity.fromJson(Map<String, dynamic> json) =>
      _$TimeEntryEntityFromJson(json);
}
