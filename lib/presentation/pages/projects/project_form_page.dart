import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../providers/ui/project_form_notifier.dart';

/// Form page for adding/editing projects
class ProjectFormPage extends ConsumerStatefulWidget {
  const ProjectFormPage({super.key, this.projectId});

  final int? projectId;

  @override
  ConsumerState<ProjectFormPage> createState() => _ProjectFormPageState();
}

class _ProjectFormPageState extends ConsumerState<ProjectFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.projectId != null;
    final formState = ref.watch(projectFormProvider);

    ref.listen(projectFormProvider, (previous, next) {
      next.when(
        data: (_) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(isEditing ? 'Project updated' : 'Project added'),
              ),
            );
            context.go('/projects');
          }
        },
        error: (error, stack) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: $error')),
            );
          }
        },
        loading: () {},
      );
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Project' : 'Add Project'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
               TextFormField(
                 controller: _nameController,
                 decoration: const InputDecoration(
                   labelText: 'Project Name',
                   border: OutlineInputBorder(),
                 ),
                 validator: (value) {
                   if (value == null || value.isEmpty) {
                     return 'Project name is required';
                   }
                   if (value.trim().length < 3) {
                     return 'Project name must be at least 3 characters long';
                   }
                   return null;
                 },
               ),
              const SizedBox(height: 16),
               TextFormField(
                 controller: _descriptionController,
                 decoration: const InputDecoration(
                   labelText: 'Description (optional)',
                   border: OutlineInputBorder(),
                 ),
                 maxLines: 3,
               ),
              const SizedBox(height: 24),
               ShadButton(
                 onPressed: formState.isLoading
                     ? null
                     : () async {
                         if (_formKey.currentState!.validate()) {
                           try {
                             if (isEditing) {
                               await ref
                                   .read(projectFormProvider.notifier)
                                   .updateProject(
                                     widget.projectId!,
                                     _nameController.text,
                                     _descriptionController.text.isEmpty
                                         ? null
                                         : _descriptionController.text,
                                   );
                             } else {
                               await ref
                                   .read(projectFormProvider.notifier)
                                   .addProject(
                                     _nameController.text,
                                     _descriptionController.text.isEmpty
                                         ? null
                                         : _descriptionController.text,
                                   );
                             }
                           } catch (e) {
                             // Error handled by listener
                           }
                         }
                       },
                 child: formState.isLoading
                     ? const CircularProgressIndicator()
                     : Text(isEditing ? 'Update Project' : 'Add Project'),
               ),
            ],
          ),
        ),
      ),
    );
  }
}