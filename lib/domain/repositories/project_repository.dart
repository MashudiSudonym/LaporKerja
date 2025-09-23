import '../../core/utils/result.dart';
import '../../domain/entities/project_entity.dart';

abstract interface class ProjectRepository {
  Stream<List<ProjectEntity>> watchAllProjects();
  Future<Result<ProjectEntity>> getProjectById(int id);
  Future<Result<void>> createProject(ProjectEntity project);
  Future<Result<void>> updateProject(ProjectEntity project);
  Future<Result<void>> softDeleteProject(int id);
  Future<Result<List<ProjectEntity>>> getUnsyncedProjects();
  Future<Result<void>> markProjectAsSynced(int id);
}
