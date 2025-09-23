import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:lapor_kerja/domain/entities/time_entry_entity.dart';
import 'package:lapor_kerja/domain/repositories/time_entry_repository.dart';

@GenerateMocks([TimeEntryRepository])
import 'time_entry_repository_test.mocks.dart';

void main() {
  late MockTimeEntryRepository mockTimeEntryRepository;

  setUp(() {
    mockTimeEntryRepository = MockTimeEntryRepository();
  });

  group('TimeEntryRepository', () {
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

    test('should watch time entries for task', () {
      when(mockTimeEntryRepository.watchTimeEntriesForTask(1)).thenAnswer((_) => Stream.value([testTimeEntry]));
      expect(mockTimeEntryRepository.watchTimeEntriesForTask(1), isA<Stream<List<TimeEntryEntity>>>());
    });

    test('should get time entry by id', () async {
      when(mockTimeEntryRepository.getTimeEntryById(1)).thenAnswer((_) async => testTimeEntry);
      final result = await mockTimeEntryRepository.getTimeEntryById(1);
      expect(result, testTimeEntry);
    });

    test('should create time entry', () async {
      when(mockTimeEntryRepository.createTimeEntry(testTimeEntry)).thenAnswer((_) async => {});
      await mockTimeEntryRepository.createTimeEntry(testTimeEntry);
      verify(mockTimeEntryRepository.createTimeEntry(testTimeEntry)).called(1);
    });

    test('should update time entry', () async {
      when(mockTimeEntryRepository.updateTimeEntry(testTimeEntry)).thenAnswer((_) async => {});
      await mockTimeEntryRepository.updateTimeEntry(testTimeEntry);
      verify(mockTimeEntryRepository.updateTimeEntry(testTimeEntry)).called(1);
    });

    test('should soft delete time entry', () async {
      when(mockTimeEntryRepository.softDeleteTimeEntry(1)).thenAnswer((_) async => {});
      await mockTimeEntryRepository.softDeleteTimeEntry(1);
      verify(mockTimeEntryRepository.softDeleteTimeEntry(1)).called(1);
    });

    test('should get unsynced time entries', () async {
      when(mockTimeEntryRepository.getUnsyncedTimeEntries()).thenAnswer((_) async => [testTimeEntry]);
      final result = await mockTimeEntryRepository.getUnsyncedTimeEntries();
      expect(result, [testTimeEntry]);
    });

    test('should mark time entry as synced', () async {
      when(mockTimeEntryRepository.markTimeEntryAsSynced(1)).thenAnswer((_) async => {});
      await mockTimeEntryRepository.markTimeEntryAsSynced(1);
      verify(mockTimeEntryRepository.markTimeEntryAsSynced(1)).called(1);
    });
  });
}