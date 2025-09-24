import 'package:flutter_test/flutter_test.dart';
import 'package:lapor_kerja/core/utils/result.dart';
import 'package:lapor_kerja/domain/entities/time_entry_entity.dart';
import 'package:lapor_kerja/domain/repositories/time_entry_repository.dart';
import 'package:lapor_kerja/domain/usecases/time_entry/add_time_entry/add_time_entry_params.dart';
import 'package:lapor_kerja/domain/usecases/time_entry/add_time_entry/add_time_entry_usecase.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'add_time_entry_usecase_test.mocks.dart';

@GenerateMocks([TimeEntryRepository], customMocks: [MockSpec<TimeEntryRepository>(as: #MockTimeEntryRepositoryForAdd)])
void main() {
  late AddTimeEntryUseCase useCase;
  late MockTimeEntryRepositoryForAdd mockRepository;

  setUp(() {
    mockRepository = MockTimeEntryRepositoryForAdd();
    useCase = AddTimeEntryUseCase(mockRepository);
  });

  setUpAll(() {
    provideDummy<Result<void>>(const Result.failed('dummy'));
  });

  group('AddTimeEntryUseCase', () {
    test('should call repository.createTimeEntry with correct params', () async {
      // Arrange
      final timeEntry = TimeEntryEntity(
        id: 1,
        taskId: 1,
        startTime: DateTime.now(),
        endTime: DateTime.now().add(Duration(hours: 1)),
        duration: Duration(hours: 1),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isDeleted: false,
      );
      final params = AddTimeEntryParams(timeEntry);
      when(mockRepository.createTimeEntry(timeEntry)).thenAnswer((_) async => const Result.success(null));

      // Act
      final result = await useCase.call(params);

      // Assert
      verify(mockRepository.createTimeEntry(timeEntry)).called(1);
      expect(result.isSuccess, true);
    });
  });
}

