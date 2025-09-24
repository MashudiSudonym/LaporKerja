import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../domain/entities/time_entry_entity.dart';
import '../../../domain/usecases/time_entry/add_time_entry/add_time_entry_params.dart';
import '../../../domain/usecases/time_entry/delete_time_entry/delete_time_entry_params.dart';
import '../../../domain/usecases/time_entry/update_time_entry/update_time_entry_params.dart';
import '../usecases/time_entry_usecases_provider.dart';

part 'time_entries_provider.g.dart';

@riverpod
class TimeEntriesNotifier extends _$TimeEntriesNotifier {
  @override
  Stream<List<TimeEntryEntity>> build() {
    final getTimeEntries = ref.watch(getTimeEntriesUseCaseProvider);
    return getTimeEntries();
  }

  Future<void> addTimeEntry(AddTimeEntryParams params) async {
    final addTimeEntry = ref.read(addTimeEntryUseCaseProvider);
    final result = await addTimeEntry(params);
    if (result.isFailed) {
      throw Exception(result.errorMessage);
    }
    ref.invalidateSelf();
  }

  Future<void> updateTimeEntry(UpdateTimeEntryParams params) async {
    final updateTimeEntry = ref.read(updateTimeEntryUseCaseProvider);
    final result = await updateTimeEntry(params);
    if (result.isFailed) {
      throw Exception(result.errorMessage);
    }
    ref.invalidateSelf();
  }

  Future<void> deleteTimeEntry(DeleteTimeEntryParams params) async {
    final deleteTimeEntry = ref.read(deleteTimeEntryUseCaseProvider);
    final result = await deleteTimeEntry(params);
    if (result.isFailed) {
      throw Exception(result.errorMessage);
    }
    ref.invalidateSelf();
  }
}