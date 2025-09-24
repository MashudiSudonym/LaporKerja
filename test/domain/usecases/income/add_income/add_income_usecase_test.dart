import 'package:flutter_test/flutter_test.dart';
import 'package:lapor_kerja/core/utils/result.dart';
import 'package:lapor_kerja/domain/entities/income_entity.dart';
import 'package:lapor_kerja/domain/repositories/income_repository.dart';
import 'package:lapor_kerja/domain/usecases/income/add_income/add_income_params.dart';
import 'package:lapor_kerja/domain/usecases/income/add_income/add_income_usecase.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'add_income_usecase_test.mocks.dart';

@GenerateMocks([IncomeRepository], customMocks: [MockSpec<IncomeRepository>(as: #MockIncomeRepositoryForAdd)])
void main() {
  late AddIncomeUseCase useCase;
  late MockIncomeRepositoryForAdd mockRepository;

  setUp(() {
    mockRepository = MockIncomeRepositoryForAdd();
    useCase = AddIncomeUseCase(mockRepository);
  });

  setUpAll(() {
    provideDummy<Result<void>>(const Result.failed('dummy'));
  });

  group('AddIncomeUseCase', () {
    test('should call repository.createIncome with correct params', () async {
      // Arrange
      final income = IncomeEntity(
        id: 1,
        projectId: 1,
        amount: 100.0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isDeleted: false,
      );
      final params = AddIncomeParams(income);
      when(mockRepository.createIncome(income)).thenAnswer((_) async => const Result.success(null));

      // Act
      final result = await useCase.call(params);

      // Assert
      verify(mockRepository.createIncome(income)).called(1);
      expect(result.isSuccess, true);
    });
  });
}

