import 'package:lapor_kerja/core/utils/result.dart';
import 'package:lapor_kerja/core/utils/usecase.dart';
import 'package:lapor_kerja/domain/repositories/project_repository.dart';
import 'update_project_params.dart';

class UpdateProjectUseCase implements UseCase<Result<void>, UpdateProjectParams> {
  final ProjectRepository _projectRepository;

  UpdateProjectUseCase(this._projectRepository);

  @override
  Future<Result<void>> call(UpdateProjectParams params) {
    return _projectRepository.updateProject(params.project);
  }
}