import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ritmo_fit/models/user_model.dart';
import 'package:ritmo_fit/models/workout_model.dart';
import 'package:ritmo_fit/services/database_service.dart';
import 'package:ritmo_fit/services/workout_service.dart';
import 'package:ritmo_fit/services/routine_generator_service.dart';
import 'package:uuid/uuid.dart';

class WorkoutProvider extends ChangeNotifier {
  static const _uuid = Uuid();
  
  // Boxes de Hive
  Box<WorkoutSession>? _sessionsBox;
  Box<Profile>? _profilesBox;
  
  // Estado actual
  Profile? _currentProfile;
  WorkoutRoutine? _currentRoutine;
  WorkoutSession? _activeSession;
  List<WorkoutSession> _recentSessions = [];
  bool _isLoading = false;
  bool _isInitialized = false;
  String? _error;

  List<WorkoutRoutine> _routines = [];
  WorkoutRoutine? _selectedRoutine;

  // Getters
  List<WorkoutRoutine> get routines => _routines;
  WorkoutRoutine? get selectedRoutine => _selectedRoutine;
  WorkoutRoutine? get currentRoutine => _currentRoutine;
  WorkoutSession? get activeSession => _activeSession;
  List<WorkoutSession> get recentSessions => _recentSessions;
  bool get isLoading => _isLoading;
  bool get hasActiveSession => _activeSession != null;
  bool get isInitialized => _isInitialized;
  String? get error => _error;
  Profile? get currentProfile => _currentProfile;

  void setRoutines(List<WorkoutRoutine> routines) {
    _routines.clear();
    _routines.addAll(routines);
    notifyListeners();
  }

