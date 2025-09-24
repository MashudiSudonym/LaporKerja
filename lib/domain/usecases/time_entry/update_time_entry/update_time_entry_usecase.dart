import 'package:lapor_kerja/core/utils/result.dart';
import 'package:lapor_kerja/core/utils/usecase.dart';
import 'package:lapor_kerja/domain/repositories/time_entry_repository.dart';
import 'update_time_entry_params.dart';

class UpdateTimeEntryUseCase implements UseCase<Result<void>, UpdateTimeEntryParams> {
  final TimeEntryRepository _timeEntryRepository;

  UpdateTimeEntryUseCase(this._timeEntryRepository);

  @override
  Future<Result<void>> call(UpdateTimeEntryParams params) {
    return _timeEntryRepository.updateTimeEntry(params.timeEntry);
  }
}