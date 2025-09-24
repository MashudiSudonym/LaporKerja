import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../pages/clients/client_form_page.dart';
import '../../pages/clients/client_list_page.dart';
import '../../pages/incomes/income_form_page.dart';
import '../../pages/incomes/income_list_page.dart';
import '../../pages/main_page/main_page.dart';
import '../../pages/projects/project_form_page.dart';
import '../../pages/tasks/task_form_page.dart';
import '../../pages/tasks/task_list_page.dart';
import '../../pages/time_entries/time_entry_form_page.dart';
import '../../pages/time_entries/time_entry_list_page.dart';

part 'router_provider.g.dart';

/// GoRouter configuration with all routes
@Riverpod(keepAlive: true)
Raw<GoRouter> router(Ref ref) => GoRouter(
  initialLocation: '/projects',
  routes: [
    GoRoute(
      path: '/',
      redirect: (_, __) => '/projects',
    ),
    GoRoute(
      path: '/projects',
      builder: (context, state) => const MainPage(),
      routes: [
        GoRoute(
          path: 'new',
          builder: (context, state) => const ProjectFormPage(),
        ),
        GoRoute(
          path: ':id/edit',
          builder: (context, state) {
            final id = int.parse(state.pathParameters['id']!);
            return ProjectFormPage(projectId: id);
          },
        ),
      ],
    ),
    GoRoute(
      path: '/clients',
      builder: (context, state) => const ClientListPage(),
      routes: [
        GoRoute(
          path: 'new',
          builder: (context, state) => const ClientFormPage(),
        ),
        GoRoute(
          path: ':id/edit',
          builder: (context, state) {
            final id = int.parse(state.pathParameters['id']!);
            return ClientFormPage(clientId: id);
          },
        ),
      ],
    ),
    GoRoute(
      path: '/tasks',
      builder: (context, state) => const TaskListPage(),
      routes: [
        GoRoute(
          path: 'new',
          builder: (context, state) => const TaskFormPage(),
        ),
        GoRoute(
          path: ':id/edit',
          builder: (context, state) {
            final id = int.parse(state.pathParameters['id']!);
            return TaskFormPage(taskId: id);
          },
        ),
      ],
    ),
    GoRoute(
      path: '/time-entries',
      builder: (context, state) => const TimeEntryListPage(),
      routes: [
        GoRoute(
          path: 'new',
          builder: (context, state) => const TimeEntryFormPage(),
        ),
        GoRoute(
          path: ':id/edit',
          builder: (context, state) {
            final id = int.parse(state.pathParameters['id']!);
            return TimeEntryFormPage(timeEntryId: id);
          },
        ),
      ],
    ),
    GoRoute(
      path: '/incomes',
      builder: (context, state) => const IncomeListPage(),
      routes: [
        GoRoute(
          path: 'new',
          builder: (context, state) => const IncomeFormPage(),
        ),
        GoRoute(
          path: ':id/edit',
          builder: (context, state) {
            final id = int.parse(state.pathParameters['id']!);
            return IncomeFormPage(incomeId: id);
          },
        ),
      ],
    ),
  ],
);
