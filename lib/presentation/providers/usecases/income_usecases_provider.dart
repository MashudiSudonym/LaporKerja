import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../domain/usecases/income/add_income/add_income_usecase.dart';
import '../../../domain/usecases/income/delete_income/delete_income_usecase.dart';
import '../../../domain/usecases/income/get_incomes_usecase.dart';
import '../../../domain/usecases/income/update_income/update_income_usecase.dart';
import '../repositories/income_repository_provider.dart';

part 'income_usecases_provider.g.dart';

@riverpod
AddIncomeUseCase addIncomeUseCase(Ref ref) {
  final repo = ref.watch(incomeRepositoryProvider);
  return AddIncomeUseCase(repo);
}

@riverpod
UpdateIncomeUseCase updateIncomeUseCase(Ref ref) {
  final repo = ref.watch(incomeRepositoryProvider);
  return UpdateIncomeUseCase(repo);
}

@riverpod
DeleteIncomeUseCase deleteIncomeUseCase(Ref ref) {
  final repo = ref.watch(incomeRepositoryProvider);
  return DeleteIncomeUseCase(repo);
}

@riverpod
GetIncomesUseCase getIncomesUseCase(Ref ref) {
  final repo = ref.watch(incomeRepositoryProvider);
  return GetIncomesUseCase(repo);
}