import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:drift/drift.dart';
import 'package:lapor_kerja/core/utils/result.dart';
import 'package:lapor_kerja/data/datasources/local/app_database.dart';
import 'package:lapor_kerja/data/datasources/local/dao/projects_dao.dart';
import 'package:lapor_kerja/data/mappers/project_mapper.dart';
import 'package:lapor_kerja/data/services/supabase_service.dart';
import 'package:lapor_kerja/domain/entities/project_entity.dart';
import 'package:lapor_kerja/domain/repositories/project_repository.dart';

import '../../core/constants/constants.dart';

class ProjectRepositoryImpl implements ProjectRepository {
  final ProjectsDao _projectsDao;
  final SupabaseService _supabaseService;
  final Connectivity _connectivity;

  ProjectRepositoryImpl(this._projectsDao, this._supabaseService, this._connectivity);

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
      // Save locally first
      final companion = project.toCompanion();
      final companionWithUnsynced = companion.copyWith(isSynced: const Value(false));
      await _projectsDao.upsertProject(companionWithUnsynced);

      // Try to sync to Supabase if online
      final connectivityResult = await _connectivity.checkConnectivity();
      if (connectivityResult != ConnectivityResult.none) {
        try {
          await _supabaseService.upsert('projects', project.toJson());
          await markProjectAsSynced(project.id);
        } catch (e) {
          Constants.logger.e('Failed to sync project on create: $e');
          // isSynced remains false
        }
      }

      return const Result.success(null);
    } catch (e) {
      return Result.failed('Failed to create project: $e');
    }
  }

  @override
  Future<Result<void>> updateProject(ProjectEntity project) async {
    try {
      // Save locally first
      final companion = project.toCompanion();
      final companionWithUnsynced = companion.copyWith(isSynced: const Value(false));
      await _projectsDao.upsertProject(companionWithUnsynced);

      // Try to sync to Supabase if online
      final connectivityResult = await _connectivity.checkConnectivity();
      if (connectivityResult != ConnectivityResult.none) {
        try {
          await _supabaseService.upsert('projects', project.toJson());
          await markProjectAsSynced(project.id);
        } catch (e) {
          Constants.logger.e('Failed to sync project on update: $e');
          // isSynced remains false
        }
      }

      return const Result.success(null);
    } catch (e) {
      return Result.failed('Failed to update project: $e');
    }
  }

  @override
  Future<Result<void>> softDeleteProject(int id) async {
    try {
      // Get project before deleting
      final projectResult = await getProjectById(id);
      if (projectResult.isFailed) return projectResult;

      final project = projectResult.resultValue!;
      final updatedProject = project.copyWith(isDeleted: true);

      // Save locally first
      final companion = updatedProject.toCompanion();
      final companionWithUnsynced = companion.copyWith(isSynced: const Value(false));
      await _projectsDao.upsertProject(companionWithUnsynced);

      // Try to sync to Supabase if online
      final connectivityResult = await _connectivity.checkConnectivity();
      if (connectivityResult != ConnectivityResult.none) {
        try {
          await _supabaseService.upsert('projects', updatedProject.toJson());
          await markProjectAsSynced(id);
        } catch (e) {
          Constants.logger.e('Failed to sync project on delete: $e');
          // isSynced remains false
        }
      }

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

  /// Sync all unsynced projects to Supabase
  Future<void> syncAllProjects() async {
    final unsyncedResult = await getUnsyncedProjects();
    if (unsyncedResult.isFailed) return;

    final unsyncedProjects = unsyncedResult.resultValue!;
    await _supabaseService.syncProjects(unsyncedProjects);

    // Mark all as synced
    for (final project in unsyncedProjects) {
      await markProjectAsSynced(project.id);
    }
  }
}