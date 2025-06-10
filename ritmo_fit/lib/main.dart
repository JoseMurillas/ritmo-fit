import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:ritmo_fit/models/user_model.dart';
import 'package:ritmo_fit/models/workout_model.dart';
import 'package:ritmo_fit/models/forum_model.dart';
import 'package:ritmo_fit/providers/auth_provider.dart';
import 'package:ritmo_fit/providers/profile_provider.dart';
import 'package:ritmo_fit/providers/workout_provider.dart';
import 'package:ritmo_fit/providers/forum_provider.dart';
import 'package:ritmo_fit/providers/theme_provider.dart';
import 'package:ritmo_fit/services/database_service.dart';
import 'package:ritmo_fit/screens/auth/login_screen.dart';
import 'package:ritmo_fit/screens/auth/register_screen.dart';
import 'package:ritmo_fit/screens/home/home_screen.dart';
import 'package:ritmo_fit/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  
  // Registrar adaptadores
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(ProfileAdapter());
  Hive.registerAdapter(WorkoutRoutineAdapter());
  Hive.registerAdapter(WorkoutExerciseAdapter());
  Hive.registerAdapter(ForumMessageAdapter());
  Hive.registerAdapter(ForumReplyAdapter());
  
  // Abrir cajas
  await Hive.openBox<User>('users');
  await Hive.openBox<ForumMessage>('forum');
  await Hive.openBox('settings');
  
  // Inicializar servicios
  final databaseService = DatabaseService();
  await databaseService.init();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => WorkoutProvider()),
        ChangeNotifierProvider(create: (_) => ForumProvider(DatabaseService())),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Ritmo Fit',
            debugShowCheckedModeBanner: false,
            theme: themeProvider.themeData,
            darkTheme: ThemeData.dark(useMaterial3: true),
            themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            home: const SplashScreen(),
            routes: {
              '/login': (context) => const LoginScreen(),
              '/register': (context) => const RegisterScreen(),
              '/home': (context) => const HomeScreen(),
            },
          );
        },
      ),
    );
  }
}
