import 'package:lapor_kerja/core/utils/result.dart';
import 'package:lapor_kerja/core/utils/usecase.dart';
import 'package:lapor_kerja/domain/repositories/client_repository.dart';
import 'update_client_params.dart';

class UpdateClientUseCase implements UseCase<Result<void>, UpdateClientParams> {
  final ClientRepository _clientRepository;

  UpdateClientUseCase(this._clientRepository);

  @override
  Future<Result<void>> call(UpdateClientParams params) {
    return _clientRepository.updateClient(params.client);
  }
}