import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/datasources/local/app_database.dart';

part 'app_database_provider.g.dart';

@Riverpod(keepAlive: true)
AppDatabase appDatabase(Ref ref) {
  return AppDatabase.instance;
}
