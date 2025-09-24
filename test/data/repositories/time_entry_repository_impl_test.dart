import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:lapor_kerja/data/datasources/local/app_database.dart';
import 'package:lapor_kerja/data/datasources/local/dao/time_entries_dao.dart';
import 'package:lapor_kerja/data/mappers/time_entry_mapper.dart';
import 'package:lapor_kerja/data/repositories/time_entry_repository_impl.dart';
import 'package:lapor_kerja/data/services/supabase_service.dart';
import 'package:lapor_kerja/domain/entities/time_entry_entity.dart';

@GenerateMocks([TimeEntriesDao, SupabaseService, Connectivity])
import 'time_entry_repository_impl_test.mocks.dart';

// Helper extension for testing
extension TimeEntriesCompanionTestHelper on TimeEntriesCompanion {
  TimeEntry toTimeEntry() {
    return TimeEntry(
      id: id.value,
      remoteId: remoteId.present ? remoteId.value : null,
      isSynced: isSynced.present ? isSynced.value : false,
      lastModified: lastModified.present ? lastModified.value : DateTime.now(),
      isDeleted: isDeleted.present ? isDeleted.value : false,
      taskId: taskId.value,
      startTime: startTime.value,
      endTime: endTime.present ? endTime.value : null,
      createdAt: createdAt.value,
      updatedAt: updatedAt.value,
    );
  }
}

void main() {
  late MockTimeEntriesDao mockTimeEntriesDao;
  late MockSupabaseService mockSupabaseService;
  late MockConnectivity mockConnectivity;
  late TimeEntryRepositoryImpl repository;

  setUp(() {
    mockTimeEntriesDao = MockTimeEntriesDao();
    mockSupabaseService = MockSupabaseService();
    mockConnectivity = MockConnectivity();
    repository = TimeEntryRepositoryImpl(mockTimeEntriesDao, mockSupabaseService, mockConnectivity);
  });

  group('TimeEntryRepositoryImpl', () {
    final testTimeEntry = TimeEntryEntity(
      id: 1,
      taskId: 1,
      startTime: DateTime(2023, 1, 1, 9, 0),
      endTime: DateTime(2023, 1, 1, 17, 0),
      duration: const Duration(hours: 8),
      createdAt: DateTime(2023, 1, 1),
      updatedAt: DateTime(2023, 1, 1),
      isDeleted: false,
    );

    test('should create time entry successfully', () async {
      when(mockTimeEntriesDao.upsertTimeEntry(any)).thenAnswer((_) async => 1);
      when(mockConnectivity.checkConnectivity()).thenAnswer((_) async => ConnectivityResult.none);

      final result = await repository.createTimeEntry(testTimeEntry);

      expect(result.isSuccess, true);
      verify(mockTimeEntriesDao.upsertTimeEntry(any)).called(1);
    });

    test('should get time entry by id successfully', () async {
      when(mockTimeEntriesDao.watchTimeEntriesForTask(any))
          .thenAnswer((_) => Stream.value([testTimeEntry.toCompanion().toTimeEntry()]));

      final result = await repository.getTimeEntryById(1);

      expect(result.isSuccess, true);
      expect(result.resultValue?.id, 1);
      expect(result.resultValue?.taskId, 1);
    });

    test('should return failed result when time entry not found', () async {
      when(mockTimeEntriesDao.watchTimeEntriesForTask(any)).thenAnswer((_) => Stream.value([]));

      final result = await repository.getTimeEntryById(999);

      expect(result.isFailed, true);
      expect(result.errorMessage, 'Time entry not found');
    });

    test('should update time entry successfully', () async {
      when(mockTimeEntriesDao.upsertTimeEntry(any)).thenAnswer((_) async => 1);
      when(mockConnectivity.checkConnectivity()).thenAnswer((_) async => ConnectivityResult.none);

      final result = await repository.updateTimeEntry(testTimeEntry);

      expect(result.isSuccess, true);
      verify(mockTimeEntriesDao.upsertTimeEntry(any)).called(1);
    });

    test('should soft delete time entry successfully', () async {
      // Mock getTimeEntryById to return the time entry
      when(mockTimeEntriesDao.watchTimeEntriesForTask(any))
          .thenAnswer((_) => Stream.value([testTimeEntry.toCompanion().toTimeEntry()]));
      when(mockTimeEntriesDao.upsertTimeEntry(any)).thenAnswer((_) async => 1);
      when(mockConnectivity.checkConnectivity()).thenAnswer((_) async => ConnectivityResult.none);

      final result = await repository.softDeleteTimeEntry(1);

      expect(result.isSuccess, true);
      verify(mockTimeEntriesDao.upsertTimeEntry(any)).called(1);
    });

    test('should watch time entries for task and filter out deleted ones', () async {
      final deletedTimeEntry = testTimeEntry.copyWith(isDeleted: true);
      when(mockTimeEntriesDao.watchTimeEntriesForTask(1)).thenAnswer((_) =>
          Stream.value([
            testTimeEntry.toCompanion().toTimeEntry(),
            deletedTimeEntry.toCompanion().toTimeEntry(),
          ]));

      final timeEntries = await repository.watchTimeEntriesForTask(1).first;

      expect(timeEntries.length, 1);
      expect(timeEntries.first.taskId, 1);
    });

    test('should get unsynced time entries', () async {
      when(mockTimeEntriesDao.getUnsyncedTimeEntries())
          .thenAnswer((_) async => [testTimeEntry.toCompanion().toTimeEntry()]);

      final result = await repository.getUnsyncedTimeEntries();

      expect(result.isSuccess, true);
      expect(result.resultValue?.length, 1);
      expect(result.resultValue?.first.taskId, 1);
    });

    test('should mark time entry as synced', () async {
      when(mockTimeEntriesDao.upsertTimeEntry(any)).thenAnswer((_) async => 1);

      final result = await repository.markTimeEntryAsSynced(1);

      expect(result.isSuccess, true);
      verify(mockTimeEntriesDao.upsertTimeEntry(any)).called(1);
    });

    test('should handle database errors gracefully', () async {
      when(mockTimeEntriesDao.upsertTimeEntry(any)).thenThrow(Exception('DB Error'));

      final result = await repository.createTimeEntry(testTimeEntry);

      expect(result.isFailed, true);
      expect(result.errorMessage?.contains('Failed to create time entry'), true);
    });
  });
}