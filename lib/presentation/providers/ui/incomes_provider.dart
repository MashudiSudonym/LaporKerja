import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../domain/entities/income_entity.dart';
import '../../../domain/usecases/income/add_income/add_income_params.dart';
import '../../../domain/usecases/income/delete_income/delete_income_params.dart';
import '../../../domain/usecases/income/update_income/update_income_params.dart';
import '../usecases/income_usecases_provider.dart';

part 'incomes_provider.g.dart';

@riverpod
class IncomesNotifier extends _$IncomesNotifier {
  @override
  Stream<List<IncomeEntity>> build() {
    final getIncomes = ref.watch(getIncomesUseCaseProvider);
    return getIncomes();
  }

  Future<void> addIncome(AddIncomeParams params) async {
    final addIncome = ref.read(addIncomeUseCaseProvider);
    final result = await addIncome(params);
    if (result.isFailed) {
      throw Exception(result.errorMessage);
    }
    ref.invalidateSelf();
  }

  Future<void> updateIncome(UpdateIncomeParams params) async {
    final updateIncome = ref.read(updateIncomeUseCaseProvider);
    final result = await updateIncome(params);
    if (result.isFailed) {
      throw Exception(result.errorMessage);
    }
    ref.invalidateSelf();
  }

  Future<void> deleteIncome(DeleteIncomeParams params) async {
    final deleteIncome = ref.read(deleteIncomeUseCaseProvider);
    final result = await deleteIncome(params);
    if (result.isFailed) {
      throw Exception(result.errorMessage);
    }
    ref.invalidateSelf();
  }
}