import 'package:lapor_kerja/domain/repositories/income_repository.dart';
import '../../entities/income_entity.dart';

class GetIncomesUseCase {
  final IncomeRepository _incomeRepository;

  GetIncomesUseCase(this._incomeRepository);

  Stream<List<IncomeEntity>> call() {
    return _incomeRepository.watchAllIncomes();
  }
}