import 'package:lapor_kerja/core/utils/result.dart';
import 'package:lapor_kerja/core/utils/usecase.dart';
import 'package:lapor_kerja/domain/entities/client_entity.dart';
import 'package:lapor_kerja/domain/repositories/client_repository.dart';
import 'add_client_params.dart';

class AddClientUseCase implements UseCase<Result<void>, AddClientParams> {
  final ClientRepository _clientRepository;

  AddClientUseCase(this._clientRepository);

  @override
  Future<Result<void>> call(AddClientParams params) {
    final client = ClientEntity(
      id: 0, // Will be set by database
      name: params.name,
      contactInfo: params.contactInfo,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      isDeleted: false,
    );
    return _clientRepository.createClient(client);
  }
}