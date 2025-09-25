import 'package:lapor_kerja/core/utils/result.dart';
import 'package:lapor_kerja/core/utils/usecase.dart';
import 'package:lapor_kerja/domain/entities/client_entity.dart';
import 'package:lapor_kerja/domain/repositories/client_repository.dart';
import 'update_client_params.dart';

class UpdateClientUseCase implements UseCase<Result<void>, UpdateClientParams> {
  final ClientRepository _clientRepository;

  UpdateClientUseCase(this._clientRepository);

  @override
  Future<Result<void>> call(UpdateClientParams params) async {
    // First get the existing client to preserve createdAt
    final getResult = await _clientRepository.getClientById(params.id);
    if (getResult.isFailed) {
      return Result.failed(getResult.errorMessage!);
    }

    final existingClient = getResult.resultValue!;
    final updatedClient = existingClient.copyWith(
      name: params.name,
      contactInfo: params.contactInfo,
      updatedAt: DateTime.now(),
    );

    return _clientRepository.updateClient(updatedClient);
  }
}