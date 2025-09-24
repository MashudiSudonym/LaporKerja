import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:logger/logger.dart';

import '../../domain/repositories/client_repository.dart';
import '../../domain/repositories/income_repository.dart';
import '../../domain/repositories/project_repository.dart';
import '../../domain/repositories/task_repository.dart';
import '../../domain/repositories/time_entry_repository.dart';

class SupabaseService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<bool> _isOnline() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  Future<void> syncProjects(ProjectRepository projectRepository) async {
    if (!await _isOnline()) return;

    final unsyncedProjects = await projectRepository.getUnsyncedProjects();
    for (final project in unsyncedProjects.resultValue ?? []) {
      try {
        await _supabase.from('projects').upsert({
          'id': project.id,
          'project_name': project.projectName,
          'description': project.description,
          'client_id': project.clientId,
          'start_date': project.startDate?.toIso8601String(),
          'deadline': project.deadline?.toIso8601String(),
          'status': project.status,
          'created_at': project.createdAt.toIso8601String(),
          'updated_at': project.updatedAt.toIso8601String(),
          'is_deleted': project.isDeleted,
        }).execute();
        await projectRepository.markProjectAsSynced(project.id);
      } catch (e) {
        // Handle error, maybe log or queue
        Logger().e('Failed to sync project ${project.id}: $e');
      }
    }
  }

  Future<void> syncClients(ClientRepository clientRepository) async {
    if (!await _isOnline()) return;

    final unsyncedClients = await clientRepository.getUnsyncedClients();
    for (final client in unsyncedClients.resultValue ?? []) {
      try {
        await _supabase.from('clients').upsert({
          'id': client.id,
          'name': client.name,
          'email': client.email,
          'phone': client.phone,
          'address': client.address,
          'created_at': client.createdAt.toIso8601String(),
          'updated_at': client.updatedAt.toIso8601String(),
          'is_deleted': client.isDeleted,
        }).execute();
        await clientRepository.markClientAsSynced(client.id);
      } catch (e) {
        Logger().e('Failed to sync client ${client.id}: $e');
      }
    }
  }

  Future<void> syncTasks(TaskRepository taskRepository) async {
    if (!await _isOnline()) return;

    final unsyncedTasks = await taskRepository.getUnsyncedTasks();
    for (final task in unsyncedTasks.resultValue ?? []) {
      try {
        await _supabase.from('tasks').upsert({
          'id': task.id,
          'project_id': task.projectId,
          'title': task.title,
          'description': task.description,
          'status': task.status,
          'priority': task.priority,
          'due_date': task.dueDate?.toIso8601String(),
          'created_at': task.createdAt.toIso8601String(),
          'updated_at': task.updatedAt.toIso8601String(),
          'is_deleted': task.isDeleted,
        }).execute();
        await taskRepository.markTaskAsSynced(task.id);
      } catch (e) {
        Logger().e('Failed to sync task ${task.id}: $e');
      }
    }
  }

  Future<void> syncTimeEntries(TimeEntryRepository timeEntryRepository) async {
    if (!await _isOnline()) return;

    final unsyncedTimeEntries = await timeEntryRepository.getUnsyncedTimeEntries();
    for (final timeEntry in unsyncedTimeEntries.resultValue ?? []) {
      try {
        await _supabase.from('time_entries').upsert({
          'id': timeEntry.id,
          'task_id': timeEntry.taskId,
          'start_time': timeEntry.startTime.toIso8601String(),
          'end_time': timeEntry.endTime?.toIso8601String(),
          'duration': timeEntry.duration,
          'description': timeEntry.description,
          'created_at': timeEntry.createdAt.toIso8601String(),
          'updated_at': timeEntry.updatedAt.toIso8601String(),
          'is_deleted': timeEntry.isDeleted,
        }).execute();
        await timeEntryRepository.markTimeEntryAsSynced(timeEntry.id);
      } catch (e) {
        Logger().e('Failed to sync time entry ${timeEntry.id}: $e');
      }
    }
  }

  Future<void> syncIncomes(IncomeRepository incomeRepository) async {
    if (!await _isOnline()) return;

    final unsyncedIncomes = await incomeRepository.getUnsyncedIncomes();
    for (final income in unsyncedIncomes.resultValue ?? []) {
      try {
        await _supabase.from('incomes').upsert({
          'id': income.id,
          'amount': income.amount,
          'description': income.description,
          'date': income.date.toIso8601String(),
          'category': income.category,
          'created_at': income.createdAt.toIso8601String(),
          'updated_at': income.updatedAt.toIso8601String(),
          'is_deleted': income.isDeleted,
        }).execute();
        await incomeRepository.markIncomeAsSynced(income.id);
      } catch (e) {
        Logger().e('Failed to sync income ${income.id}: $e');
      }
    }
  }
}