import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:lapor_kerja/data/repositories/project_repository_impl.dart';
import 'package:lapor_kerja/presentation/providers/app_database_provider.dart';

part 'project_repository_provider.g.dart';

@riverpod
ProjectRepositoryImpl projectRepository(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return ProjectRepositoryImpl(db.projectsDao);
}