import 'package:lapor_kerja/core/utils/result.dart';
import 'package:lapor_kerja/core/utils/usecase.dart';
import 'package:lapor_kerja/domain/repositories/client_repository.dart';
import 'add_client_params.dart';

class AddClientUseCase implements UseCase<Result<void>, AddClientParams> {
  final ClientRepository _clientRepository;

  AddClientUseCase(this._clientRepository);

  @override
  Future<Result<void>> call(AddClientParams params) {
    return _clientRepository.createClient(params.client);
  }
}