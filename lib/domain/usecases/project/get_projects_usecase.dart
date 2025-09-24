import 'package:lapor_kerja/domain/repositories/project_repository.dart';
import '../../entities/project_entity.dart';

class GetProjectsUseCase {
  final ProjectRepository _projectRepository;

  GetProjectsUseCase(this._projectRepository);

  Stream<List<ProjectEntity>> call() {
    return _projectRepository.watchAllProjects();
  }
}