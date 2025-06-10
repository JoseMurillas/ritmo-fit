import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:ritmo_fit/models/user_model.dart';
import 'package:ritmo_fit/models/workout_model.dart';
import 'package:ritmo_fit/providers/auth_provider.dart';
import 'package:ritmo_fit/providers/profile_provider.dart';
import 'package:ritmo_fit/providers/workout_provider.dart';
import 'package:ritmo_fit/screens/auth/login_screen.dart';
import 'package:ritmo_fit/screens/auth/register_screen.dart';
import 'package:ritmo_fit/screens/home/dashboard_screen.dart';
import 'package:ritmo_fit/screens/splash_screen.dart';
import 'package:ritmo_fit/services/auth_service.dart';
import 'package:ritmo_fit/services/database_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  
  // Registrar adaptadores
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(ProfileAdapter());
  Hive.registerAdapter(WorkoutRoutineAdapter());
  Hive.registerAdapter(WorkoutExerciseAdapter());
  
  // Abrir cajas
  await Hive.openBox<User>('users');
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider(AuthService())),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => WorkoutProvider()),
      ],
      child: MaterialApp(
        title: 'Ritmo Fit',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: const SplashScreen(),
        routes: {
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/dashboard': (context) => const DashboardScreen(),
        },
      ),
    );
  }
}
