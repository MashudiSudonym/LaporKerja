import 'package:freezed_annotation/freezed_annotation.dart';

part 'client_entity.freezed.dart';
part 'client_entity.g.dart';

@freezed
abstract class ClientEntity with _$ClientEntity {
  const factory ClientEntity({
    required int id,
    required String name,
    String? contactInfo,
    required DateTime createdAt,
    required DateTime updatedAt,
    required bool isDeleted,
  }) = _ClientEntity;

  factory ClientEntity.fromJson(Map<String, dynamic> json) =>
      _$ClientEntityFromJson(json);
}
