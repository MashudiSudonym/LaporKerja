import 'package:drift/drift.dart';
import 'package:lapor_kerja/domain/entities/task_entity.dart';
import 'package:lapor_kerja/data/datasources/local/app_database.dart';

extension TaskMapper on Task {
  TaskEntity toEntity() {
    return TaskEntity(
      id: id,
      projectId: projectId,
      taskName: taskName,
      description: description,
      status: status,
      deadline: deadline,
      createdAt: createdAt,
      updatedAt: updatedAt,
      isDeleted: isDeleted,
    );
  }
}

extension TaskEntityMapper on TaskEntity {
  TasksCompanion toCompanion() {
    return TasksCompanion(
      id: id == 0 ? const Value.absent() : Value(id),
      projectId: Value(projectId),
      taskName: Value(taskName),
      description: Value(description),
      status: Value(status ?? 'todo'),
      deadline: Value(deadline),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      isDeleted: Value(isDeleted),
    );
  }
}