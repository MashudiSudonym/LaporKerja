import 'package:drift/drift.dart';

@DataClassName('Client')
class Clients extends Table {
  // Primary Key
  IntColumn get id => integer().autoIncrement()();
  TextColumn get remoteId => text().nullable().unique()();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  DateTimeColumn get lastModified => dateTime()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  TextColumn get name => text()();
  TextColumn get contactInfo => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}
