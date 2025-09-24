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
      final client = ClientEntity(
        id: 1,
        name: 'Updated Client',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isDeleted: false,
      );
      final params = UpdateClientParams(client);
      when(mockRepository.updateClient(client)).thenAnswer((_) async => const Result.success(null));

      // Act
      final result = await useCase.call(params);

      // Assert
      verify(mockRepository.updateClient(client)).called(1);
      expect(result.isSuccess, true);
    });
  });
}