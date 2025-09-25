import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../providers/ui/task_form_notifier.dart';

/// Form page for tasks
class TaskFormPage extends ConsumerStatefulWidget {
  const TaskFormPage({super.key, this.taskId});

  final int? taskId;

  @override
  ConsumerState<TaskFormPage> createState() => _TaskFormPageState();
}

class _TaskFormPageState extends ConsumerState<TaskFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _projectIdController = TextEditingController();
  final _taskNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _statusController = TextEditingController();
  final _deadlineController = TextEditingController();

  @override
  void dispose() {
    _projectIdController.dispose();
    _taskNameController.dispose();
    _descriptionController.dispose();
    _statusController.dispose();
    _deadlineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.taskId != null;
    final formState = ref.watch(taskFormProvider);

    ref.listen(taskFormProvider, (previous, next) {
      next.when(
        data: (_) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(isEditing ? 'Task updated' : 'Task added'),
              ),
            );
            context.go('/tasks');
          }
        },
        error: (error, stack) {
          if (context.mounted) {
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
        title: Text(isEditing ? 'Edit Task' : 'Add Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
               TextFormField(
                 controller: _projectIdController,
                 decoration: const InputDecoration(
                   labelText: 'Project ID',
                   border: OutlineInputBorder(),
                 ),
                 keyboardType: TextInputType.number,
                 validator: (value) {
                   if (value == null || value.isEmpty) {
                     return 'Project ID is required';
                   }
                   final projectId = int.tryParse(value);
                   if (projectId == null) {
                     return 'Project ID must be a valid number';
                   }
                   if (projectId <= 0) {
                     return 'Project ID must be a positive number';
                   }
                   return null;
                 },
               ),
              const SizedBox(height: 16),
               ShadInputFormField(
                 controller: _taskNameController,
                 placeholder: const Text('Task Name'),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Task name is required';
                    }
                   if (value.trim().length < 2) {
                     return 'Task name must be at least 2 characters long';
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
              const SizedBox(height: 16),
               TextFormField(
                 controller: _statusController,
                 decoration: const InputDecoration(
                   labelText: 'Status (optional)',
                   border: OutlineInputBorder(),
                 ),
               ),
              const SizedBox(height: 16),
                TextFormField(
                  controller: _deadlineController,
                  decoration: const InputDecoration(
                    labelText: 'Deadline (YYYY-MM-DD, optional)',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      try {
                        DateTime.parse(value);
                      } catch (e) {
                        return 'Deadline must be in YYYY-MM-DD format';
                      }
                    }
                    return null;
                  },
                ),
              const SizedBox(height: 24),
               ShadButton(
                 onPressed: formState.isLoading
                     ? null
                     : () async {
                          if (_formKey.currentState!.validate()) {
                            final projectId = int.parse(_projectIdController.text);
                            final deadline = _deadlineController.text.isEmpty
                                ? null
                                : DateTime.parse(_deadlineController.text);

                            if (isEditing) {
                              await ref
                                  .read(taskFormProvider.notifier)
                                  .updateTask(
                                    widget.taskId!,
                                    projectId,
                                    _taskNameController.text,
                                    _descriptionController.text.isEmpty
                                        ? null
                                        : _descriptionController.text,
                                    _statusController.text.isEmpty
                                        ? null
                                        : _statusController.text,
                                    deadline,
                                  );
                            } else {
                              await ref
                                  .read(taskFormProvider.notifier)
                                  .addTask(
                                    projectId,
                                    _taskNameController.text,
                                    _descriptionController.text.isEmpty
                                        ? null
                                        : _descriptionController.text,
                                    _statusController.text.isEmpty
                                        ? null
                                        : _statusController.text,
                                    deadline,
                                  );
                            }
                          }
                       },
                 child: formState.isLoading
                     ? const CircularProgressIndicator()
                     : Text(isEditing ? 'Update Task' : 'Add Task'),
               ),
            ],
          ),
        ),
      ),
    );
  }
}