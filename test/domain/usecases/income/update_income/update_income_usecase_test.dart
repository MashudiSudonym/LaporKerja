import 'package:flutter_test/flutter_test.dart';
import 'package:lapor_kerja/core/utils/result.dart';
import 'package:lapor_kerja/domain/entities/income_entity.dart';
import 'package:lapor_kerja/domain/repositories/income_repository.dart';
import 'package:lapor_kerja/domain/usecases/income/update_income/update_income_params.dart';
import 'package:lapor_kerja/domain/usecases/income/update_income/update_income_usecase.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'update_income_usecase_test.mocks.dart';

@GenerateMocks([IncomeRepository], customMocks: [MockSpec<IncomeRepository>(as: #MockIncomeRepositoryForUpdate)])
void main() {
  late UpdateIncomeUseCase useCase;
  late MockIncomeRepositoryForUpdate mockRepository;

  setUp(() {
    mockRepository = MockIncomeRepositoryForUpdate();
    useCase = UpdateIncomeUseCase(mockRepository);
  });

  setUpAll(() {
    provideDummy<Result<void>>(const Result.failed('dummy'));
  });

  group('UpdateIncomeUseCase', () {
    test('should call repository.updateIncome with correct params', () async {
      // Arrange
      final income = IncomeEntity(
        id: 1,
        projectId: 1,
        amount: 200.0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isDeleted: false,
      );
      final params = UpdateIncomeParams(income);
      when(mockRepository.updateIncome(income)).thenAnswer((_) async => const Result.success(null));

      // Act
      final result = await useCase.call(params);

      // Assert
      verify(mockRepository.updateIncome(income)).called(1);
      expect(result.isSuccess, true);
    });
  });
}