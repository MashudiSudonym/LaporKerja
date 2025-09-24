import 'package:flutter_test/flutter_test.dart';
import 'package:lapor_kerja/domain/entities/income_entity.dart';
import 'package:lapor_kerja/domain/repositories/income_repository.dart';
import 'package:lapor_kerja/domain/usecases/income/get_incomes_usecase.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_incomes_usecase_test.mocks.dart';

@GenerateMocks([IncomeRepository], customMocks: [MockSpec<IncomeRepository>(as: #MockIncomeRepositoryForGet)])
void main() {
  late GetIncomesUseCase useCase;
  late MockIncomeRepositoryForGet mockRepository;

  setUp(() {
    mockRepository = MockIncomeRepositoryForGet();
    useCase = GetIncomesUseCase(mockRepository);
  });

  group('GetIncomesUseCase', () {
    test('should return stream from repository.watchAllIncomes', () {
      // Arrange
      final incomes = [
        IncomeEntity(
          id: 1,
          projectId: 1,
          amount: 100.0,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          isDeleted: false,
        ),
      ];
      when(mockRepository.watchAllIncomes()).thenAnswer((_) => Stream.value(incomes));

      // Act
      final result = useCase.call();

      // Assert
      expect(result, isA<Stream<List<IncomeEntity>>>());
      verify(mockRepository.watchAllIncomes()).called(1);
    });
  });
}