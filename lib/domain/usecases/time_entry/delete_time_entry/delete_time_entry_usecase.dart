import 'package:lapor_kerja/core/utils/result.dart';
import 'package:lapor_kerja/core/utils/usecase.dart';
import 'package:lapor_kerja/domain/repositories/time_entry_repository.dart';
import 'delete_time_entry_params.dart';

class DeleteTimeEntryUseCase implements UseCase<Result<void>, DeleteTimeEntryParams> {
  final TimeEntryRepository _timeEntryRepository;

  DeleteTimeEntryUseCase(this._timeEntryRepository);

  @override
  Future<Result<void>> call(DeleteTimeEntryParams params) {
    return _timeEntryRepository.softDeleteTimeEntry(params.id);
  }
}