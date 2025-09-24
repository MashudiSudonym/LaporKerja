import 'package:riverpod_annotation/riverpod_annotation.dart';


import 'repositories/client_repository_provider.dart';
import 'repositories/income_repository_provider.dart';
import 'repositories/project_repository_provider.dart';
import 'repositories/task_repository_provider.dart';
import 'repositories/time_entry_repository_provider.dart';
import 'supabase_service_provider.dart';

part 'sync_provider.g.dart';

@riverpod
class SyncNotifier extends _$SyncNotifier {
  @override
  Future<void> build() async {
    // No initial state
  }

  Future<void> syncAll() async {
    final supabaseService = ref.read(supabaseServiceProvider);
    final projectRepo = ref.read(projectRepositoryProvider);
    final clientRepo = ref.read(clientRepositoryProvider);
    final taskRepo = ref.read(taskRepositoryProvider);
    final timeEntryRepo = ref.read(timeEntryRepositoryProvider);
    final incomeRepo = ref.read(incomeRepositoryProvider);

    await Future.wait([
      supabaseService.syncProjects(projectRepo),
      supabaseService.syncClients(clientRepo),
      supabaseService.syncTasks(taskRepo),
      supabaseService.syncTimeEntries(timeEntryRepo),
      supabaseService.syncIncomes(incomeRepo),
    ]);
  }
}