import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:lapor_kerja/domain/entities/client_entity.dart';
import 'package:lapor_kerja/domain/repositories/client_repository.dart';

@GenerateMocks([ClientRepository])
import 'client_repository_test.mocks.dart';

void main() {
  late MockClientRepository mockClientRepository;

  setUp(() {
    mockClientRepository = MockClientRepository();
  });

  group('ClientRepository', () {
    final testClient = ClientEntity(
      id: 1,
      name: 'Test Client',
      contactInfo: 'test@example.com',
      createdAt: DateTime(2023, 1, 1),
      updatedAt: DateTime(2023, 1, 1),
      isDeleted: false,
    );

    test('should watch all clients', () {
      when(mockClientRepository.watchAllClients()).thenAnswer((_) => Stream.value([testClient]));
      expect(mockClientRepository.watchAllClients(), isA<Stream<List<ClientEntity>>>());
    });

    test('should get client by id', () async {
      when(mockClientRepository.getClientById(1)).thenAnswer((_) async => testClient);
      final result = await mockClientRepository.getClientById(1);
      expect(result, testClient);
    });

    test('should create client', () async {
      when(mockClientRepository.createClient(testClient)).thenAnswer((_) async => {});
      await mockClientRepository.createClient(testClient);
      verify(mockClientRepository.createClient(testClient)).called(1);
    });

    test('should update client', () async {
      when(mockClientRepository.updateClient(testClient)).thenAnswer((_) async => {});
      await mockClientRepository.updateClient(testClient);
      verify(mockClientRepository.updateClient(testClient)).called(1);
    });

    test('should soft delete client', () async {
      when(mockClientRepository.softDeleteClient(1)).thenAnswer((_) async => {});
      await mockClientRepository.softDeleteClient(1);
      verify(mockClientRepository.softDeleteClient(1)).called(1);
    });

    test('should get unsynced clients', () async {
      when(mockClientRepository.getUnsyncedClients()).thenAnswer((_) async => [testClient]);
      final result = await mockClientRepository.getUnsyncedClients();
      expect(result, [testClient]);
    });

    test('should mark client as synced', () async {
      when(mockClientRepository.markClientAsSynced(1)).thenAnswer((_) async => {});
      await mockClientRepository.markClientAsSynced(1);
      verify(mockClientRepository.markClientAsSynced(1)).called(1);
    });
  });
}