import 'package:lapor_kerja/core/utils/result.dart';
import 'package:lapor_kerja/core/utils/usecase.dart';
import 'package:lapor_kerja/domain/repositories/income_repository.dart';
import 'update_income_params.dart';

class UpdateIncomeUseCase implements UseCase<Result<void>, UpdateIncomeParams> {
  final IncomeRepository _incomeRepository;

  UpdateIncomeUseCase(this._incomeRepository);

  @override
  Future<Result<void>> call(UpdateIncomeParams params) {
    return _incomeRepository.updateIncome(params.income);
  }
}