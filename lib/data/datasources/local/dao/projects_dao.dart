import 'package:drift/drift.dart';

import '../app_database.dart';
import '../../../models/local/projects.dart';
import '../../../models/local/clients.dart';

part 'projects_dao.g.dart';

class ProjectWithClient {
  final Project project;
  final Client? client;

  ProjectWithClient({
    required this.project,
    this.client,
  });
}

@DriftAccessor(tables: [Projects, Clients])
class ProjectsDao extends DatabaseAccessor<AppDatabase> with _$ProjectsDaoMixin {

  ProjectsDao(super.attachedDatabase);

  Stream<List<ProjectWithClient>> watchAllProjectsWithClient() {
    final query = select(projects).join([
      leftOuterJoin(clients, clients.id.equalsExp(projects.clientId)),
    ]);

    return query.watch().map((rows) {
      return rows.map((row) {
        return ProjectWithClient(
          project: row.readTable(projects),
          client: row.readTableOrNull(clients),
        );
      }).toList();
    });
  }

  // Mengambil semua project yang belum disinkronisasi
  Future<List<Project>> getUnsyncedProjects() {
    return (select(projects)..where((p) => p.isSynced.equals(false))).get();
  }

  Future<int> upsertProject(ProjectsCompanion entry) {
    return into(projects).insertOnConflictUpdate(entry);
  }

  Future<int> softDeleteProject(int id) {
    return (update(projects)..where((p) => p.id.equals(id))).write(
      ProjectsCompanion(
        isDeleted: const Value(true),
        lastModified: Value(DateTime.now()),
      ),
    );
  }
}