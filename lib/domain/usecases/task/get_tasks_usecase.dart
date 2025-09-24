import 'package:lapor_kerja/domain/repositories/task_repository.dart';
import '../../entities/task_entity.dart';

class GetTasksUseCase {
  final TaskRepository _taskRepository;

  GetTasksUseCase(this._taskRepository);

  Stream<List<TaskEntity>> call() {
    return _taskRepository.watchAllTasks();
  }
}