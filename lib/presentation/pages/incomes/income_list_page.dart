import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../../domain/entities/income_entity.dart';
import '../../providers/ui/incomes_provider.dart';

/// List page for incomes
class IncomeListPage extends ConsumerStatefulWidget {
  const IncomeListPage({super.key});

  @override
  ConsumerState<IncomeListPage> createState() => _IncomeListPageState();
}

class _IncomeListPageState extends ConsumerState<IncomeListPage> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final incomesAsync = ref.watch(incomesProvider);

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search incomes...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Theme.of(context).cardColor,
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
            ),
          ),
          Expanded(
            child: incomesAsync.when(
              data: (incomes) {
                final filteredIncomes = _searchQuery.isEmpty
                    ? incomes
                    : incomes.where((income) {
                        return income.amount.toString().contains(_searchQuery) ||
                            (income.paymentStatus?.toLowerCase().contains(_searchQuery) ?? false) ||
                            'project ${income.projectId}'.contains(_searchQuery);
                      }).toList();

                return RefreshIndicator(
                  onRefresh: () async => ref.invalidate(incomesProvider),
                  child: _IncomeListView(incomes: filteredIncomes),
                );
              },
              loading: () => const _IncomeListSkeleton(),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Error: $error'),
                    ShadButton(
                      onPressed: () => ref.invalidate(incomesProvider),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/incomes/new'),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _IncomeListSkeleton extends StatelessWidget {
  const _IncomeListSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 16,
                      width: 100,
                      color: Colors.grey[300],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 12,
                      width: 150,
                      color: Colors.grey[300],
                    ),
                  ],
                ),
              ),
              Container(
                width: 24,
                height: 24,
                color: Colors.grey[300],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _IncomeListView extends StatelessWidget {
  const _IncomeListView({required this.incomes});

  final List<IncomeEntity> incomes;

  @override
  Widget build(BuildContext context) {
    if (incomes.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.attach_money_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No incomes yet',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              'Tap the + button to record your first income',
              style: TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
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