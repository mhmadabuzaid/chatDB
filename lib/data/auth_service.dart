import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Get current user
  User? get currentUser => _supabase.auth.currentUser;

  // Sign Up
  Future<AuthResponse> signUp(
    String email,
    String password,
    String username,
  ) async {
    final response = await _supabase.auth.signUp(
      email: email,
      password: password,
      data: {'username': username}, // Stores username in metadata temporarily
    );

    // Note: You should also create a row in the 'public.profiles' table here
    // But for now, we will trust the database trigger or handle it simply.
    return response;
  }

  // Sign In
  Future<AuthResponse> signIn(String email, String password) async {
    return await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  // Sign Out
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }
}
