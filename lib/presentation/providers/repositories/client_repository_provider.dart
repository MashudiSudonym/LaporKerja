import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:lapor_kerja/data/repositories/client_repository_impl.dart';
import 'package:lapor_kerja/presentation/providers/app_database_provider.dart';

part 'client_repository_provider.g.dart';

@riverpod
ClientRepositoryImpl clientRepository(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return ClientRepositoryImpl(db.clientsDao);
}