import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../domain/entities/time_entry_entity.dart';
import '../../../domain/usecases/time_entry/add_time_entry/add_time_entry_params.dart';
import '../../../domain/usecases/time_entry/update_time_entry/update_time_entry_params.dart';
import '../usecases/time_entry_usecases_provider.dart';

part 'time_entry_form_notifier.g.dart';

/// AsyncNotifier for time entry form operations
@riverpod
class TimeEntryFormNotifier extends _$TimeEntryFormNotifier {
  @override
  FutureOr<void> build() {}

  Future<void> addTimeEntry(int taskId, DateTime startTime, DateTime? endTime) async {
    state = const AsyncLoading();

    final timeEntry = TimeEntryEntity(
      id: 0,
      taskId: taskId,
      startTime: startTime,
      endTime: endTime,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      isDeleted: false,
    );

    final params = AddTimeEntryParams(timeEntry);

    final addTimeEntryUseCase = ref.read(addTimeEntryUseCaseProvider);
    final result = await addTimeEntryUseCase(params);

    if (result.isFailed) {
      state = AsyncError(result.errorMessage!, StackTrace.current);
      throw Exception(result.errorMessage);
    } else {
      state = const AsyncData(null);
    }
  }

  Future<void> updateTimeEntry(int id, int taskId, DateTime startTime, DateTime? endTime) async {
    state = const AsyncLoading();

    final timeEntry = TimeEntryEntity(
      id: id,
      taskId: taskId,
      startTime: startTime,
      endTime: endTime,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      isDeleted: false,
    );

    final params = UpdateTimeEntryParams(timeEntry);

    final updateTimeEntryUseCase = ref.read(updateTimeEntryUseCaseProvider);
    final result = await updateTimeEntryUseCase(params);

    if (result.isFailed) {
      state = AsyncError(result.errorMessage!, StackTrace.current);
      throw Exception(result.errorMessage);
    } else {
      state = const AsyncData(null);
    }
  }
}