import 'package:flutter_test/flutter_test.dart';
import 'package:lapor_kerja/core/utils/result.dart';
import 'package:lapor_kerja/domain/repositories/time_entry_repository.dart';
import 'package:lapor_kerja/domain/usecases/time_entry/delete_time_entry/delete_time_entry_params.dart';
import 'package:lapor_kerja/domain/usecases/time_entry/delete_time_entry/delete_time_entry_usecase.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'delete_time_entry_usecase_test.mocks.dart';

@GenerateMocks([TimeEntryRepository], customMocks: [MockSpec<TimeEntryRepository>(as: #MockTimeEntryRepositoryForDelete)])
void main() {
  late DeleteTimeEntryUseCase useCase;
  late MockTimeEntryRepositoryForDelete mockRepository;

  setUp(() {
    mockRepository = MockTimeEntryRepositoryForDelete();
    useCase = DeleteTimeEntryUseCase(mockRepository);
  });

  setUpAll(() {
    provideDummy<Result<void>>(const Result.failed('dummy'));
  });

  group('DeleteTimeEntryUseCase', () {
    test('should call repository.softDeleteTimeEntry with correct id', () async {
      // Arrange
      const id = 1;
      final params = DeleteTimeEntryParams(id);
      when(mockRepository.softDeleteTimeEntry(id)).thenAnswer((_) async => const Result.success(null));

      // Act
      final result = await useCase.call(params);

      // Assert
      verify(mockRepository.softDeleteTimeEntry(id)).called(1);
      expect(result.isSuccess, true);
    });
  });
}