import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../../domain/entities/time_entry_entity.dart';
import '../../providers/ui/time_entries_provider.dart';

/// List page for time entries
class TimeEntryListPage extends ConsumerStatefulWidget {
  const TimeEntryListPage({super.key});

  @override
  ConsumerState<TimeEntryListPage> createState() => _TimeEntryListPageState();
}

class _TimeEntryListPageState extends ConsumerState<TimeEntryListPage> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final timeEntriesAsync = ref.watch(timeEntriesProvider);

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search time entries...',
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
            child: timeEntriesAsync.when(
              data: (timeEntries) {
                final filteredTimeEntries = _searchQuery.isEmpty
                    ? timeEntries
                    : timeEntries.where((entry) {
                        return 'task ${entry.taskId}'.contains(_searchQuery) ||
                            entry.startTime.toString().contains(_searchQuery) ||
                            (entry.endTime?.toString().contains(_searchQuery) ?? false);
                      }).toList();

                return RefreshIndicator(
                  onRefresh: () async => ref.invalidate(timeEntriesProvider),
                  child: _TimeEntryListView(timeEntries: filteredTimeEntries),
                );
              },
              loading: () => const _TimeEntryListSkeleton(),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Error: $error'),
                    ShadButton(
                      onPressed: () => ref.invalidate(timeEntriesProvider),
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
        onPressed: () => context.go('/time-entries/new'),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _TimeEntryListSkeleton extends StatelessWidget {
  const _TimeEntryListSkeleton();

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
                      width: 120,
                      color: Colors.grey[300],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 12,
                      width: 200,
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

class _TimeEntryListView extends StatelessWidget {
  const _TimeEntryListView({required this.timeEntries});

  final List<TimeEntryEntity> timeEntries;

  @override
  Widget build(BuildContext context) {
    if (timeEntries.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.timer_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No time entries yet',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              'Tap the + button to log your first time entry',
              style: TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: timeEntries.length,
      itemBuilder: (context, index) {
        final timeEntry = timeEntries[index];
        return ListTile(
          title: Text('Task ${timeEntry.taskId}'),
          subtitle: Text('${timeEntry.startTime} - ${timeEntry.endTime ?? 'Ongoing'}'),
          trailing: IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => context.go('/time-entries/${timeEntry.id}/edit'),
          ),
        );
      },
    );
  }
}