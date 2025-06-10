import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ritmo_fit/providers/auth_provider.dart';
import 'package:ritmo_fit/screens/auth/login_screen.dart';
import 'package:ritmo_fit/screens/home/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    try {
      await Future.delayed(const Duration(seconds: 2)); // Simular carga
      if (!mounted) return;

      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.checkAuthStatus();

      if (!mounted) return;

      if (authProvider.error != null) {
        setState(() {
          _isError = true;
          _errorMessage = authProvider.error!;
        });
        return;
      }

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => authProvider.isAuthenticated
              ? const HomeScreen()
              : const LoginScreen(),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isError = true;
        _errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo o imagen de la app
            const Icon(
              Icons.fitness_center,
              size: 100,
              color: Colors.blue,
            ),
            const SizedBox(height: 24),
            // Nombre de la app
            const Text(
              'RitmoFit',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 24),
            if (_isError) ...[
              Text(
                'Error: $_errorMessage',
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isError = false;
                    _errorMessage = '';
                  });
                  _checkAuthStatus();
                },
                child: const Text('Reintentar'),
              ),
            ] else
              const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
} 