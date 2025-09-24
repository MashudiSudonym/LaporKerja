import 'package:flutter_test/flutter_test.dart';
import 'package:lapor_kerja/domain/entities/client_entity.dart';
import 'package:lapor_kerja/domain/repositories/client_repository.dart';
import 'package:lapor_kerja/domain/usecases/client/get_clients_usecase.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_clients_usecase_test.mocks.dart';

@GenerateMocks([ClientRepository], customMocks: [MockSpec<ClientRepository>(as: #MockClientRepositoryForGet)])
void main() {
  late GetClientsUseCase useCase;
  late MockClientRepositoryForGet mockRepository;

  setUp(() {
    mockRepository = MockClientRepositoryForGet();
    useCase = GetClientsUseCase(mockRepository);
  });

  group('GetClientsUseCase', () {
    test('should return stream from repository.watchAllClients', () {
      // Arrange
      final clients = [
        ClientEntity(
          id: 1,
          name: 'Client 1',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          isDeleted: false,
        ),
      ];
      when(mockRepository.watchAllClients()).thenAnswer((_) => Stream.value(clients));

      // Act
      final result = useCase.call();

      // Assert
      expect(result, isA<Stream<List<ClientEntity>>>());
      verify(mockRepository.watchAllClients()).called(1);
    });
  });
}