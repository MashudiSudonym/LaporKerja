import 'package:lapor_kerja/core/utils/result.dart';
import 'package:lapor_kerja/core/utils/usecase.dart';
import 'package:lapor_kerja/domain/repositories/project_repository.dart';
import 'add_project_params.dart';

class AddProjectUseCase implements UseCase<Result<void>, AddProjectParams> {
  final ProjectRepository _projectRepository;

  AddProjectUseCase(this._projectRepository);

  @override
  Future<Result<void>> call(AddProjectParams params) {
    return _projectRepository.createProject(params.project);
  }
}