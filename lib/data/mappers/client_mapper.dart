import 'package:drift/drift.dart';
import 'package:lapor_kerja/domain/entities/client_entity.dart';
import 'package:lapor_kerja/data/datasources/local/app_database.dart';

extension ClientMapper on Client {
  ClientEntity toEntity() {
    return ClientEntity(
      id: id,
      name: name,
      contactInfo: contactInfo,
      createdAt: createdAt,
      updatedAt: updatedAt,
      isDeleted: isDeleted,
    );
  }
}

extension ClientEntityMapper on ClientEntity {
  ClientsCompanion toCompanion() {
    return ClientsCompanion(
      id: id == 0 ? const Value.absent() : Value(id),
      name: Value(name),
      contactInfo: Value(contactInfo),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      isDeleted: Value(isDeleted),
    );
  }
}