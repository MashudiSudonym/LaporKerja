import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/project_entity.dart';
import '../../domain/usecases/project/add_project/add_project_params.dart';
import '../providers/ui/projects_provider.dart';

class ProjectsPage extends ConsumerWidget {
  const ProjectsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectsAsync = ref.watch(projectsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Projects'),
      ),
      body: projectsAsync.when(
        data: (projects) => ListView.builder(
          itemCount: projects.length,
          itemBuilder: (context, index) {
            final project = projects[index];
            return ListTile(
              title: Text(project.projectName ?? 'No name'),
              subtitle: Text(project.description ?? ''),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Example: Add a new project with hardcoded params
          // In real app, show dialog for input
          final project = ProjectEntity(
            id: 0, // Will be set by database
            projectName: 'New Project ${DateTime.now().millisecondsSinceEpoch}',
            description: 'Description',
            clientId: 1, // Assume some client ID
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            isDeleted: false,
          );
          final params = AddProjectParams(project);
          await ref.read(projectsProvider.notifier).addProject(params);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}