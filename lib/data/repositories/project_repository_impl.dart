import 'package:drift/drift.dart';
import 'package:lapor_kerja/core/utils/result.dart';
import 'package:lapor_kerja/data/datasources/local/app_database.dart';
import 'package:lapor_kerja/data/datasources/local/dao/projects_dao.dart';
import 'package:lapor_kerja/data/mappers/project_mapper.dart';
import 'package:lapor_kerja/domain/entities/project_entity.dart';
import 'package:lapor_kerja/domain/repositories/project_repository.dart';

class ProjectRepositoryImpl implements ProjectRepository {
  final ProjectsDao _projectsDao;

  ProjectRepositoryImpl(this._projectsDao);

  @override
  Stream<List<ProjectEntity>> watchAllProjects() {
    return _projectsDao.watchAllProjectsWithClient().map(
          (projectWithClients) => projectWithClients
              .where((pwc) => !pwc.project.isDeleted)
              .map((pwc) => pwc.project.toEntity())
              .toList(),
        );
  }

  @override
  Future<Result<ProjectEntity>> getProjectById(int id) async {
    try {
      final projectWithClients =
          await _projectsDao.watchAllProjectsWithClient().first;
      final projectWithClient = projectWithClients
          .where((pwc) => pwc.project.id == id && !pwc.project.isDeleted)
          .firstOrNull;

      if (projectWithClient == null) {
        return const Result.failed('Project not found');
      }

      return Result.success(projectWithClient.project.toEntity());
    } catch (e) {
      return Result.failed('Failed to get project: $e');
    }
  }

  @override
  Future<Result<void>> createProject(ProjectEntity project) async {
    try {
      await _projectsDao.upsertProject(project.toCompanion());
      return const Result.success(null);
    } catch (e) {
      return Result.failed('Failed to create project: $e');
    }
  }

  @override
  Future<Result<void>> updateProject(ProjectEntity project) async {
    try {
      await _projectsDao.upsertProject(project.toCompanion());
      return const Result.success(null);
    } catch (e) {
      return Result.failed('Failed to update project: $e');
    }
  }

  @override
  Future<Result<void>> softDeleteProject(int id) async {
    try {
      await _projectsDao.softDeleteProject(id);
      return const Result.success(null);
    } catch (e) {
      return Result.failed('Failed to delete project: $e');
    }
  }

  @override
  Future<Result<List<ProjectEntity>>> getUnsyncedProjects() async {
    try {
      final projects = await _projectsDao.getUnsyncedProjects();
      final entities = projects.map((p) => p.toEntity()).toList();
      return Result.success(entities);
    } catch (e) {
      return Result.failed('Failed to get unsynced projects: $e');
    }
  }

  @override
  Future<Result<void>> markProjectAsSynced(int id) async {
    try {
      await _projectsDao.upsertProject(
        ProjectsCompanion(
          id: Value(id),
          isSynced: const Value(true),
          lastModified: Value(DateTime.now()),
        ),
      );
      return const Result.success(null);
    } catch (e) {
      return Result.failed('Failed to mark project as synced: $e');
    }
  }
}