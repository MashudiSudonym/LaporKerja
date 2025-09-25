import 'package:flutter_test/flutter_test.dart';
import 'package:lapor_kerja/core/utils/result.dart';
import 'package:lapor_kerja/domain/entities/client_entity.dart';
import 'package:lapor_kerja/domain/repositories/client_repository.dart';
import 'package:lapor_kerja/domain/usecases/client/update_client/update_client_params.dart';
import 'package:lapor_kerja/domain/usecases/client/update_client/update_client_usecase.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'update_client_usecase_test.mocks.dart';

@GenerateMocks([ClientRepository], customMocks: [MockSpec<ClientRepository>(as: #MockClientRepositoryForUpdate)])

void main() {
  provideDummy<Result<ClientEntity>>(Result.failed('dummy'));
  late UpdateClientUseCase useCase;
  late MockClientRepositoryForUpdate mockRepository;

  setUp(() {
    mockRepository = MockClientRepositoryForUpdate();
    useCase = UpdateClientUseCase(mockRepository);
  });

  setUpAll(() {
    provideDummy<Result<void>>(const Result.failed('dummy'));
  });

  group('UpdateClientUseCase', () {
    test('should call repository.updateClient with correct params', () async {
      // Arrange
      final existingClient = ClientEntity(
        id: 1,
        name: 'Old Client',
        contactInfo: 'old@example.com',
        createdAt: DateTime(2023, 1, 1),
        updatedAt: DateTime(2023, 1, 1),
        isDeleted: false,
      );
      final params = UpdateClientParams(1, 'Updated Client', 'updated@example.com');
      when(mockRepository.getClientById(1)).thenAnswer((_) async => Result.success(existingClient));
      when(mockRepository.updateClient(any)).thenAnswer((_) async => const Result.success(null));

      // Act
      final result = await useCase.call(params);

      // Assert
      verify(mockRepository.getClientById(1)).called(1);
      verify(mockRepository.updateClient(any)).called(1);
      expect(result.isSuccess, true);
    });
  });
}