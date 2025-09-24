import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/entities/time_entry_entity.dart';
import '../../providers/ui/time_entries_provider.dart';

/// List page for time entries
class TimeEntryListPage extends ConsumerWidget {
  const TimeEntryListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timeEntriesAsync = ref.watch(timeEntriesProvider);

    return Scaffold(
      body: timeEntriesAsync.when(
        data: (timeEntries) => _TimeEntryListView(timeEntries: timeEntries),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Error: $error'),
              ElevatedButton(
                onPressed: () => ref.invalidate(timeEntriesProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/time-entries/new'),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _TimeEntryListView extends StatelessWidget {
  const _TimeEntryListView({required this.timeEntries});

  final List<TimeEntryEntity> timeEntries;

  @override
  Widget build(BuildContext context) {
    if (timeEntries.isEmpty) {
      return const Center(child: Text('No time entries yet'));
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