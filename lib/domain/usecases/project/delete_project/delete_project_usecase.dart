import 'package:lapor_kerja/core/utils/result.dart';
import 'package:lapor_kerja/core/utils/usecase.dart';
import 'package:lapor_kerja/domain/repositories/project_repository.dart';
import 'delete_project_params.dart';

class DeleteProjectUseCase implements UseCase<Result<void>, DeleteProjectParams> {
  final ProjectRepository _projectRepository;

  DeleteProjectUseCase(this._projectRepository);

  @override
  Future<Result<void>> call(DeleteProjectParams params) {
    return _projectRepository.softDeleteProject(params.id);
  }
}