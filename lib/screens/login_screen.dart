import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController(); // Only for Sign Up
  bool _isLogin = true; // Toggle between Login and Sign Up
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final authService = ref.read(authServiceProvider);

    return Scaffold(
      appBar: AppBar(title: Text(_isLogin ? 'Login' : 'Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Username Field (Only show if Signing Up)
            if (!_isLogin)
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
              ),
            const SizedBox(height: 12),

            // Email Field
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 12),

            // Password Field
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 24),

            // Action Button
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () async {
                      setState(() => _isLoading = true);
                      try {
                        if (_isLogin) {
                          await authService.signIn(
                            _emailController.text,
                            _passwordController.text,
                          );
                        } else {
                          await authService.signUp(
                            _emailController.text.trim(),
                            _passwordController.text.trim(),
                            _usernameController.text.trim(),
                          );
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Account Created!')),
                            );
                          }
                        }
                      } catch (e) {
                        if (mounted) {
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text('Error: $e')));
                        }
                      } finally {
                        if (mounted) setState(() => _isLoading = false);
                      }
                    },
                    child: Text(_isLogin ? 'Login' : 'Sign Up'),
                  ),

            // Toggle Button
            TextButton(
              onPressed: () {
                setState(() {
                  _isLogin = !_isLogin;
                });
              },
              child: Text(
                _isLogin
                    ? 'Don\'t have an account? Sign Up'
                    : 'Already have an account? Login',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
