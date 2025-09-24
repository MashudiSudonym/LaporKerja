import 'package:lapor_kerja/core/utils/result.dart';
import 'package:lapor_kerja/core/utils/usecase.dart';
import 'package:lapor_kerja/domain/repositories/income_repository.dart';
import 'add_income_params.dart';

class AddIncomeUseCase implements UseCase<Result<void>, AddIncomeParams> {
  final IncomeRepository _incomeRepository;

  AddIncomeUseCase(this._incomeRepository);

  @override
  Future<Result<void>> call(AddIncomeParams params) {
    return _incomeRepository.createIncome(params.income);
  }
}