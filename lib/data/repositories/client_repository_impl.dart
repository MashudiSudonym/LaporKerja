import 'package:drift/drift.dart';
import 'package:lapor_kerja/core/utils/result.dart';
import 'package:lapor_kerja/data/datasources/local/app_database.dart';
import 'package:lapor_kerja/data/datasources/local/dao/clients_dao.dart';
import 'package:lapor_kerja/data/mappers/client_mapper.dart';
import 'package:lapor_kerja/domain/entities/client_entity.dart';
import 'package:lapor_kerja/domain/repositories/client_repository.dart';

class ClientRepositoryImpl implements ClientRepository {
  final ClientsDao _clientsDao;

  ClientRepositoryImpl(this._clientsDao);

  @override
  Stream<List<ClientEntity>> watchAllClients() {
    return _clientsDao.watchAllClients().map(
          (clients) => clients
              .where((client) => !client.isDeleted)
              .map((client) => client.toEntity())
              .toList(),
        );
  }

  @override
  Future<Result<ClientEntity>> getClientById(int id) async {
    try {
      final clients = await _clientsDao.watchAllClients().first;
      final client = clients
          .where((c) => c.id == id && !c.isDeleted)
          .firstOrNull;

      if (client == null) {
        return const Result.failed('Client not found');
      }

      return Result.success(client.toEntity());
    } catch (e) {
      return Result.failed('Failed to get client: $e');
    }
  }

  @override
  Future<Result<void>> createClient(ClientEntity client) async {
    try {
      await _clientsDao.upsertClient(client.toCompanion());
      return const Result.success(null);
    } catch (e) {
      return Result.failed('Failed to create client: $e');
    }
  }

  @override
  Future<Result<void>> updateClient(ClientEntity client) async {
    try {
      await _clientsDao.upsertClient(client.toCompanion());
      return const Result.success(null);
    } catch (e) {
      return Result.failed('Failed to update client: $e');
    }
  }

  @override
  Future<Result<void>> softDeleteClient(int id) async {
    try {
      await _clientsDao.softDeleteClient(id);
      return const Result.success(null);
    } catch (e) {
      return Result.failed('Failed to delete client: $e');
    }
  }

  @override
  Future<Result<List<ClientEntity>>> getUnsyncedClients() async {
    try {
      final clients = await _clientsDao.getUnsyncedClients();
      final entities = clients.map((c) => c.toEntity()).toList();
      return Result.success(entities);
    } catch (e) {
      return Result.failed('Failed to get unsynced clients: $e');
    }
  }

  @override
  Future<Result<void>> markClientAsSynced(int id) async {
    try {
      await _clientsDao.upsertClient(
        ClientsCompanion(
          id: Value(id),
          isSynced: const Value(true),
          lastModified: Value(DateTime.now()),
        ),
      );
      return const Result.success(null);
    } catch (e) {
      return Result.failed('Failed to mark client as synced: $e');
    }
  }
}