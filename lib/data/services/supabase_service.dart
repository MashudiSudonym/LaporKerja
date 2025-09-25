import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/constants/constants.dart';

import '../../domain/entities/client_entity.dart';
import '../../domain/entities/income_entity.dart';
import '../../domain/entities/project_entity.dart';
import '../../domain/entities/task_entity.dart';
import '../../domain/entities/time_entry_entity.dart';

class SupabaseService {
  final SupabaseClient _supabase;

  SupabaseService() : _supabase = Supabase.instance.client;

  // Constructor for testing
  SupabaseService.test(this._supabase);

  /// Generic upsert method for any table
  Future<void> upsert<T>(String table, Map<String, dynamic> data) async {
    try {
      await _supabase.from(table).upsert(data);
    } catch (e) {
      Constants.logger.e('Failed to upsert to $table: $e');
      throw Exception('Failed to sync to $table: $e');
    }
  }

  /// Sync projects to Supabase
  Future<void> syncProjects(List<ProjectEntity> projects) async {
    for (final project in projects) {
      try {
        await upsert('projects', project.toJson());
      } catch (e) {
        Constants.logger.e('Failed to sync project ${project.id}: $e');
      }
    }
  }

  /// Sync clients to Supabase
  Future<void> syncClients(List<ClientEntity> clients) async {
    for (final client in clients) {
      try {
        await upsert('clients', client.toJson());
      } catch (e) {
        Constants.logger.e('Failed to sync client ${client.id}: $e');
      }
    }
  }

  /// Sync tasks to Supabase
  Future<void> syncTasks(List<TaskEntity> tasks) async {
    for (final task in tasks) {
      try {
        await upsert('tasks', task.toJson());
      } catch (e) {
        Constants.logger.e('Failed to sync task ${task.id}: $e');
      }
    }
  }

  /// Sync time entries to Supabase
  Future<void> syncTimeEntries(List<TimeEntryEntity> timeEntries) async {
    for (final timeEntry in timeEntries) {
      try {
        await upsert('time_entries', timeEntry.toJson());
      } catch (e) {
        Constants.logger.e('Failed to sync time entry ${timeEntry.id}: $e');
      }
    }
  }

  /// Sync incomes to Supabase
  Future<void> syncIncomes(List<IncomeEntity> incomes) async {
    for (final income in incomes) {
      try {
        await upsert('incomes', income.toJson());
      } catch (e) {
        Constants.logger.e('Failed to sync income ${income.id}: $e');
      }
    }
  }
}