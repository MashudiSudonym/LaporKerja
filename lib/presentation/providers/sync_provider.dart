import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/constants/constants.dart';
import '../../core/utils/result.dart';
import 'repositories/client_repository_provider.dart';
import 'repositories/income_repository_provider.dart';
import 'repositories/project_repository_provider.dart';
import 'repositories/task_repository_provider.dart';
import 'repositories/time_entry_repository_provider.dart';

part 'sync_provider.g.dart';

@riverpod
class SyncNotifier extends _$SyncNotifier {
  @override
  Future<void> build() async {
    // Auto-sync in background after app starts, prioritizing local data
    Future.microtask(() async {
      final result = await syncAll();
      if (result.isFailed) {
        // Log error but don't crash the app
        // UI will still work with local data
        Constants.logger.d('Auto-sync failed: ${result.errorMessage}');
      }
    });

    // Return immediately - don't block app startup
    return;
  }

  /// Sync all unsynced data to Supabase
  Future<Result<void>> syncAll() async {
    try {
      final projectRepo = ref.read(projectRepositoryProvider);
      final clientRepo = ref.read(clientRepositoryProvider);
      final taskRepo = ref.read(taskRepositoryProvider);
      final timeEntryRepo = ref.read(timeEntryRepositoryProvider);
      final incomeRepo = ref.read(incomeRepositoryProvider);

      await Future.wait([
        projectRepo.syncAllProjects(),
        clientRepo.syncAllClients(),
        taskRepo.syncAllTasks(),
        timeEntryRepo.syncAllTimeEntries(),
        incomeRepo.syncAllIncomes(),
      ]);

      return const Result.success(null);
    } catch (e) {
      return Result.failed('Sync failed: $e');
    }
  }
}