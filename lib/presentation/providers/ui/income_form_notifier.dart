import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../domain/entities/income_entity.dart';
import '../../../domain/usecases/income/add_income/add_income_params.dart';
import '../../../domain/usecases/income/update_income/update_income_params.dart';
import '../usecases/income_usecases_provider.dart';

part 'income_form_notifier.g.dart';

/// AsyncNotifier for income form operations
@riverpod
class IncomeFormNotifier extends _$IncomeFormNotifier {
  @override
  FutureOr<void> build() {}

  Future<void> addIncome(int projectId, double amount, String? paymentStatus, DateTime? paymentDate) async {
    state = const AsyncLoading();

    final income = IncomeEntity(
      id: 0,
      projectId: projectId,
      amount: amount,
      paymentStatus: paymentStatus,
      paymentDate: paymentDate,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      isDeleted: false,
    );

    final params = AddIncomeParams(income);

    final addIncomeUseCase = ref.read(addIncomeUseCaseProvider);
    final result = await addIncomeUseCase(params);

    if (result.isFailed) {
      state = AsyncError(result.errorMessage!, StackTrace.current);
      throw Exception(result.errorMessage);
    } else {
      state = const AsyncData(null);
    }
  }

  Future<void> updateIncome(int id, int projectId, double amount, String? paymentStatus, DateTime? paymentDate) async {
    state = const AsyncLoading();

    final income = IncomeEntity(
      id: id,
      projectId: projectId,
      amount: amount,
      paymentStatus: paymentStatus,
      paymentDate: paymentDate,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      isDeleted: false,
    );

    final params = UpdateIncomeParams(income);

    final updateIncomeUseCase = ref.read(updateIncomeUseCaseProvider);
    final result = await updateIncomeUseCase(params);

    if (result.isFailed) {
      state = AsyncError(result.errorMessage!, StackTrace.current);
      throw Exception(result.errorMessage);
    } else {
      state = const AsyncData(null);
    }
  }
}