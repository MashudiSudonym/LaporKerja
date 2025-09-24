import 'package:lapor_kerja/core/utils/result.dart';
import 'package:lapor_kerja/core/utils/usecase.dart';
import 'package:lapor_kerja/domain/repositories/task_repository.dart';
import 'delete_task_params.dart';

class DeleteTaskUseCase implements UseCase<Result<void>, DeleteTaskParams> {
  final TaskRepository _taskRepository;

  DeleteTaskUseCase(this._taskRepository);

  @override
  Future<Result<void>> call(DeleteTaskParams params) {
    return _taskRepository.softDeleteTask(params.id);
  }
}