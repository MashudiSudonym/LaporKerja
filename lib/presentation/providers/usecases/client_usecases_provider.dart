import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../domain/usecases/client/add_client/add_client_usecase.dart';
import '../../../domain/usecases/client/delete_client/delete_client_usecase.dart';
import '../../../domain/usecases/client/get_clients_usecase.dart';
import '../../../domain/usecases/client/update_client/update_client_usecase.dart';
import '../repositories/client_repository_provider.dart';

part 'client_usecases_provider.g.dart';

@riverpod
AddClientUseCase addClientUseCase(Ref ref) {
  final repo = ref.watch(clientRepositoryProvider);
  return AddClientUseCase(repo);
}

@riverpod
UpdateClientUseCase updateClientUseCase(Ref ref) {
  final repo = ref.watch(clientRepositoryProvider);
  return UpdateClientUseCase(repo);
}

@riverpod
DeleteClientUseCase deleteClientUseCase(Ref ref) {
  final repo = ref.watch(clientRepositoryProvider);
  return DeleteClientUseCase(repo);
}

@riverpod
GetClientsUseCase getClientsUseCase(Ref ref) {
  final repo = ref.watch(clientRepositoryProvider);
  return GetClientsUseCase(repo);
}