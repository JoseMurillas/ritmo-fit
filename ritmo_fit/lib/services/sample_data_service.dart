import 'package:ritmo_fit/models/user_model.dart';
import 'package:ritmo_fit/models/workout_model.dart';
import 'package:ritmo_fit/services/routine_generator_service.dart';
import 'package:uuid/uuid.dart';

class SampleDataService {
  static const _uuid = Uuid();

  static Profile createSampleProfile({
    String? name,
    int? age,
    String? gender,
    double? weight,
    double? height,
    double? muscleMassPercentage,
  }) {
    final profile = Profile(
      id: _uuid.v4(),
      name: name ?? 'Usuario Demo',
      age: age ?? 25,
      gender: gender ?? 'masculino',
      weight: weight ?? 75.0,
      height: height ?? 1.75,
      routines: [],
      muscleMassPercentage: muscleMassPercentage ?? 35.0,
    );

    // Generar rutinas automáticamente
    final routines = RoutineGeneratorService.generateRoutinesForProfile(profile);
    
    return Profile(
      id: profile.id,
      name: profile.name,
      age: profile.age,
      gender: profile.gender,
      weight: profile.weight,
      height: profile.height,
      routines: routines,
      muscleMassPercentage: profile.muscleMassPercentage,
      fitnessLevel: profile.fitnessLevel,
      currentRoutineId: routines.isNotEmpty ? routines.first.id : null,
    );
  }

  static User createSampleUser({
    String? name,
    String? email,
    String? password,
  }) {
    return User(
      id: _uuid.v4(),
      email: email ?? 'demo@ritmofit.com',
      name: name ?? 'Usuario Demo',
      password: password ?? 'demo123',
      profiles: [
        createSampleProfile(
          name: 'Perfil Principal',
          age: 25,
          gender: 'masculino',
          weight: 75.0,
          height: 1.75,
          muscleMassPercentage: 35.0,
        ),
        createSampleProfile(
          name: 'Perfil Avanzado',
          age: 30,
          gender: 'femenino',
          weight: 60.0,
          height: 1.65,
          muscleMassPercentage: 42.0,
        ),
      ],
    );
  }

  static List<WorkoutSession> createSampleSessions(String profileId, String routineId) {
    final sessions = <WorkoutSession>[];
    final now = DateTime.now();

    // Crear sesiones de los últimos 30 días
    for (int i = 0; i < 15; i++) {
      final date = now.subtract(Duration(days: i * 2));
      
      final session = WorkoutSession(
        id: _uuid.v4(),
        routineId: routineId,
        profileId: profileId,
        date: date,
        startTime: date.add(Duration(hours: 9 + (i % 3))),
        endTime: date.add(Duration(hours: 9 + (i % 3), minutes: 45 + (i % 15))),
        exerciseLogs: _createSampleExerciseLogs(),
        status: 'completed',
        notes: i % 4 == 0 ? 'Excelente entrenamiento, me sentí muy bien' : null,
        rating: (3 + (i % 3)).toDouble(),
      );

      sessions.add(session);
    }

    return sessions;
  }

  static List<ExerciseLog> _createSampleExerciseLogs() {
    return [
      ExerciseLog(
        exerciseId: _uuid.v4(),
        exerciseName: 'Press de banca',
        setLogs: [
          SetLog(setNumber: 1, reps: 12, weight: 60.0, completed: true),
          SetLog(setNumber: 2, reps: 10, weight: 65.0, completed: true),
          SetLog(setNumber: 3, reps: 8, weight: 70.0, completed: true),
        ],
        completed: true,
        completedAt: DateTime.now().subtract(const Duration(minutes: 45)),
      ),
      ExerciseLog(
        exerciseId: _uuid.v4(),
        exerciseName: 'Sentadillas',
        setLogs: [
          SetLog(setNumber: 1, reps: 15, weight: 80.0, completed: true),
          SetLog(setNumber: 2, reps: 12, weight: 85.0, completed: true),
          SetLog(setNumber: 3, reps: 10, weight: 90.0, completed: true),
        ],
        completed: true,
        completedAt: DateTime.now().subtract(const Duration(minutes: 30)),
      ),
      ExerciseLog(
        exerciseId: _uuid.v4(),
        exerciseName: 'Dominadas',
        setLogs: [
          SetLog(setNumber: 1, reps: 8, completed: true),
          SetLog(setNumber: 2, reps: 6, completed: true),
          SetLog(setNumber: 3, reps: 5, completed: true),
        ],
        completed: true,
        completedAt: DateTime.now().subtract(const Duration(minutes: 15)),
      ),
      ExerciseLog(
        exerciseId: _uuid.v4(),
        exerciseName: 'Press militar',
        setLogs: [
          SetLog(setNumber: 1, reps: 10, weight: 40.0, completed: true),
          SetLog(setNumber: 2, reps: 8, weight: 45.0, completed: true),
          SetLog(setNumber: 3, reps: 6, weight: 50.0, completed: true),
        ],
        completed: true,
        completedAt: DateTime.now().subtract(const Duration(minutes: 5)),
      ),
    ];
  }

