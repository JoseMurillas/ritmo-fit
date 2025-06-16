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
  try {
    WidgetsFlutterBinding.ensureInitialized();
    print('✅ Flutter inicializado');
    
    await Hive.initFlutter();
    print('✅ Hive inicializado');
    
    // Limpiar adaptadores existentes en modo debug para evitar conflictos
    if (Hive.isAdapterRegistered(0) || 
        Hive.isAdapterRegistered(1) || 
        Hive.isAdapterRegistered(2) ||
        Hive.isAdapterRegistered(3) ||
        Hive.isAdapterRegistered(4) ||
        Hive.isAdapterRegistered(5) ||
        Hive.isAdapterRegistered(6) ||
        Hive.isAdapterRegistered(7) ||
        Hive.isAdapterRegistered(8) ||
        Hive.isAdapterRegistered(9) ||
        Hive.isAdapterRegistered(10)) {
      print('🔄 Adaptadores ya registrados, saltando registro...');
    } else {
      // Registrar adaptadores solo si no están registrados
      print('📝 Registrando adaptadores de Hive...');
      
      // User models (0-1)
      Hive.registerAdapter(UserAdapter());
      Hive.registerAdapter(ProfileAdapter());
      print('✅ User adapters registrados');
      
      // Workout models (2-6)
      Hive.registerAdapter(WorkoutRoutineAdapter());
      Hive.registerAdapter(WorkoutExerciseAdapter());
      Hive.registerAdapter(WorkoutSessionAdapter());
      Hive.registerAdapter(ExerciseLogAdapter());
      Hive.registerAdapter(SetLogAdapter());
      print('✅ Workout adapters registrados');
      
      // Forum models (7-10)
      Hive.registerAdapter(ForumMessageAdapter());
      Hive.registerAdapter(ForumReplyAdapter());
      Hive.registerAdapter(ForumPostAdapter());
      Hive.registerAdapter(CommentAdapter());
      print('✅ Forum adapters registrados');
    }
    
    // Abrir cajas con manejo de errores mejorado
    await _openHiveBoxes();
    
    // Inicializar servicios
    final databaseService = DatabaseService();
    await databaseService.init();
    print('✅ DatabaseService inicializado');
    
    print('🚀 Iniciando aplicación...');
    runApp(const MyApp());
    
  } catch (e, stackTrace) {
    print('❌ Error crítico en main: $e');
    print('Stack trace: $stackTrace');
    
    // Mostrar pantalla de error
    runApp(_buildErrorApp(e.toString()));
  }
}

Future<void> _openHiveBoxes() async {
  final boxNames = ['users', 'forum', 'settings'];
  
  for (String boxName in boxNames) {
    try {
      switch (boxName) {
        case 'users':
          await Hive.openBox<User>(boxName);
          break;
        case 'forum':
          await Hive.openBox<ForumMessage>(boxName);
          break;
        case 'settings':
          await Hive.openBox(boxName);
          break;
      }
      print('✅ Caja $boxName abierta');
    } catch (e) {
      print('❌ Error abriendo caja $boxName: $e');
      print('🔄 Intentando recrear caja...');
      
      try {
        await Hive.deleteBoxFromDisk(boxName);
        
        switch (boxName) {
          case 'users':
            await Hive.openBox<User>(boxName);
            break;
          case 'forum':
            await Hive.openBox<ForumMessage>(boxName);
            break;
          case 'settings':
            await Hive.openBox(boxName);
            break;
        }
        print('✅ Caja $boxName recreada exitosamente');
      } catch (recreateError) {
        print('❌ Error recreando caja $boxName: $recreateError');
        throw Exception('No se pudo inicializar la caja $boxName');
      }
    }
  }
}

Widget _buildErrorApp(String error) {
  return MaterialApp(
    title: 'RitmoFit - Error',
    home: Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.red, Colors.redAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 80,
                  color: Colors.white,
                ),
                const SizedBox(height: 24),
                const Text(
                  'Error de Inicialización',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    error,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  onPressed: () async {
                    try {
                      // Limpiar completamente Hive
                      await Hive.deleteBoxFromDisk('users');
                      await Hive.deleteBoxFromDisk('forum');
                      await Hive.deleteBoxFromDisk('settings');
                      print('✅ Todas las cajas eliminadas');
                      
                      // Reiniciar aplicación
                      main();
                    } catch (e) {
                      print('❌ Error al limpiar: $e');
                    }
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Limpiar datos y reiniciar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
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
