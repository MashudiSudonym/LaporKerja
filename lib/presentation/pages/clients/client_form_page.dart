import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../providers/ui/client_form_notifier.dart';

/// Form page for clients
class ClientFormPage extends ConsumerStatefulWidget {
  const ClientFormPage({super.key, this.clientId});

  final int? clientId;

  @override
  ConsumerState<ClientFormPage> createState() => _ClientFormPageState();
}

class _ClientFormPageState extends ConsumerState<ClientFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _contactController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.clientId != null;
    final formState = ref.watch(clientFormProvider);

    ref.listen(clientFormProvider, (previous, next) {
      next.when(
        data: (_) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(isEditing ? 'Client updated' : 'Client added'),
              ),
            );
            context.go('/clients');
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
        title: Text(isEditing ? 'Edit Client' : 'Add Client'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width > 600 ? 32.0 : 16.0,
          vertical: 16.0,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
               TextFormField(
                 controller: _nameController,
                 decoration: const InputDecoration(
                   labelText: 'Client Name',
                   border: OutlineInputBorder(),
                 ),
                 validator: (value) {
                   if (value == null || value.isEmpty) {
                     return 'Client name is required';
                   }
                   if (value.trim().length < 2) {
                     return 'Client name must be at least 2 characters long';
                   }
                   return null;
                 },
               ),
              const SizedBox(height: 16),
               TextFormField(
                 controller: _contactController,
                 decoration: const InputDecoration(
                   labelText: 'Contact Info (optional)',
                   border: OutlineInputBorder(),
                 ),
               ),
              const SizedBox(height: 24),
               ShadButton(
                 onPressed: formState.isLoading
                     ? null
                     : () async {
                          if (_formKey.currentState!.validate()) {
                            if (isEditing) {
                              await ref
                                  .read(clientFormProvider.notifier)
                                  .updateClient(
                                    widget.clientId!,
                                    _nameController.text,
                                    _contactController.text.isEmpty
                                        ? null
                                        : _contactController.text,
                                  );
                            } else {
                              await ref
                                  .read(clientFormProvider.notifier)
                                  .addClient(
                                    _nameController.text,
                                    _contactController.text.isEmpty
                                        ? null
                                        : _contactController.text,
                                  );
                            }
                          }
                       },
                 child: formState.isLoading
                     ? const CircularProgressIndicator()
                     : Text(isEditing ? 'Update Client' : 'Add Client'),
               ),
            ],
          ),
        ),
      ),
    );
  }
}