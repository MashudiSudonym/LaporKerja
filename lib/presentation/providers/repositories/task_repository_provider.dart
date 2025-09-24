import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:lapor_kerja/data/repositories/task_repository_impl.dart';
import 'package:lapor_kerja/presentation/providers/app_database_provider.dart';
import 'package:lapor_kerja/presentation/providers/supabase_service_provider.dart';

part 'task_repository_provider.g.dart';

@riverpod
TaskRepositoryImpl taskRepository(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  final supabaseService = ref.watch(supabaseServiceProvider);
  final connectivity = Connectivity();
  return TaskRepositoryImpl(db.tasksDao, supabaseService, connectivity);
}