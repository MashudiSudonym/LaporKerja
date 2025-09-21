import 'package:drift/drift.dart';
import 'package:lapor_kerja/data/models/local/clients.dart';

@DataClassName('Project')
class Projects extends Table {
  // Primary Key
  IntColumn get id => integer().autoIncrement()();
  TextColumn get remoteId => text().nullable().unique()();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  DateTimeColumn get lastModified => dateTime()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  IntColumn get clientId => integer().nullable().references(Clients, #id, onDelete: KeyAction.setNull)();
  TextColumn get projectName => text()();
  TextColumn get description => text().nullable()();
  DateTimeColumn get startDate => dateTime().nullable()();
  DateTimeColumn get deadline => dateTime().nullable()();
  TextColumn get status => text().withDefault(const Constant('ongoing'))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}