import 'package:flutter_test/flutter_test.dart';
import 'package:lapor_kerja/core/utils/result.dart';
import 'package:lapor_kerja/domain/entities/client_entity.dart';
import 'package:lapor_kerja/domain/repositories/client_repository.dart';
import 'package:lapor_kerja/domain/usecases/client/add_client/add_client_params.dart';
import 'package:lapor_kerja/domain/usecases/client/add_client/add_client_usecase.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'add_client_usecase_test.mocks.dart';

@GenerateMocks([ClientRepository], customMocks: [MockSpec<ClientRepository>(as: #MockClientRepositoryForAdd)])
void main() {
  late AddClientUseCase useCase;
  late MockClientRepositoryForAdd mockRepository;

  setUp(() {
    mockRepository = MockClientRepositoryForAdd();
    useCase = AddClientUseCase(mockRepository);
  });

  setUpAll(() {
    provideDummy<Result<void>>(const Result.failed('dummy'));
  });

  group('AddClientUseCase', () {
    test('should call repository.createClient with correct params', () async {
      // Arrange
      final client = ClientEntity(
        id: 1,
        name: 'Test Client',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isDeleted: false,
      );
      final params = AddClientParams(client);
      when(mockRepository.createClient(client)).thenAnswer((_) async => const Result.success(null));

      // Act
      final result = await useCase.call(params);

      // Assert
      verify(mockRepository.createClient(client)).called(1);
      expect(result.isSuccess, true);
    });
  });
}

