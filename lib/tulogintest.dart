import 'package:flutter/material.dart';
import 'auth.dart'; 

class TULoginPage extends StatefulWidget {
  const TULoginPage({Key? key}) : super(key: key);

  @override
  State<TULoginPage> createState() => _TULoginPageState();
}

class _TULoginPageState extends State<TULoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  void _login() async {
    if (!_formKey.currentState!.validate()) return;

    final username = _idController.text.trim();
    final password = _passwordController.text;

    setState(() => _isLoading = true);

    try {
      await TQauth.loginWithID(username, password);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login successful')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('TU Login')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _idController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Student ID',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter your Student ID'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter your password'
                    : null,
              ),
              const SizedBox(height: 24),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _login,
                      child: const Text('Login with tu test'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
