import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../domain/entities/client_entity.dart';
import '../../../domain/usecases/client/add_client/add_client_params.dart';
import '../../../domain/usecases/client/delete_client/delete_client_params.dart';
import '../../../domain/usecases/client/update_client/update_client_params.dart';
import '../usecases/client_usecases_provider.dart';

part 'clients_provider.g.dart';

@riverpod
class ClientsNotifier extends _$ClientsNotifier {
  @override
  Stream<List<ClientEntity>> build() {
    final getClients = ref.watch(getClientsUseCaseProvider);
    return getClients();
  }

  Future<void> addClient(AddClientParams params) async {
    final addClient = ref.read(addClientUseCaseProvider);
    final result = await addClient(params);
    if (result.isFailed) {
      throw Exception(result.errorMessage);
    }
    ref.invalidateSelf();
  }

  Future<void> updateClient(UpdateClientParams params) async {
    final updateClient = ref.read(updateClientUseCaseProvider);
    final result = await updateClient(params);
    if (result.isFailed) {
      throw Exception(result.errorMessage);
    }
    ref.invalidateSelf();
  }

  Future<void> deleteClient(DeleteClientParams params) async {
    final deleteClient = ref.read(deleteClientUseCaseProvider);
    final result = await deleteClient(params);
    if (result.isFailed) {
      throw Exception(result.errorMessage);
    }
    ref.invalidateSelf();
  }
}