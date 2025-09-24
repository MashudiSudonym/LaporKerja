import 'package:drift/drift.dart';
import 'package:lapor_kerja/domain/entities/project_entity.dart';
import 'package:lapor_kerja/data/datasources/local/app_database.dart';

extension ProjectMapper on Project {
  ProjectEntity toEntity() {
    return ProjectEntity(
      id: id,
      projectName: projectName,
      description: description,
      clientId: clientId,
      startDate: startDate,
      deadline: deadline,
      status: status,
      createdAt: createdAt,
      updatedAt: updatedAt,
      isDeleted: isDeleted,
    );
  }
}

extension ProjectEntityMapper on ProjectEntity {
  ProjectsCompanion toCompanion() {
    return ProjectsCompanion(
      id: id == 0 ? const Value.absent() : Value(id),
      projectName: Value(projectName),
      description: Value(description),
      clientId: Value(clientId),
      startDate: Value(startDate),
      deadline: Value(deadline),
      status: Value(status ?? 'ongoing'),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      isDeleted: Value(isDeleted),
    );
  }
}
