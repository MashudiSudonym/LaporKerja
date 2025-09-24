import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:lapor_kerja/data/datasources/local/app_database.dart';
import 'package:lapor_kerja/data/datasources/local/dao/clients_dao.dart';
import 'package:lapor_kerja/data/mappers/client_mapper.dart';
import 'package:lapor_kerja/data/repositories/client_repository_impl.dart';
import 'package:lapor_kerja/data/services/supabase_service.dart';
import 'package:lapor_kerja/domain/entities/client_entity.dart';

@GenerateMocks([ClientsDao, SupabaseService])
import 'client_repository_impl_test.mocks.dart';

// Helper extension for testing
extension ClientsCompanionTestHelper on ClientsCompanion {
  Client toClient() {
    return Client(
      id: id.value,
      remoteId: remoteId.present ? remoteId.value : null,
      isSynced: isSynced.present ? isSynced.value : false,
      lastModified: lastModified.present ? lastModified.value : DateTime.now(),
      isDeleted: isDeleted.present ? isDeleted.value : false,
      name: name.value,
      contactInfo: contactInfo.present ? contactInfo.value : null,
      createdAt: createdAt.value,
      updatedAt: updatedAt.value,
    );
  }
}

void main() {
  late MockClientsDao mockClientsDao;
  late MockSupabaseService mockSupabaseService;
  late ClientRepositoryImpl repository;

  setUp(() {
    mockClientsDao = MockClientsDao();
    mockSupabaseService = MockSupabaseService();
    repository = ClientRepositoryImpl(mockClientsDao, mockSupabaseService);
  });

  group('ClientRepositoryImpl', () {
    final testClient = ClientEntity(
      id: 1,
      name: 'Test Client',
      contactInfo: 'test@example.com',
      createdAt: DateTime(2023, 1, 1),
      updatedAt: DateTime(2023, 1, 1),
      isDeleted: false,
    );

    test('should create client successfully', () async {
      when(mockClientsDao.upsertClient(any)).thenAnswer((_) async => 1);

      final result = await repository.createClient(testClient);

      expect(result.isSuccess, true);
      verify(mockClientsDao.upsertClient(any)).called(1);
    });

    test('should get client by id successfully', () async {
      when(mockClientsDao.watchAllClients())
          .thenAnswer((_) => Stream.value([testClient.toCompanion().toClient()]));

      final result = await repository.getClientById(1);

      expect(result.isSuccess, true);
      expect(result.resultValue?.id, 1);
      expect(result.resultValue?.name, 'Test Client');
    });

    test('should return failed result when client not found', () async {
      when(mockClientsDao.watchAllClients())
          .thenAnswer((_) => Stream.value([]));

      final result = await repository.getClientById(999);

      expect(result.isFailed, true);
      expect(result.errorMessage, 'Client not found');
    });

    test('should update client successfully', () async {
      when(mockClientsDao.upsertClient(any)).thenAnswer((_) async => 1);

      final result = await repository.updateClient(testClient);

      expect(result.isSuccess, true);
      verify(mockClientsDao.upsertClient(any)).called(1);
    });

    test('should soft delete client successfully', () async {
      when(mockClientsDao.softDeleteClient(1)).thenAnswer((_) async => 1);

      final result = await repository.softDeleteClient(1);

      expect(result.isSuccess, true);
      verify(mockClientsDao.softDeleteClient(1)).called(1);
    });

    test('should watch all clients and filter out deleted ones', () async {
      final deletedClient = testClient.copyWith(isDeleted: true);
      when(mockClientsDao.watchAllClients()).thenAnswer((_) =>
          Stream.value([
            testClient.toCompanion().toClient(),
            deletedClient.toCompanion().toClient(),
          ]));

      final clients = await repository.watchAllClients().first;

      expect(clients.length, 1);
      expect(clients.first.name, 'Test Client');
    });

    test('should get unsynced clients', () async {
      when(mockClientsDao.getUnsyncedClients())
          .thenAnswer((_) async => [testClient.toCompanion().toClient()]);

      final result = await repository.getUnsyncedClients();

      expect(result.isSuccess, true);
      expect(result.resultValue?.length, 1);
      expect(result.resultValue?.first.name, 'Test Client');
    });

    test('should mark client as synced', () async {
      when(mockClientsDao.upsertClient(any)).thenAnswer((_) async => 1);

      final result = await repository.markClientAsSynced(1);

      expect(result.isSuccess, true);
      verify(mockClientsDao.upsertClient(any)).called(1);
    });

    test('should handle database errors gracefully', () async {
      when(mockClientsDao.upsertClient(any)).thenThrow(Exception('DB Error'));

      final result = await repository.createClient(testClient);

      expect(result.isFailed, true);
      expect(result.errorMessage?.contains('Failed to create client'), true);
    });
  });
}