import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:lapor_kerja/domain/entities/income_entity.dart';
import 'package:lapor_kerja/domain/repositories/income_repository.dart';

@GenerateMocks([IncomeRepository])
import 'income_repository_test.mocks.dart';

void main() {
  late MockIncomeRepository mockIncomeRepository;

  setUp(() {
    mockIncomeRepository = MockIncomeRepository();
  });

  group('IncomeRepository', () {
    final testIncome = IncomeEntity(
      id: 1,
      projectId: 1,
      amount: 1000.0,
      paymentStatus: 'paid',
      paymentDate: DateTime(2023, 1, 15),
      createdAt: DateTime(2023, 1, 1),
      updatedAt: DateTime(2023, 1, 1),
      isDeleted: false,
    );

    test('should watch all incomes', () {
      when(mockIncomeRepository.watchAllIncomes()).thenAnswer((_) => Stream.value([testIncome]));
      expect(mockIncomeRepository.watchAllIncomes(), isA<Stream<List<IncomeEntity>>>());
    });

    test('should watch incomes for project', () {
      when(mockIncomeRepository.watchIncomesForProject(1)).thenAnswer((_) => Stream.value([testIncome]));
      expect(mockIncomeRepository.watchIncomesForProject(1), isA<Stream<List<IncomeEntity>>>());
    });

    test('should get income by id', () async {
      when(mockIncomeRepository.getIncomeById(1)).thenAnswer((_) async => testIncome);
      final result = await mockIncomeRepository.getIncomeById(1);
      expect(result, testIncome);
    });

    test('should create income', () async {
      when(mockIncomeRepository.createIncome(testIncome)).thenAnswer((_) async => {});
      await mockIncomeRepository.createIncome(testIncome);
      verify(mockIncomeRepository.createIncome(testIncome)).called(1);
    });

    test('should update income', () async {
      when(mockIncomeRepository.updateIncome(testIncome)).thenAnswer((_) async => {});
      await mockIncomeRepository.updateIncome(testIncome);
      verify(mockIncomeRepository.updateIncome(testIncome)).called(1);
    });

    test('should soft delete income', () async {
      when(mockIncomeRepository.softDeleteIncome(1)).thenAnswer((_) async => {});
      await mockIncomeRepository.softDeleteIncome(1);
      verify(mockIncomeRepository.softDeleteIncome(1)).called(1);
    });

    test('should get unsynced incomes', () async {
      when(mockIncomeRepository.getUnsyncedIncomes()).thenAnswer((_) async => [testIncome]);
      final result = await mockIncomeRepository.getUnsyncedIncomes();
      expect(result, [testIncome]);
    });

    test('should mark income as synced', () async {
      when(mockIncomeRepository.markIncomeAsSynced(1)).thenAnswer((_) async => {});
      await mockIncomeRepository.markIncomeAsSynced(1);
      verify(mockIncomeRepository.markIncomeAsSynced(1)).called(1);
    });
  });
}