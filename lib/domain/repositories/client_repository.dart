import '../../core/utils/result.dart';
import '../../domain/entities/client_entity.dart';

abstract interface class ClientRepository {
  Stream<List<ClientEntity>> watchAllClients();
  Future<Result<ClientEntity>> getClientById(int id);
  Future<Result<void>> createClient(ClientEntity client);
  Future<Result<void>> updateClient(ClientEntity client);
  Future<Result<void>> softDeleteClient(int id);
  Future<Result<List<ClientEntity>>> getUnsyncedClients();
  Future<Result<void>> markClientAsSynced(int id);
}
