import 'package:lapor_kerja/domain/repositories/client_repository.dart';
import '../../entities/client_entity.dart';

class GetClientsUseCase {
  final ClientRepository _clientRepository;

  GetClientsUseCase(this._clientRepository);

  Stream<List<ClientEntity>> call() {
    return _clientRepository.watchAllClients();
  }
}