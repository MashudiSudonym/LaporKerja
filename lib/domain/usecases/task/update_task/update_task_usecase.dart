import 'package:lapor_kerja/core/utils/result.dart';
import 'package:lapor_kerja/core/utils/usecase.dart';
import 'package:lapor_kerja/domain/repositories/task_repository.dart';
import 'update_task_params.dart';

class UpdateTaskUseCase implements UseCase<Result<void>, UpdateTaskParams> {
  final TaskRepository _taskRepository;

  UpdateTaskUseCase(this._taskRepository);

  @override
  Future<Result<void>> call(UpdateTaskParams params) {
    return _taskRepository.updateTask(params.task);
  }
}