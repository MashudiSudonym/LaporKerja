import 'package:flutter_test/flutter_test.dart';
import 'package:lapor_kerja/domain/entities/time_entry_entity.dart';
import 'package:lapor_kerja/domain/repositories/time_entry_repository.dart';
import 'package:lapor_kerja/domain/usecases/time_entry/get_time_entries_usecase.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_time_entries_usecase_test.mocks.dart';

@GenerateMocks([TimeEntryRepository], customMocks: [MockSpec<TimeEntryRepository>(as: #MockTimeEntryRepositoryForGet)])
void main() {
  late GetTimeEntriesUseCase useCase;
  late MockTimeEntryRepositoryForGet mockRepository;

  setUp(() {
    mockRepository = MockTimeEntryRepositoryForGet();
    useCase = GetTimeEntriesUseCase(mockRepository);
  });

  group('GetTimeEntriesUseCase', () {
    test('should return stream from repository.watchAllTimeEntries', () {
      // Arrange
      final timeEntries = [
        TimeEntryEntity(
          id: 1,
          taskId: 1,
          startTime: DateTime.now(),
          endTime: DateTime.now().add(Duration(hours: 1)),
          duration: Duration(hours: 1),
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          isDeleted: false,
        ),
      ];
      when(mockRepository.watchAllTimeEntries()).thenAnswer((_) => Stream.value(timeEntries));

      // Act
      final result = useCase.call();

      // Assert
      expect(result, isA<Stream<List<TimeEntryEntity>>>());
      verify(mockRepository.watchAllTimeEntries()).called(1);
    });
  });
}