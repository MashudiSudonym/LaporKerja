import 'package:lapor_kerja/core/utils/result.dart';
import 'package:lapor_kerja/core/utils/usecase.dart';
import 'package:lapor_kerja/domain/repositories/time_entry_repository.dart';
import 'add_time_entry_params.dart';

class AddTimeEntryUseCase implements UseCase<Result<void>, AddTimeEntryParams> {
  final TimeEntryRepository _timeEntryRepository;

  AddTimeEntryUseCase(this._timeEntryRepository);

  @override
  Future<Result<void>> call(AddTimeEntryParams params) {
    return _timeEntryRepository.createTimeEntry(params.timeEntry);
  }
}