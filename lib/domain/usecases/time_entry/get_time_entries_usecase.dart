import 'package:lapor_kerja/domain/repositories/time_entry_repository.dart';
import '../../entities/time_entry_entity.dart';

class GetTimeEntriesUseCase {
  final TimeEntryRepository _timeEntryRepository;

  GetTimeEntriesUseCase(this._timeEntryRepository);

  Stream<List<TimeEntryEntity>> call() {
    return _timeEntryRepository.watchAllTimeEntries();
  }
}