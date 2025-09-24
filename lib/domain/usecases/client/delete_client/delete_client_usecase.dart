import 'package:lapor_kerja/core/utils/result.dart';
import 'package:lapor_kerja/core/utils/usecase.dart';
import 'package:lapor_kerja/domain/repositories/client_repository.dart';
import 'delete_client_params.dart';

class DeleteClientUseCase implements UseCase<Result<void>, DeleteClientParams> {
  final ClientRepository _clientRepository;

  DeleteClientUseCase(this._clientRepository);

  @override
  Future<Result<void>> call(DeleteClientParams params) {
    return _clientRepository.softDeleteClient(params.id);
  }
}