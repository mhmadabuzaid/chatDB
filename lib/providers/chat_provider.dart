import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final messagesProvider = StreamProvider<List<Map<String, dynamic>>>((ref) {
  return Supabase.instance.client
      .from('messages')
      .stream(primaryKey: ['id'])
      .order('created_at', ascending: true) // Oldest at top, Newest at bottom
      .map((event) => event);
});
