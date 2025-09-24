import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:lapor_kerja/data/repositories/task_repository_impl.dart';
import 'package:lapor_kerja/presentation/providers/app_database_provider.dart';

part 'task_repository_provider.g.dart';

@riverpod
TaskRepositoryImpl taskRepository(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return TaskRepositoryImpl(db.tasksDao);
}