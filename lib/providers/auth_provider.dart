import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../data/auth_service.dart';

// 1. Provide the AuthService class
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

// 2. Provide the "User State" (Is the user logged in?)
// This Stream updates automatically whenever the user logs in or out.
final authStateProvider = StreamProvider<User?>((ref) {
  return Supabase.instance.client.auth.onAuthStateChange.map((event) {
    return event.session?.user;
  });
});
