import 'package:drift/drift.dart';
import '../app_database.dart';
import '../../../models/local/clients.dart';

part 'clients_dao.g.dart';

@DriftAccessor(tables: [Clients])
class ClientsDao extends DatabaseAccessor<AppDatabase> with _$ClientsDaoMixin {
  ClientsDao(super.db);

  Stream<List<Client>> watchAllClients() => select(clients).watch();

  Future<List<Client>> getUnsyncedClients() {
    return (select(clients)..where((c) => c.isSynced.equals(false))).get();
  }

  Future<int> upsertClient(ClientsCompanion entry) {
    return into(clients).insertOnConflictUpdate(entry);
  }

  Future<int> softDeleteClient(int id) {
    return (update(clients)..where((c) => c.id.equals(id))).write(
      ClientsCompanion(
        isDeleted: const Value(true),
        lastModified: Value(DateTime.now()),
      ),
    );
  }
}
