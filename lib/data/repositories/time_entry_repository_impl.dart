import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:drift/drift.dart';
import 'package:lapor_kerja/core/utils/result.dart';
import 'package:lapor_kerja/data/datasources/local/app_database.dart';
import 'package:lapor_kerja/data/datasources/local/dao/time_entries_dao.dart';
import 'package:lapor_kerja/data/mappers/time_entry_mapper.dart';
import 'package:lapor_kerja/data/services/supabase_service.dart';
import 'package:lapor_kerja/domain/entities/time_entry_entity.dart';
import 'package:lapor_kerja/domain/repositories/time_entry_repository.dart';

import '../../core/constants/constants.dart';

class TimeEntryRepositoryImpl implements TimeEntryRepository {
  final TimeEntriesDao _timeEntriesDao;
  final SupabaseService _supabaseService;
  final Connectivity _connectivity;

  TimeEntryRepositoryImpl(this._timeEntriesDao, this._supabaseService, this._connectivity);

  @override
  Stream<List<TimeEntryEntity>> watchAllTimeEntries() {
    return _timeEntriesDao.watchAllTimeEntries().map(
          (timeEntries) => timeEntries
              .where((timeEntry) => !timeEntry.isDeleted)
              .map((timeEntry) => timeEntry.toEntity())
              .toList(),
        );
  }

  @override
  Stream<List<TimeEntryEntity>> watchTimeEntriesForTask(int taskId) {
    return _timeEntriesDao.watchTimeEntriesForTask(taskId).map(
          (timeEntries) => timeEntries
              .where((timeEntry) => !timeEntry.isDeleted)
              .map((timeEntry) => timeEntry.toEntity())
              .toList(),
        );
  }

  @override
  Future<Result<TimeEntryEntity>> getTimeEntryById(int id) async {
    try {
      final timeEntries = await _timeEntriesDao.watchTimeEntriesForTask(0).first; // Get all time entries
      final timeEntry = timeEntries.where((te) => te.id == id && !te.isDeleted).firstOrNull;

      if (timeEntry == null) {
        return const Result.failed('Time entry not found');
      }

      return Result.success(timeEntry.toEntity());
    } catch (e) {
      return Result.failed('Failed to get time entry: $e');
    }
  }

  @override
  Future<Result<void>> createTimeEntry(TimeEntryEntity timeEntry) async {
    try {
      // Save locally first
      final companion = timeEntry.toCompanion();
      final companionWithUnsynced = companion.copyWith(isSynced: const Value(false));
      await _timeEntriesDao.upsertTimeEntry(companionWithUnsynced);

      // Try to sync to Supabase if online
      final connectivityResult = await _connectivity.checkConnectivity();
      if (connectivityResult != ConnectivityResult.none) {
        try {
          await _supabaseService.upsert('time_entries', timeEntry.toJson());
          await markTimeEntryAsSynced(timeEntry.id);
        } catch (e) {
          Constants.logger.e('Failed to sync time entry on create: $e');
          // isSynced remains false
        }
      }

      return const Result.success(null);
    } catch (e) {
      return Result.failed('Failed to create time entry: $e');
    }
  }

  @override
  Future<Result<void>> updateTimeEntry(TimeEntryEntity timeEntry) async {
    try {
      // Save locally first
      final companion = timeEntry.toCompanion();
      final companionWithUnsynced = companion.copyWith(isSynced: const Value(false));
      await _timeEntriesDao.upsertTimeEntry(companionWithUnsynced);

      // Try to sync to Supabase if online
      final connectivityResult = await _connectivity.checkConnectivity();
      if (connectivityResult != ConnectivityResult.none) {
        try {
          await _supabaseService.upsert('time_entries', timeEntry.toJson());
          await markTimeEntryAsSynced(timeEntry.id);
        } catch (e) {
          Constants.logger.e('Failed to sync time entry on update: $e');
          // isSynced remains false
        }
      }

      return const Result.success(null);
    } catch (e) {
      return Result.failed('Failed to update time entry: $e');
    }
  }

  @override
  Future<Result<void>> softDeleteTimeEntry(int id) async {
    try {
      // Get time entry before deleting
      final timeEntryResult = await getTimeEntryById(id);
      if (timeEntryResult.isFailed) return timeEntryResult;

      final timeEntry = timeEntryResult.resultValue!;
      final updatedTimeEntry = timeEntry.copyWith(isDeleted: true);

      // Save locally first
      final companion = updatedTimeEntry.toCompanion();
      final companionWithUnsynced = companion.copyWith(isSynced: const Value(false));
      await _timeEntriesDao.upsertTimeEntry(companionWithUnsynced);

      // Try to sync to Supabase if online
      final connectivityResult = await _connectivity.checkConnectivity();
      if (connectivityResult != ConnectivityResult.none) {
        try {
          await _supabaseService.upsert('time_entries', updatedTimeEntry.toJson());
          await markTimeEntryAsSynced(id);
        } catch (e) {
          Constants.logger.e('Failed to sync time entry on delete: $e');
          // isSynced remains false
        }
      }

      return const Result.success(null);
    } catch (e) {
      return Result.failed('Failed to delete time entry: $e');
    }
  }

  @override
  Future<Result<List<TimeEntryEntity>>> getUnsyncedTimeEntries() async {
    try {
      final timeEntries = await _timeEntriesDao.getUnsyncedTimeEntries();
      final entities = timeEntries.map((te) => te.toEntity()).toList();
      return Result.success(entities);
    } catch (e) {
      return Result.failed('Failed to get unsynced time entries: $e');
    }
  }

  @override
  Future<Result<void>> markTimeEntryAsSynced(int id) async {
    try {
      await _timeEntriesDao.upsertTimeEntry(
        TimeEntriesCompanion(
          id: Value(id),
          isSynced: const Value(true),
          lastModified: Value(DateTime.now()),
        ),
      );
      return const Result.success(null);
    } catch (e) {
      return Result.failed('Failed to mark time entry as synced: $e');
    }
  }

  /// Sync all unsynced time entries to Supabase
  Future<void> syncAllTimeEntries() async {
    final unsyncedResult = await getUnsyncedTimeEntries();
    if (unsyncedResult.isFailed) return;

    final unsyncedTimeEntries = unsyncedResult.resultValue!;
    await _supabaseService.syncTimeEntries(unsyncedTimeEntries);

    // Mark all as synced
    for (final timeEntry in unsyncedTimeEntries) {
      await markTimeEntryAsSynced(timeEntry.id);
    }
  }
}