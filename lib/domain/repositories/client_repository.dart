import '../../domain/entities/client_entity.dart';

abstract interface class ClientRepository {
  Stream<List<ClientEntity>> watchAllClients();
  Future<ClientEntity?> getClientById(int id);
  Future<void> createClient(ClientEntity client);
  Future<void> updateClient(ClientEntity client);
  Future<void> softDeleteClient(int id);
  Future<List<ClientEntity>> getUnsyncedClients();
  Future<void> markClientAsSynced(int id);
}
