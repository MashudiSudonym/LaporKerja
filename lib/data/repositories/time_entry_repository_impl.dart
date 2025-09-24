import 'package:drift/drift.dart';
import 'package:lapor_kerja/core/utils/result.dart';
import 'package:lapor_kerja/data/datasources/local/app_database.dart';
import 'package:lapor_kerja/data/datasources/local/dao/time_entries_dao.dart';
import 'package:lapor_kerja/data/mappers/time_entry_mapper.dart';
import 'package:lapor_kerja/domain/entities/time_entry_entity.dart';
import 'package:lapor_kerja/domain/repositories/time_entry_repository.dart';

class TimeEntryRepositoryImpl implements TimeEntryRepository {
  final TimeEntriesDao _timeEntriesDao;

  TimeEntryRepositoryImpl(this._timeEntriesDao);

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
      await _timeEntriesDao.upsertTimeEntry(timeEntry.toCompanion());
      return const Result.success(null);
    } catch (e) {
      return Result.failed('Failed to create time entry: $e');
    }
  }

  @override
  Future<Result<void>> updateTimeEntry(TimeEntryEntity timeEntry) async {
    try {
      await _timeEntriesDao.upsertTimeEntry(timeEntry.toCompanion());
      return const Result.success(null);
    } catch (e) {
      return Result.failed('Failed to update time entry: $e');
    }
  }

  @override
  Future<Result<void>> softDeleteTimeEntry(int id) async {
    try {
      await _timeEntriesDao.softDeleteTimeEntry(id);
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
}