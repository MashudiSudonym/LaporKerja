import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../domain/usecases/client/add_client/add_client_params.dart';
import '../../../domain/usecases/client/update_client/update_client_params.dart';
import '../usecases/client_usecases_provider.dart';

part 'client_form_notifier.g.dart';

/// AsyncNotifier for client form operations
@riverpod
class ClientFormNotifier extends _$ClientFormNotifier {
  @override
  FutureOr<void> build() {
    // No initial state needed
  }

  Future<void> addClient(String name, String? contactInfo) async {
    state = const AsyncLoading();

    final params = AddClientParams(name, contactInfo);

    final addClientUseCase = ref.read(addClientUseCaseProvider);
    final result = await addClientUseCase(params);

    if (result.isFailed) {
      state = AsyncError(result.errorMessage!, StackTrace.current);
      throw Exception(result.errorMessage);
    } else {
      state = const AsyncData(null);
    }
  }

  Future<void> updateClient(int id, String name, String? contactInfo) async {
    state = const AsyncLoading();

    final params = UpdateClientParams(id, name, contactInfo);

    final updateClientUseCase = ref.read(updateClientUseCaseProvider);
    final result = await updateClientUseCase(params);

    if (result.isFailed) {
      state = AsyncError(result.errorMessage!, StackTrace.current);
      throw Exception(result.errorMessage);
    } else {
      state = const AsyncData(null);
    }
  }
}