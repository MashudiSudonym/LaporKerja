import 'package:lapor_kerja/core/utils/result.dart';
import 'package:lapor_kerja/core/utils/usecase.dart';
import 'package:lapor_kerja/domain/repositories/income_repository.dart';
import 'delete_income_params.dart';

class DeleteIncomeUseCase implements UseCase<Result<void>, DeleteIncomeParams> {
  final IncomeRepository _incomeRepository;

  DeleteIncomeUseCase(this._incomeRepository);

  @override
  Future<Result<void>> call(DeleteIncomeParams params) {
    return _incomeRepository.softDeleteIncome(params.id);
  }
}