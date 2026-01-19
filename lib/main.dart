import 'package:chat_db/screens/auth_gate.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://zsgzvdryknjhpjwpclmn.supabase.co',      // <-- Paste new URL
    anonKey: 'sb_publishable_ZcTlpqTFLvl2BejOBNmx9Q_MG1faXPU',     // <-- Paste new Key
  );

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
   // In main.dart
    return const MaterialApp(
      title: 'Chat App',
      home: AuthGate(), // <--- Change this line
    );
  }
}