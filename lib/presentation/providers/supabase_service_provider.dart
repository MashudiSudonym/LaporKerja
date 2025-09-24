import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/services/supabase_service.dart';

part 'supabase_service_provider.g.dart';

@Riverpod(keepAlive: true)
SupabaseService supabaseService(Ref ref) {
  return SupabaseService();
}