import 'package:drift/drift.dart';
import 'package:lapor_kerja/data/models/local/projects.dart';

@DataClassName('Income')
class Incomes extends Table {
  // Primary Key
  IntColumn get id => integer().autoIncrement()();
  TextColumn get remoteId => text().nullable().unique()();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  DateTimeColumn get lastModified => dateTime()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  IntColumn get projectId => integer().references(Projects, #id, onDelete: KeyAction.cascade)();
  RealColumn get amount => real()();
  TextColumn get paymentStatus => text().withDefault(const Constant('unpaid'))();
  DateTimeColumn get paymentDate => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}