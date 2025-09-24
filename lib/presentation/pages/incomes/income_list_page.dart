import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/entities/income_entity.dart';
import '../../providers/ui/incomes_provider.dart';

/// List page for incomes
class IncomeListPage extends ConsumerWidget {
  const IncomeListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final incomesAsync = ref.watch(incomesProvider);

    return Scaffold(
      body: incomesAsync.when(
        data: (incomes) => _IncomeListView(incomes: incomes),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Error: $error'),
              ElevatedButton(
                onPressed: () => ref.invalidate(incomesProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/incomes/new'),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _IncomeListView extends StatelessWidget {
  const _IncomeListView({required this.incomes});

  final List<IncomeEntity> incomes;

  @override
  Widget build(BuildContext context) {
    if (incomes.isEmpty) {
      return const Center(child: Text('No incomes yet'));
    }

    return ListView.builder(
      itemCount: incomes.length,
      itemBuilder: (context, index) {
        final income = incomes[index];
        return ListTile(
          title: Text('\$${income.amount}'),
          subtitle: Text('Project ${income.projectId} - ${income.paymentStatus ?? 'Pending'}'),
          trailing: IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => context.go('/incomes/${income.id}/edit'),
          ),
        );
      },
    );
  }
}