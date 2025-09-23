import '../../domain/entities/project_entity.dart';

abstract interface class ProjectRepository {
  Stream<List<ProjectEntity>> watchAllProjects();
  Future<ProjectEntity?> getProjectById(int id);
  Future<void> createProject(ProjectEntity project);
  Future<void> updateProject(ProjectEntity project);
  Future<void> softDeleteProject(int id);
  Future<List<ProjectEntity>> getUnsyncedProjects();
  Future<void> markProjectAsSynced(int id);
}
