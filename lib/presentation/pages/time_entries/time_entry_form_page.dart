import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../providers/ui/time_entry_form_notifier.dart';

/// Form page for time entries
class TimeEntryFormPage extends ConsumerStatefulWidget {
  const TimeEntryFormPage({super.key, this.timeEntryId});

  final int? timeEntryId;

  @override
  ConsumerState<TimeEntryFormPage> createState() => _TimeEntryFormPageState();
}

class _TimeEntryFormPageState extends ConsumerState<TimeEntryFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _taskIdController = TextEditingController();
  final _startTimeController = TextEditingController();
  final _endTimeController = TextEditingController();

  @override
  void dispose() {
    _taskIdController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.timeEntryId != null;
    final formState = ref.watch(timeEntryFormProvider);

    ref.listen(timeEntryFormProvider, (previous, next) {
      next.when(
        data: (_) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(isEditing ? 'Time entry updated' : 'Time entry added'),
              ),
            );
            context.go('/time-entries');
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
        title: Text(isEditing ? 'Edit Time Entry' : 'Add Time Entry'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
               TextFormField(
                 controller: _taskIdController,
                 decoration: const InputDecoration(
                   labelText: 'Task ID',
                   border: OutlineInputBorder(),
                 ),
                 keyboardType: TextInputType.number,
                 validator: (value) {
                   if (value == null || value.isEmpty) {
                     return 'Task ID is required';
                   }
                   final taskId = int.tryParse(value);
                   if (taskId == null) {
                     return 'Task ID must be a valid number';
                   }
                   if (taskId <= 0) {
                     return 'Task ID must be a positive number';
                   }
                   return null;
                 },
               ),
              const SizedBox(height: 16),
               TextFormField(
                 controller: _startTimeController,
                 decoration: const InputDecoration(
                   labelText: 'Start Time (YYYY-MM-DD HH:MM:SS)',
                   border: OutlineInputBorder(),
                 ),
                 validator: (value) {
                   if (value == null || value.isEmpty) {
                     return 'Start time is required';
                   }
                   try {
                     DateTime.parse(value);
                   } catch (e) {
                     return 'Start time must be in YYYY-MM-DD HH:MM:SS format';
                   }
                   return null;
                 },
               ),
              const SizedBox(height: 16),
               TextFormField(
                 controller: _endTimeController,
                 decoration: const InputDecoration(
                   labelText: 'End Time (optional, YYYY-MM-DD HH:MM:SS)',
                   border: OutlineInputBorder(),
                 ),
                 validator: (value) {
                   if (value != null && value.isNotEmpty) {
                     try {
                       DateTime.parse(value);
                     } catch (e) {
                       return 'End time must be in YYYY-MM-DD HH:MM:SS format';
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
                           try {
                             final taskId = int.parse(_taskIdController.text);
                             final startTime = DateTime.parse(_startTimeController.text);
                             final endTime = _endTimeController.text.isEmpty
                                 ? null
                                 : DateTime.parse(_endTimeController.text);

                             if (isEditing) {
                               await ref
                                   .read(timeEntryFormProvider.notifier)
                                   .updateTimeEntry(
                                     widget.timeEntryId!,
                                     taskId,
                                     startTime,
                                     endTime,
                                   );
                             } else {
                               await ref
                                   .read(timeEntryFormProvider.notifier)
                                   .addTimeEntry(
                                     taskId,
                                     startTime,
                                     endTime,
                                   );
                             }
                           } catch (e) {
                             if (mounted) {
                               ScaffoldMessenger.of(context).showSnackBar(
                                 SnackBar(content: Text('Error: $e')),
                               );
                             }
                           }
                         }
                       },
                 child: formState.isLoading
                     ? const CircularProgressIndicator()
                     : Text(isEditing ? 'Update Time Entry' : 'Add Time Entry'),
               ),
            ],
          ),
        ),
      ),
    );
  }
}