  Future<void> initialize() async {
    if (_isInitialized) return;
    
    _isLoading = true;
    notifyListeners();
    
    try {
      // Abrir boxes de Hive
      _sessionsBox = await Hive.openBox<WorkoutSession>('workout_sessions');
      _profilesBox = await Hive.openBox<Profile>('profiles');
      
      _isInitialized = true;
      print('✅ WorkoutProvider inicializado correctamente');
      
      // Cargar sesiones recientes si hay un perfil
      _loadRecentSessions();
      
      // Verificar si hay sesión activa pendiente
      await _checkForActiveSession();
    } catch (e) {
      _error = e.toString();
      print('❌ Error inicializando WorkoutProvider: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _checkForActiveSession() async {
    if (_sessionsBox == null) return;
    
    try {
      // Buscar sesión en progreso
      final inProgressSessions = _sessionsBox!.values.where(
        (session) => session.status == 'in_progress'
      ).toList();
      
      if (inProgressSessions.isNotEmpty) {
        _activeSession = inProgressSessions.first;
        print('✅ Sesión activa recuperada: ${_activeSession!.id}');
        notifyListeners();
      }
    } catch (e) {
      print('❌ Error recuperando sesión activa: $e');
    }
  }

  void forceRefresh() {
    print('🔄 Forzando actualización del estado');
    _loadRecentSessions();
    notifyListeners();
  }

  Future<void> setCurrentProfile(Profile profile) async {
    if (!_isInitialized) {
      await initialize();
    }

    _currentProfile = profile;
    
    // Generar rutinas automáticamente si no tiene
    if (profile.routines.isEmpty) {
      await _generateRoutinesForProfile(profile);
    }
    
    // Establecer rutina actual si hay una asignada
    if (profile.currentRoutineId != null) {
      _currentRoutine = profile.routines.firstWhere(
        (r) => r.id == profile.currentRoutineId,
        orElse: () => profile.routines.first,
      );
    } else if (profile.routines.isNotEmpty) {
      _currentRoutine = profile.routines.first;
    }
    
    _routines = List.from(profile.routines);
    
    _loadRecentSessions();
    print('✅ Perfil establecido: ${profile.name}, Sesiones cargadas: ${_recentSessions.length}');
    notifyListeners();
  }

  Future<void> _generateRoutinesForProfile(Profile profile) async {
    try {
      final generatedRoutines = RoutineGeneratorService.generateRoutinesForProfile(profile);
      
      // Crear nuevo perfil con rutinas
      final updatedProfile = Profile(
        id: profile.id,
        name: profile.name,
        age: profile.age,
        gender: profile.gender,
        weight: profile.weight,
        height: profile.height,
        routines: generatedRoutines,
        weeklyPlan: profile.weeklyPlan,
        muscleMassPercentage: profile.muscleMassPercentage,
        fitnessLevel: profile.fitnessLevel,
        currentRoutineId: generatedRoutines.first.id,
      );
      
      // Guardar en Hive si está disponible
      if (_profilesBox != null) {
        await _profilesBox!.put(profile.id, updatedProfile);
      }
      
      _currentProfile = updatedProfile;
      _currentRoutine = generatedRoutines.first;
      _routines = List.from(generatedRoutines);
      print('✅ Rutinas generadas para ${profile.name}: ${generatedRoutines.length}');
    } catch (e) {
      print('❌ Error generando rutinas: $e');
    }
  }

  void setCurrentRoutine(WorkoutRoutine routine) {
    _currentRoutine = routine;
    
    if (_currentProfile != null && _profilesBox != null) {
      final updatedProfile = Profile(
        id: _currentProfile!.id,
        name: _currentProfile!.name,
        age: _currentProfile!.age,
        gender: _currentProfile!.gender,
        weight: _currentProfile!.weight,
        height: _currentProfile!.height,
        routines: _currentProfile!.routines,
        weeklyPlan: _currentProfile!.weeklyPlan,
        muscleMassPercentage: _currentProfile!.muscleMassPercentage,
        fitnessLevel: _currentProfile!.fitnessLevel,
        currentRoutineId: routine.id,
      );
      
      _profilesBox!.put(_currentProfile!.id, updatedProfile);
      _currentProfile = updatedProfile;
    }
    
    notifyListeners();
  }

  Future<WorkoutSession> startWorkoutSession() async {
    if (_currentProfile == null || _currentRoutine == null) {
      throw Exception('No hay perfil o rutina seleccionada');
    }

    if (!_isInitialized) {
      await initialize();
    }

    // Crear logs de ejercicios basados en la rutina
    final exerciseLogs = _currentRoutine!.exercises.map((exercise) {
      return ExerciseLog(
        exerciseId: exercise.id,
        exerciseName: exercise.name,
        setLogs: List.generate(exercise.sets, (index) => SetLog(
          setNumber: index + 1,
          reps: exercise.reps,
          weight: exercise.weight,
        )),
      );
    }).toList();

    _activeSession = WorkoutSession(
      id: _uuid.v4(),
      routineId: _currentRoutine!.id,
      profileId: _currentProfile!.id,
      date: DateTime.now(),
      startTime: DateTime.now(),
      exerciseLogs: exerciseLogs,
      status: 'in_progress',
    );

    if (_sessionsBox != null) {
      await _sessionsBox!.put(_activeSession!.id, _activeSession!);
    }
    
    print('✅ Sesión iniciada: ${_activeSession!.id}');
    notifyListeners();
    return _activeSession!;
  }

  Future<void> completeExercise(String exerciseId, {String? notes}) async {
    if (_activeSession == null) return;

    print('🎯 Completando ejercicio $exerciseId');

    final updatedLogs = _activeSession!.exerciseLogs.map((log) {
      if (log.exerciseId == exerciseId) {
        return ExerciseLog(
          exerciseId: log.exerciseId,
          exerciseName: log.exerciseName,
          setLogs: log.setLogs,
          completed: true,
          notes: notes,
          completedAt: DateTime.now(),
        );
      }
      return log;
    }).toList();

    // Crear nueva instancia de WorkoutSession
    _activeSession = WorkoutSession(
      id: _activeSession!.id,
      routineId: _activeSession!.routineId,
      profileId: _activeSession!.profileId,
      date: _activeSession!.date,
      startTime: _activeSession!.startTime,
      endTime: _activeSession!.endTime,
      exerciseLogs: updatedLogs,
      status: _activeSession!.status,
      notes: _activeSession!.notes,
      rating: _activeSession!.rating,
    );

    // Guardar inmediatamente en Hive
    if (_sessionsBox != null) {
      try {
        await _sessionsBox!.put(_activeSession!.id, _activeSession!);
        print('✅ Ejercicio completado y guardado en Hive');
      } catch (e) {
        print('❌ Error guardando en Hive: $e');
      }
    }

    // Notificar cambios inmediatamente
    notifyListeners();
    print('✅ Ejercicio completado, estado actualizado y notificado');
  }

  Future<void> completeSet(String exerciseId, int setNumber, int reps, double? weight) async {
    if (_activeSession == null) return;

    print('🔄 Completando serie $setNumber del ejercicio $exerciseId');

    final updatedLogs = _activeSession!.exerciseLogs.map((log) {
      if (log.exerciseId == exerciseId) {
        final updatedSets = log.setLogs.map((set) {
          if (set.setNumber == setNumber) {
            return SetLog(
              setNumber: set.setNumber,
              reps: reps,
              weight: weight,
              restTimeSeconds: set.restTimeSeconds,
              completed: true,
            );
          }
          return set;
        }).toList();

        return ExerciseLog(
          exerciseId: log.exerciseId,
          exerciseName: log.exerciseName,
          setLogs: updatedSets,
          completed: log.completed,
          notes: log.notes,
          completedAt: log.completedAt,
        );
      }
      return log;
    }).toList();

    // Crear nueva instancia de WorkoutSession
    _activeSession = WorkoutSession(
      id: _activeSession!.id,
      routineId: _activeSession!.routineId,
      profileId: _activeSession!.profileId,
      date: _activeSession!.date,
      startTime: _activeSession!.startTime,
      endTime: _activeSession!.endTime,
      exerciseLogs: updatedLogs,
      status: _activeSession!.status,
      notes: _activeSession!.notes,
      rating: _activeSession!.rating,
    );

    // Guardar inmediatamente en Hive
    if (_sessionsBox != null) {
      try {
        await _sessionsBox!.put(_activeSession!.id, _activeSession!);
        print('✅ Serie completada y guardada en Hive');
      } catch (e) {
        print('❌ Error guardando en Hive: $e');
      }
    }

    // Notificar cambios inmediatamente
    notifyListeners();
    print('✅ Estado actualizado y notificado');
  }

  Future<void> finishWorkoutSession({String? notes, double? rating}) async {
    if (_activeSession == null) return;

    _activeSession = WorkoutSession(
      id: _activeSession!.id,
      routineId: _activeSession!.routineId,
      profileId: _activeSession!.profileId,
      date: _activeSession!.date,
      startTime: _activeSession!.startTime,
      endTime: DateTime.now(),
      exerciseLogs: _activeSession!.exerciseLogs,
      status: 'completed',
      notes: notes,
      rating: rating,
    );

    if (_sessionsBox != null) {
      await _sessionsBox!.put(_activeSession!.id, _activeSession!);
    }
    
    print('✅ Sesión completada: ${_activeSession!.id}, Duración: ${_activeSession!.durationMinutes} min');
    
    _activeSession = null;
    _loadRecentSessions();
    notifyListeners();
  }

  Future<void> cancelWorkoutSession() async {
    if (_activeSession == null) return;

    if (_sessionsBox != null) {
      await _sessionsBox!.delete(_activeSession!.id);
    }
    _activeSession = null;
    notifyListeners();
  }

  void _loadRecentSessions() {
    if (_currentProfile == null || _sessionsBox == null) return;

    final allSessions = _sessionsBox!.values.where(
      (session) => session.profileId == _currentProfile!.id,
    ).toList();

    allSessions.sort((a, b) => b.date.compareTo(a.date));
    _recentSessions = allSessions.take(30).toList();
    
    print('✅ Sesiones cargadas: ${_recentSessions.length}');
  }

  Map<String, dynamic> getWeeklyStats() {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weekEnd = weekStart.add(const Duration(days: 6));

    final weekSessions = _recentSessions.where((session) {
      return session.date.isAfter(weekStart.subtract(const Duration(days: 1))) && 
             session.date.isBefore(weekEnd.add(const Duration(days: 1))) &&
             session.status == 'completed';
    }).toList();

    final totalMinutes = weekSessions.fold<int>(0, (sum, session) {
      return sum + (session.durationMinutes ?? 0);
    });

    final completionPercentage = weekSessions.isNotEmpty
        ? weekSessions.fold<double>(0, (sum, session) => sum + session.completionPercentage) / weekSessions.length
        : 0.0;

    final daysActive = weekSessions.map((s) => s.date.day).toSet().length;

    return {
      'sessionsCompleted': weekSessions.length,
      'totalMinutes': totalMinutes,
      'averageCompletion': completionPercentage,
      'daysActive': daysActive,
      'targetDays': 3, // Meta semanal
    };
  }

  Map<String, dynamic> getMonthlyStats() {
    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month, 1);
    final monthEnd = DateTime(now.year, now.month + 1, 0);

    final monthSessions = _recentSessions.where((session) {
      return session.date.isAfter(monthStart.subtract(const Duration(days: 1))) && 
             session.date.isBefore(monthEnd.add(const Duration(days: 1))) &&
             session.status == 'completed';
    }).toList();

    final totalMinutes = monthSessions.fold<int>(0, (sum, session) {
      return sum + (session.durationMinutes ?? 0);
    });

    final averageRating = monthSessions.where((s) => s.rating != null).isNotEmpty
        ? monthSessions.where((s) => s.rating != null).fold<double>(0, (sum, session) => sum + session.rating!) / 
          monthSessions.where((s) => s.rating != null).length
        : 0.0;

    final daysActive = monthSessions.map((s) => s.date.day).toSet().length;

    return {
      'sessionsCompleted': monthSessions.length,
      'totalMinutes': totalMinutes,
      'averageRating': averageRating,
      'daysActive': daysActive,
      'totalDaysInMonth': monthEnd.day,
      'targetSessions': 12, // Meta mensual
    };
  }

  List<WorkoutSession> getSessionsByDate(DateTime date) {
    return _recentSessions.where((session) {
      return session.date.year == date.year &&
             session.date.month == date.month &&
             session.date.day == date.day;
    }).toList();
  }

  List<Map<String, dynamic>> getExerciseHistory(String exerciseName) {
    final exerciseHistory = <Map<String, dynamic>>[];
    
    for (final session in _recentSessions) {
      if (session.status != 'completed') continue;
      
      final exerciseLog = session.exerciseLogs.firstWhere(
        (log) => log.exerciseName == exerciseName,
        orElse: () => ExerciseLog(exerciseId: '', exerciseName: '', setLogs: []),
      );
      
      if (exerciseLog.exerciseId.isNotEmpty && exerciseLog.completed) {
        final maxWeight = exerciseLog.setLogs
            .where((set) => set.weight != null)
            .fold<double>(0, (max, set) => set.weight! > max ? set.weight! : max);
        
        final totalReps = exerciseLog.setLogs
            .fold<int>(0, (sum, set) => sum + set.reps);
            
        exerciseHistory.add({
          'date': session.date,
          'maxWeight': maxWeight,
          'totalReps': totalReps,
          'sets': exerciseLog.setLogs.length,
        });
      }
    }
    
    exerciseHistory.sort((a, b) => (a['date'] as DateTime).compareTo(b['date'] as DateTime));
    return exerciseHistory;
  }

  // Método para agregar datos de prueba
  Future<void> addSampleData() async {
    if (_currentProfile == null || _sessionsBox == null) return;

    final sampleSessions = <WorkoutSession>[];
    final now = DateTime.now();

    // Crear sesiones de ejemplo de la última semana
    for (int i = 0; i < 7; i++) {
      final sessionDate = now.subtract(Duration(days: i));
      
      if (i % 2 == 0) { // Sesiones cada dos días
        final session = WorkoutSession(
          id: _uuid.v4(),
          routineId: _currentRoutine?.id ?? 'sample',
          profileId: _currentProfile!.id,
          date: sessionDate,
          startTime: sessionDate,
          endTime: sessionDate.add(Duration(minutes: 30 + (i * 5))),
          exerciseLogs: [
            ExerciseLog(
              exerciseId: 'ex1',
              exerciseName: 'Sentadillas',
              setLogs: [
                SetLog(setNumber: 1, reps: 12, weight: 20.0, completed: true),
                SetLog(setNumber: 2, reps: 10, weight: 20.0, completed: true),
                SetLog(setNumber: 3, reps: 8, weight: 22.5, completed: true),
              ],
              completed: true,
              completedAt: sessionDate,
            ),
            ExerciseLog(
              exerciseId: 'ex2',
              exerciseName: 'Press de banca',
              setLogs: [
                SetLog(setNumber: 1, reps: 10, weight: 40.0, completed: true),
                SetLog(setNumber: 2, reps: 8, weight: 42.5, completed: true),
                SetLog(setNumber: 3, reps: 6, weight: 45.0, completed: true),
              ],
              completed: true,
              completedAt: sessionDate,
            ),
          ],
          status: 'completed',
          rating: 4.0 + (i * 0.2),
        );
        
        sampleSessions.add(session);
        await _sessionsBox!.put(session.id, session);
      }
    }

    _loadRecentSessions();
    print('✅ Datos de ejemplo agregados: ${sampleSessions.length} sesiones');
    notifyListeners();
  }

  @override
  void dispose() {
    _sessionsBox?.close();
    _profilesBox?.close();
    super.dispose();
  }

  // Métodos legacy mantenidos para compatibilidad
  Future<void> generateRoutine({
    required String userId,
    required String profileId,
    required String targetMuscleGroup,
  }) async {
    // Implementación simplificada
  }

  List<WorkoutExercise> _generateExercises(String targetMuscleGroup, String difficulty) {
    return [];
  }

  Future<void> updateExerciseStatus({
    required String userId,
    required String profileId,
    required String routineId,
    required String exerciseId,
    required String status,
  }) async {
    // Implementación simplificada
  }

  void selectRoutine(WorkoutRoutine routine) {
    _selectedRoutine = routine;
    notifyListeners();
  }

  void clearSelectedRoutine() {
    _selectedRoutine = null;
    notifyListeners();
  }

  Map<String, Map<String, dynamic>> getProgressMap() {
    Map<String, Map<String, dynamic>> progressMap = {};

    for (var routine in _routines) {
      progressMap[routine.id] = {
        'name': routine.name,
        'progress': 0.0,
        'completed': 0,
        'total': routine.exercises.length,
      };
    }

    return progressMap;
  }

  List<WorkoutExercise> getTodayWorkouts() {
    if (_currentRoutine == null) return [];
    return _currentRoutine!.exercises;
  }

  // Método para obtener el plan semanal
  Map<String, String> getWeeklyPlan(Profile profile) {
    if (profile.weeklyPlan?.isNotEmpty ?? false) {
      return profile.weeklyPlan!;
    }
    
    // Plan por defecto basado en el nivel de fitness
    final Map<String, String> defaultPlan = {
      'Lunes': 'Descanso',
      'Martes': 'Descanso', 
      'Miércoles': 'Descanso',
      'Jueves': 'Descanso',
      'Viernes': 'Descanso',
      'Sábado': 'Descanso',
      'Domingo': 'Descanso',
    };

    if (profile.fitnessLevel == 'Principiante') {
      defaultPlan['Lunes'] = 'Cuerpo completo';
      defaultPlan['Miércoles'] = 'Cardio ligero';
      defaultPlan['Viernes'] = 'Cuerpo completo';
    } else if (profile.fitnessLevel == 'Intermedio') {
      defaultPlan['Lunes'] = 'Tren superior';
      defaultPlan['Martes'] = 'Cardio';
      defaultPlan['Miércoles'] = 'Tren inferior';
      defaultPlan['Viernes'] = 'Cuerpo completo';
    } else if (profile.fitnessLevel == 'Avanzado') {
      defaultPlan['Lunes'] = 'Push (Empuje)';
      defaultPlan['Martes'] = 'Pull (Tracción)';
      defaultPlan['Miércoles'] = 'Piernas';
      defaultPlan['Jueves'] = 'Cardio HIIT';
      defaultPlan['Viernes'] = 'Push (Empuje)';
      defaultPlan['Sábado'] = 'Pull (Tracción)';
    }

    return defaultPlan;
  }

  // Método para obtener la rutina de hoy
  List<WorkoutExercise> getTodayRoutine(Profile profile) {
    final weeklyPlan = getWeeklyPlan(profile);
    final today = DateTime.now();
    final dayNames = [
      'Domingo', 'Lunes', 'Martes', 'Miércoles', 
      'Jueves', 'Viernes', 'Sábado'
    ];
    
    final todayName = dayNames[today.weekday % 7];
    final todayPlan = weeklyPlan[todayName] ?? 'Descanso';
    
    // Si es día de descanso, retornar lista vacía
    if (todayPlan == 'Descanso') {
      return [];
    }
    
    // Retornar ejercicios de la rutina actual o ejercicios de muestra
    if (_currentRoutine != null) {
      return _currentRoutine!.exercises;
    }
    
    // Ejercicios de muestra basados en el plan del día
    return _getSampleExercisesForPlan(todayPlan);
  }

  // Método helper para obtener ejercicios de muestra
  List<WorkoutExercise> _getSampleExercisesForPlan(String planType) {
    switch (planType) {
      case 'Cuerpo completo':
        return [
          WorkoutExercise(
            id: 'sample1',
            name: 'Sentadillas',
            description: 'Ejercicio básico para piernas',
            sets: 3,
            reps: 12,
            muscleGroup: 'Piernas',
            weight: 20.0,
          ),
          WorkoutExercise(
            id: 'sample2',
            name: 'Flexiones',
            description: 'Ejercicio para pecho y brazos',
            sets: 3,
            reps: 10,
            muscleGroup: 'Pecho',
          ),
        ];
      case 'Tren superior':
        return [
          WorkoutExercise(
            id: 'sample3',
            name: 'Press de banca',
            description: 'Ejercicio principal para pecho',
            sets: 4,
            reps: 8,
            muscleGroup: 'Pecho',
            weight: 40.0,
          ),
          WorkoutExercise(
            id: 'sample4',
            name: 'Dominadas',
            description: 'Ejercicio para espalda',
            sets: 3,
            reps: 6,
            muscleGroup: 'Espalda',
          ),
        ];
      default:
        return [];
    }
  }

  Future<void> generateWeeklyPlan({
    required String userId,
    required String profileId,
  }) async {
    // Implementación simplificada
  }
} 