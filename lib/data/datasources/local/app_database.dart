import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'dao/projects_dao.dart';
import '../../models/local/clients.dart';
import '../../models/local/incomes.dart';
import '../../models/local/projects.dart';
import '../../models/local/tasks.dart';
import '../../models/local/time_entries.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [
  Clients,
  Projects,
  Tasks,
  TimeEntries,
  Incomes,
],
daos: [ProjectsDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase._internal() : super(_openConnection());

  static final AppDatabase instance = AppDatabase._internal();

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'laporkerja.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
