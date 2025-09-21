import 'package:drift/drift.dart';
import 'package:lapor_kerja/data/models/local/tasks.dart';

@DataClassName('TimeEntry')
class TimeEntries extends Table {
  // primary key
  IntColumn get id => integer().autoIncrement()();
  TextColumn get remoteId => text().nullable().unique()();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  DateTimeColumn get lastModified => dateTime()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  IntColumn get taskId => integer().references(Tasks, #id, onDelete: KeyAction.cascade)();
  DateTimeColumn get startTime => dateTime()();
  DateTimeColumn get endTime => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}