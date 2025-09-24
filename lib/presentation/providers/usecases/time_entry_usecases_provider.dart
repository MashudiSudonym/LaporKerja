import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../domain/usecases/time_entry/add_time_entry/add_time_entry_usecase.dart';
import '../../../domain/usecases/time_entry/delete_time_entry/delete_time_entry_usecase.dart';
import '../../../domain/usecases/time_entry/get_time_entries_usecase.dart';
import '../../../domain/usecases/time_entry/update_time_entry/update_time_entry_usecase.dart';
import '../repositories/time_entry_repository_provider.dart';

part 'time_entry_usecases_provider.g.dart';

@riverpod
AddTimeEntryUseCase addTimeEntryUseCase(Ref ref) {
  final repo = ref.watch(timeEntryRepositoryProvider);
  return AddTimeEntryUseCase(repo);
}

@riverpod
UpdateTimeEntryUseCase updateTimeEntryUseCase(Ref ref) {
  final repo = ref.watch(timeEntryRepositoryProvider);
  return UpdateTimeEntryUseCase(repo);
}

@riverpod
DeleteTimeEntryUseCase deleteTimeEntryUseCase(Ref ref) {
  final repo = ref.watch(timeEntryRepositoryProvider);
  return DeleteTimeEntryUseCase(repo);
}

@riverpod
GetTimeEntriesUseCase getTimeEntriesUseCase(Ref ref) {
  final repo = ref.watch(timeEntryRepositoryProvider);
  return GetTimeEntriesUseCase(repo);
}