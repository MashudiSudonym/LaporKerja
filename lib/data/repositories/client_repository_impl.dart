import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:drift/drift.dart';
import 'package:lapor_kerja/core/utils/result.dart';
import 'package:lapor_kerja/data/datasources/local/app_database.dart';
import 'package:lapor_kerja/data/datasources/local/dao/clients_dao.dart';
import 'package:lapor_kerja/data/mappers/client_mapper.dart';
import 'package:lapor_kerja/data/services/supabase_service.dart';
import 'package:lapor_kerja/domain/entities/client_entity.dart';
import 'package:lapor_kerja/domain/repositories/client_repository.dart';

import '../../core/constants/constants.dart';

class ClientRepositoryImpl implements ClientRepository {
  final ClientsDao _clientsDao;
  final SupabaseService _supabaseService;
  final Connectivity _connectivity;

  ClientRepositoryImpl(this._clientsDao, this._supabaseService, this._connectivity);

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
      // Save locally first
      final companion = client.toCompanion();
      final companionWithUnsynced = companion.copyWith(isSynced: const Value(false));
      await _clientsDao.upsertClient(companionWithUnsynced);

      // Try to sync to Supabase if online
      final connectivityResult = await _connectivity.checkConnectivity();
      if (connectivityResult != ConnectivityResult.none) {
        try {
          await _supabaseService.upsert('clients', client.toJson());
          await markClientAsSynced(client.id);
        } catch (e) {
          Constants.logger.e('Failed to sync client on create: $e');
          // isSynced remains false
        }
      }

      return const Result.success(null);
    } catch (e) {
      return Result.failed('Failed to create client: $e');
    }
  }

  @override
  Future<Result<void>> updateClient(ClientEntity client) async {
    try {
      // Save locally first
      final companion = client.toCompanion();
      final companionWithUnsynced = companion.copyWith(isSynced: const Value(false));
      await _clientsDao.upsertClient(companionWithUnsynced);

      // Try to sync to Supabase if online
      final connectivityResult = await _connectivity.checkConnectivity();
      if (connectivityResult != ConnectivityResult.none) {
        try {
          await _supabaseService.upsert('clients', client.toJson());
          await markClientAsSynced(client.id);
        } catch (e) {
          Constants.logger.e('Failed to sync client on update: $e');
          // isSynced remains false
        }
      }

      return const Result.success(null);
    } catch (e) {
      return Result.failed('Failed to update client: $e');
    }
  }

  @override
  Future<Result<void>> softDeleteClient(int id) async {
    try {
      // Get client before deleting
      final clientResult = await getClientById(id);
      if (clientResult.isFailed) return clientResult;

      final client = clientResult.resultValue!;
      final updatedClient = client.copyWith(isDeleted: true);

      // Save locally first
      final companion = updatedClient.toCompanion();
      final companionWithUnsynced = companion.copyWith(isSynced: const Value(false));
      await _clientsDao.upsertClient(companionWithUnsynced);

      // Try to sync to Supabase if online
      final connectivityResult = await _connectivity.checkConnectivity();
      if (connectivityResult != ConnectivityResult.none) {
        try {
          await _supabaseService.upsert('clients', updatedClient.toJson());
          await markClientAsSynced(id);
        } catch (e) {
          Constants.logger.e('Failed to sync client on delete: $e');
          // isSynced remains false
        }
      }

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

  /// Sync all unsynced clients to Supabase
  Future<void> syncAllClients() async {
    final unsyncedResult = await getUnsyncedClients();
    if (unsyncedResult.isFailed) return;

    final unsyncedClients = unsyncedResult.resultValue!;
    await _supabaseService.syncClients(unsyncedClients);

    // Mark all as synced
    for (final client in unsyncedClients) {
      await markClientAsSynced(client.id);
    }
  }
}