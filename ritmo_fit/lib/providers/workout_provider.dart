import 'package:flutter/material.dart';
import 'package:ritmo_fit/models/user_model.dart';
import 'package:ritmo_fit/models/workout_model.dart';
import 'package:ritmo_fit/services/database_service.dart';
import 'package:uuid/uuid.dart';

class WorkoutProvider extends ChangeNotifier {
  final List<WorkoutRoutine> _routines = [];
  WorkoutRoutine? _selectedRoutine;
  bool _isLoading = false;
  String? _error;

  List<WorkoutRoutine> get routines => _routines;
  WorkoutRoutine? get selectedRoutine => _selectedRoutine;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void setRoutines(List<WorkoutRoutine> routines) {
    _routines.clear();
    _routines.addAll(routines);
    notifyListeners();
  }

  Future<void> generateRoutine({
    required String userId,
    required String profileId,
    required String targetMuscleGroup,
    required String difficulty,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      final user = await DatabaseService().getUser(userId);
      if (user == null) {
        throw Exception('Usuario no encontrado');
      }

      final profile = user.profiles.firstWhere(
        (p) => p.id == profileId,
        orElse: () => throw Exception('Perfil no encontrado'),
      );

      final routine = WorkoutRoutine(
        id: const Uuid().v4(),
        name: 'Rutina ${targetMuscleGroup}',
        description: 'Rutina de ${targetMuscleGroup.toLowerCase()} para nivel ${difficulty.toLowerCase()}',
        targetMuscleGroup: targetMuscleGroup,
        difficulty: difficulty,
        exercises: _generateExercises(targetMuscleGroup, difficulty),
      );

      final updatedProfile = Profile(
        id: profile.id,
        name: profile.name,
        age: profile.age,
        gender: profile.gender,
        weight: profile.weight,
        height: profile.height,
        routines: [...profile.routines, routine],
      );

      final updatedUser = User(
        id: user.id,
        email: user.email,
        name: user.name,
        password: user.password,
        profiles: user.profiles.map((p) => p.id == profileId ? updatedProfile : p).toList(),
      );

      await DatabaseService().saveUser(updatedUser);
      _routines.add(routine);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<WorkoutExercise> _generateExercises(String targetMuscleGroup, String difficulty) {
    // TODO: Implementar lógica para generar ejercicios según el grupo muscular y dificultad
    return [
      WorkoutExercise(
        id: const Uuid().v4(),
        name: 'Ejercicio 1',
        description: 'Descripción del ejercicio 1',
        sets: 3,
        reps: 12,
        status: 'pending',
      ),
      WorkoutExercise(
        id: const Uuid().v4(),
        name: 'Ejercicio 2',
        description: 'Descripción del ejercicio 2',
        sets: 3,
        reps: 12,
        status: 'pending',
      ),
    ];
  }

  Future<void> updateExerciseStatus({
    required String userId,
    required String profileId,
    required String routineId,
    required String exerciseId,
    required String status,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      final user = await DatabaseService().getUser(userId);
      if (user == null) {
        throw Exception('Usuario no encontrado');
      }

      final profile = user.profiles.firstWhere(
        (p) => p.id == profileId,
        orElse: () => throw Exception('Perfil no encontrado'),
      );

      final routine = profile.routines.firstWhere(
        (r) => r.id == routineId,
        orElse: () => throw Exception('Rutina no encontrada'),
      );

      final updatedExercises = routine.exercises.map((exercise) {
        if (exercise.id == exerciseId) {
          return WorkoutExercise(
            id: exercise.id,
            name: exercise.name,
            description: exercise.description,
            sets: exercise.sets,
            reps: exercise.reps,
            weight: exercise.weight,
            status: status,
          );
        }
        return exercise;
      }).toList();

      final updatedRoutine = WorkoutRoutine(
        id: routine.id,
        name: routine.name,
        description: routine.description,
        targetMuscleGroup: routine.targetMuscleGroup,
        difficulty: routine.difficulty,
        exercises: updatedExercises,
      );

      final updatedProfile = Profile(
        id: profile.id,
        name: profile.name,
        age: profile.age,
        gender: profile.gender,
        weight: profile.weight,
        height: profile.height,
        routines: profile.routines.map((r) => r.id == routineId ? updatedRoutine : r).toList(),
      );

      final updatedUser = User(
        id: user.id,
        email: user.email,
        name: user.name,
        password: user.password,
        profiles: user.profiles.map((p) => p.id == profileId ? updatedProfile : p).toList(),
      );

      await DatabaseService().saveUser(updatedUser);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectRoutine(WorkoutRoutine routine) {
    _selectedRoutine = routine;
    notifyListeners();
  }

  void clearSelectedRoutine() {
    _selectedRoutine = null;
    notifyListeners();
  }
} 