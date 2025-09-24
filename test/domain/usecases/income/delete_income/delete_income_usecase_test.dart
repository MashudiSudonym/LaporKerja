import 'package:flutter_test/flutter_test.dart';
import 'package:lapor_kerja/core/utils/result.dart';
import 'package:lapor_kerja/domain/repositories/income_repository.dart';
import 'package:lapor_kerja/domain/usecases/income/delete_income/delete_income_params.dart';
import 'package:lapor_kerja/domain/usecases/income/delete_income/delete_income_usecase.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'delete_income_usecase_test.mocks.dart';

@GenerateMocks([IncomeRepository], customMocks: [MockSpec<IncomeRepository>(as: #MockIncomeRepositoryForDelete)])
void main() {
  late DeleteIncomeUseCase useCase;
  late MockIncomeRepositoryForDelete mockRepository;

  setUp(() {
    mockRepository = MockIncomeRepositoryForDelete();
    useCase = DeleteIncomeUseCase(mockRepository);
  });

  setUpAll(() {
    provideDummy<Result<void>>(const Result.failed('dummy'));
  });

  group('DeleteIncomeUseCase', () {
    test('should call repository.softDeleteIncome with correct id', () async {
      // Arrange
      const id = 1;
      final params = DeleteIncomeParams(id);
      when(mockRepository.softDeleteIncome(id)).thenAnswer((_) async => const Result.success(null));

      // Act
      final result = await useCase.call(params);

      // Assert
      verify(mockRepository.softDeleteIncome(id)).called(1);
      expect(result.isSuccess, true);
    });
  });
}