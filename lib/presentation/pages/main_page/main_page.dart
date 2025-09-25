import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/sync_provider.dart';
import '../clients/client_list_page.dart';
import '../incomes/income_list_page.dart';
import '../projects/project_list_page.dart';
import '../tasks/task_list_page.dart';
import '../time_entries/time_entry_list_page.dart';

/// Main page with modern monochrome BottomNavigationBar
class MainPage extends ConsumerStatefulWidget {
  const MainPage({super.key});

  @override
  ConsumerState<MainPage> createState() => _MainPageState();
}

class _MainPageState extends ConsumerState<MainPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const ProjectListPage(),
    const ClientListPage(),
    const TaskListPage(),
    const TimeEntryListPage(),
    const IncomeListPage(),
  ];

  final List<String> _titles = [
    'Projects',
    'Clients',
    'Tasks',
    'Time Entries',
    'Incomes',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        elevation: 0,
        actions: [
            IconButton(
              icon: const Icon(Icons.sync, color: Colors.black),
              onPressed: () async {
                final result = await ref.read(syncProvider.notifier).syncAll();
                if (mounted) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(result.isSuccess
                            ? 'Sync completed successfully'
                            : 'Sync failed: ${result.errorMessage}'),
                      ),
                    );
                  });
                }
              },
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.folder),
            label: 'Projects',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Clients',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.task),
            label: 'Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timer),
            label: 'Time',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money),
            label: 'Income',
          ),
        ],
      ),
    );
  }
}