  static Map<String, String> getExerciseImageUrls() {
    return {
      'Press de banca con mancuernas': 'https://via.placeholder.com/300x200/4f46e5/ffffff?text=Press+Mancuernas',
      'Flexiones de pecho': 'https://via.placeholder.com/300x200/059669/ffffff?text=Flexiones',
      'Remo con mancuernas': 'https://via.placeholder.com/300x200/dc2626/ffffff?text=Remo+Mancuernas',
      'Dominadas asistidas': 'https://via.placeholder.com/300x200/7c3aed/ffffff?text=Dominadas+Asistidas',
      'Sentadillas con peso corporal': 'https://via.placeholder.com/300x200/ea580c/ffffff?text=Sentadillas',
      'Zancadas': 'https://via.placeholder.com/300x200/0891b2/ffffff?text=Zancadas',
      'Press militar con mancuernas': 'https://via.placeholder.com/300x200/be185d/ffffff?text=Press+Militar',
      'Curl de bíceps': 'https://via.placeholder.com/300x200/0d9488/ffffff?text=Curl+Biceps',
      'Extensiones de tríceps': 'https://via.placeholder.com/300x200/7c2d12/ffffff?text=Triceps',
      'Press de banca con barra': 'https://via.placeholder.com/300x200/1d4ed8/ffffff?text=Press+Barra',
      'Aperturas con mancuernas': 'https://via.placeholder.com/300x200/7c3aed/ffffff?text=Aperturas',
      'Peso muerto': 'https://via.placeholder.com/300x200/dc2626/ffffff?text=Peso+Muerto',
      'Dominadas': 'https://via.placeholder.com/300x200/059669/ffffff?text=Dominadas',
      'Sentadillas con barra': 'https://via.placeholder.com/300x200/ea580c/ffffff?text=Sentadillas+Barra',
      'Peso muerto rumano': 'https://via.placeholder.com/300x200/be185d/ffffff?text=Peso+Muerto+Rumano',
      'Press militar de pie': 'https://via.placeholder.com/300x200/0891b2/ffffff?text=Press+Militar+Pie',
      'Elevaciones laterales': 'https://via.placeholder.com/300x200/7c2d12/ffffff?text=Elevaciones+Laterales',
      'Press de banca inclinado': 'https://via.placeholder.com/300x200/1d4ed8/ffffff?text=Press+Inclinado',
      'Fondos en paralelas': 'https://via.placeholder.com/300x200/0d9488/ffffff?text=Fondos+Paralelas',
      'Peso muerto sumo': 'https://via.placeholder.com/300x200/dc2626/ffffff?text=Peso+Muerto+Sumo',
      'Remo con barra': 'https://via.placeholder.com/300x200/7c3aed/ffffff?text=Remo+Barra',
      'Sentadillas frontales': 'https://via.placeholder.com/300x200/ea580c/ffffff?text=Sentadillas+Frontales',
      'Hip Thrust': 'https://via.placeholder.com/300x200/be185d/ffffff?text=Hip+Thrust',
    };
  }

  static void updateExerciseImageUrls(List<WorkoutRoutine> routines) {
    final imageUrls = getExerciseImageUrls();
    
    for (final routine in routines) {
      for (int i = 0; i < routine.exercises.length; i++) {
        final exercise = routine.exercises[i];
        final imageUrl = imageUrls[exercise.name];
        
        if (imageUrl != null) {
          routine.exercises[i] = WorkoutExercise(
            id: exercise.id,
            name: exercise.name,
            description: exercise.description,
            sets: exercise.sets,
            reps: exercise.reps,
            weight: exercise.weight,
            status: exercise.status,
            muscleGroup: exercise.muscleGroup,
            instructions: exercise.instructions,
            imageUrl: imageUrl,
            restTimeSeconds: exercise.restTimeSeconds,
            equipment: exercise.equipment,
          );
        }
      }
    }
  }
} 