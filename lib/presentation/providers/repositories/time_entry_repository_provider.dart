import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:lapor_kerja/data/repositories/time_entry_repository_impl.dart';
import 'package:lapor_kerja/presentation/providers/app_database_provider.dart';
import 'package:lapor_kerja/presentation/providers/supabase_service_provider.dart';

part 'time_entry_repository_provider.g.dart';

@riverpod
TimeEntryRepositoryImpl timeEntryRepository(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  final supabaseService = ref.watch(supabaseServiceProvider);
  return TimeEntryRepositoryImpl(db.timeEntriesDao, supabaseService);
}
