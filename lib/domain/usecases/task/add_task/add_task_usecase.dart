import 'package:lapor_kerja/core/utils/result.dart';
import 'package:lapor_kerja/core/utils/usecase.dart';
import 'package:lapor_kerja/domain/repositories/task_repository.dart';
import 'add_task_params.dart';

class AddTaskUseCase implements UseCase<Result<void>, AddTaskParams> {
  final TaskRepository _taskRepository;

  AddTaskUseCase(this._taskRepository);

  @override
  Future<Result<void>> call(AddTaskParams params) {
    return _taskRepository.createTask(params.task);
  }
}