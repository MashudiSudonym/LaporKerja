import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/entities/client_entity.dart';
import '../../providers/ui/clients_provider.dart';

/// List page for clients
class ClientListPage extends ConsumerWidget {
  const ClientListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clientsAsync = ref.watch(clientsProvider);

    return Scaffold(
      body: clientsAsync.when(
        data: (clients) => _ClientListView(clients: clients),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Error: $error'),
              ElevatedButton(
                onPressed: () => ref.invalidate(clientsProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/clients/new'),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _ClientListView extends StatelessWidget {
  const _ClientListView({required this.clients});

  final List<ClientEntity> clients;

  @override
  Widget build(BuildContext context) {
    if (clients.isEmpty) {
      return const Center(child: Text('No clients yet'));
    }

    return ListView.builder(
      itemCount: clients.length,
      itemBuilder: (context, index) {
        final client = clients[index];
        return ListTile(
          title: Text(client.name),
          subtitle: Text(client.contactInfo ?? ''),
          trailing: IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => context.go('/clients/${client.id}/edit'),
          ),
        );
      },
    );
  }
}