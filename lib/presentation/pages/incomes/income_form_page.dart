import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/ui/income_form_notifier.dart';

/// Form page for incomes
class IncomeFormPage extends ConsumerStatefulWidget {
  const IncomeFormPage({super.key, this.incomeId});

  final int? incomeId;

  @override
  ConsumerState<IncomeFormPage> createState() => _IncomeFormPageState();
}

class _IncomeFormPageState extends ConsumerState<IncomeFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _projectIdController = TextEditingController();
  final _amountController = TextEditingController();
  final _paymentStatusController = TextEditingController();
  final _paymentDateController = TextEditingController();

  @override
  void dispose() {
    _projectIdController.dispose();
    _amountController.dispose();
    _paymentStatusController.dispose();
    _paymentDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.incomeId != null;
    final formState = ref.watch(incomeFormProvider);

    ref.listen(incomeFormProvider, (previous, next) {
      next.when(
        data: (_) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(isEditing ? 'Income updated' : 'Income added'),
              ),
            );
            context.go('/incomes');
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
        title: Text(isEditing ? 'Edit Income' : 'Add Income'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
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
                    return 'Please enter project ID';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter amount';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _paymentStatusController,
                decoration: const InputDecoration(
                  labelText: 'Payment Status (optional)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _paymentDateController,
                decoration: const InputDecoration(
                  labelText: 'Payment Date (YYYY-MM-DD, optional)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: formState.isLoading
                      ? null
                      : () async {
                          if (_formKey.currentState!.validate()) {
                            try {
                              final projectId = int.parse(_projectIdController.text);
                              final amount = double.parse(_amountController.text);
                              final paymentDate = _paymentDateController.text.isEmpty
                                  ? null
                                  : DateTime.parse(_paymentDateController.text);

                              if (isEditing) {
                                await ref
                                    .read(incomeFormProvider.notifier)
                                    .updateIncome(
                                      widget.incomeId!,
                                      projectId,
                                      amount,
                                      _paymentStatusController.text.isEmpty
                                          ? null
                                          : _paymentStatusController.text,
                                      paymentDate,
                                    );
                              } else {
                                await ref
                                    .read(incomeFormProvider.notifier)
                                    .addIncome(
                                      projectId,
                                      amount,
                                      _paymentStatusController.text.isEmpty
                                          ? null
                                          : _paymentStatusController.text,
                                      paymentDate,
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
                      : Text(isEditing ? 'Update Income' : 'Add Income'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}