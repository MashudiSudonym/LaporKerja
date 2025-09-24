import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:lapor_kerja/data/repositories/income_repository_impl.dart';
import 'package:lapor_kerja/presentation/providers/app_database_provider.dart';

part 'income_repository_provider.g.dart';

@riverpod
IncomeRepositoryImpl incomeRepository(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return IncomeRepositoryImpl(db.incomesDao);
}