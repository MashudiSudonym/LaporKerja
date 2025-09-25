import 'package:flutter/material.dart';
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
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const MainPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
      routes: [
        GoRoute(
          path: 'new',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const ProjectFormPage(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1.0, 0.0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              );
            },
          ),
        ),
        GoRoute(
          path: ':id/edit',
          pageBuilder: (context, state) {
            final id = int.parse(state.pathParameters['id']!);
            return CustomTransitionPage(
              key: state.pageKey,
              child: ProjectFormPage(projectId: id),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(1.0, 0.0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                );
              },
            );
          },
        ),
      ],
    ),
    GoRoute(
      path: '/clients',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const ClientListPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
      routes: [
        GoRoute(
          path: 'new',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const ClientFormPage(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1.0, 0.0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              );
            },
          ),
        ),
        GoRoute(
          path: ':id/edit',
          pageBuilder: (context, state) {
            final id = int.parse(state.pathParameters['id']!);
            return CustomTransitionPage(
              key: state.pageKey,
              child: ClientFormPage(clientId: id),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(1.0, 0.0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                );
              },
            );
          },
        ),
      ],
    ),
    GoRoute(
      path: '/tasks',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const TaskListPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
      routes: [
        GoRoute(
          path: 'new',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const TaskFormPage(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1.0, 0.0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              );
            },
          ),
        ),
        GoRoute(
          path: ':id/edit',
          pageBuilder: (context, state) {
            final id = int.parse(state.pathParameters['id']!);
            return CustomTransitionPage(
              key: state.pageKey,
              child: TaskFormPage(taskId: id),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(1.0, 0.0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                );
              },
            );
          },
        ),
      ],
    ),
    GoRoute(
      path: '/time-entries',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const TimeEntryListPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
      routes: [
        GoRoute(
          path: 'new',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const TimeEntryFormPage(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1.0, 0.0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              );
            },
          ),
        ),
        GoRoute(
          path: ':id/edit',
          pageBuilder: (context, state) {
            final id = int.parse(state.pathParameters['id']!);
            return CustomTransitionPage(
              key: state.pageKey,
              child: TimeEntryFormPage(timeEntryId: id),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(1.0, 0.0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                );
              },
            );
          },
        ),
      ],
    ),
    GoRoute(
      path: '/incomes',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const IncomeListPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
      routes: [
        GoRoute(
          path: 'new',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const IncomeFormPage(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1.0, 0.0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              );
            },
          ),
        ),
        GoRoute(
          path: ':id/edit',
          pageBuilder: (context, state) {
            final id = int.parse(state.pathParameters['id']!);
            return CustomTransitionPage(
              key: state.pageKey,
              child: IncomeFormPage(incomeId: id),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(1.0, 0.0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                );
              },
            );
          },
        ),
      ],
    ),
  ],
);
