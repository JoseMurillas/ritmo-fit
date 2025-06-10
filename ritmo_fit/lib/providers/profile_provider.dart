import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ritmo_fit/models/user_model.dart';
import 'package:ritmo_fit/services/database_service.dart';
import 'package:ritmo_fit/services/workout_service.dart';
import 'package:ritmo_fit/models/workout_model.dart';
import 'package:uuid/uuid.dart';
import 'package:ritmo_fit/providers/workout_provider.dart';

class ProfileProvider extends ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();
  List<Profile> _profiles = [];
  Profile? _selectedProfile;
  bool _isLoading = false;
  String? _error;

  WorkoutProvider? _workoutProvider;

  List<Profile> get profiles => _profiles;
  Profile? get selectedProfile => _selectedProfile;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void setWorkoutProvider(WorkoutProvider workoutProvider) {
    _workoutProvider = workoutProvider;
  }

  Future<void> loadProfiles(String userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final user = await _databaseService.getUser(userId);
      if (user != null) {
        _profiles = user.profiles;
        if (_profiles.isNotEmpty && _selectedProfile == null) {
          _selectedProfile = _profiles.first;
        }
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addProfile({
    required String userId,
    required String name,
    required int age,
    required String gender,
    required double weight,
    required double height,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final user = await _databaseService.getUser(userId);
      if (user == null) {
        throw Exception('Usuario no encontrado');
      }

      // Generar plan semanal
      final muscleGroups = ['Piernas', 'Pecho', 'Espalda', 'Brazos', 'Hombros', 'Core', 'Full Body'];
      final Map<String, String> weeklyPlan = {};
      for (int i = 0; i < 7; i++) {
        final day = ['Lunes','Martes','Miércoles','Jueves','Viernes','Sábado','Domingo'][i];
        weeklyPlan[day] = muscleGroups[i % muscleGroups.length];
      }
      
      final bmi = height > 0 ? weight / (height * height) : 0.0;
      String bmiCategory;
      if (bmi < 18.5) bmiCategory = 'Bajo peso';
      else if (bmi < 25) bmiCategory = 'Normal';
      else if (bmi < 30) bmiCategory = 'Sobrepeso';
      else bmiCategory = 'Obesidad';

      // Generar rutinas para el plan
      final uniqueGroups = weeklyPlan.values.toSet().toList();
      final List<WorkoutRoutine> generatedRoutines = [];
      for (var group in uniqueGroups) {
        final routine = WorkoutService.generateRoutine(
          gender: gender,
          bmiCategory: bmiCategory,
          targetMuscleGroup: group,
          age: age,
          bmi: bmi,
        );
        generatedRoutines.add(routine);
      }

      final profile = Profile(
        id: const Uuid().v4(),
        name: name,
        age: age,
        gender: gender,
        weight: weight,
        height: height,
        routines: generatedRoutines,
        weeklyPlan: weeklyPlan,
      );

      final updatedProfiles = List<Profile>.from(user.profiles)..add(profile);
      final updatedUser = User(
        id: user.id,
        name: user.name,
        email: user.email,
        password: user.password,
        profiles: updatedProfiles,
      );

      await _databaseService.saveUser(updatedUser);
      _profiles = updatedProfiles;
      
      if (_selectedProfile == null || _profiles.length == 1) {
        selectProfile(profile);
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateProfile({
    required String userId,
    required String profileId,
    required String name,
    required int age,
    required String gender,
    required double weight,
    required double height,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final user = await _databaseService.getUser(userId);
      if (user == null) {
        throw Exception('Usuario no encontrado');
      }

      final profileIndex = user.profiles.indexWhere((p) => p.id == profileId);
      if (profileIndex == -1) {
        throw Exception('Perfil no encontrado');
      }

      final updatedProfile = Profile(
        id: profileId,
        name: name,
        age: age,
        gender: gender,
        weight: weight,
        height: height,
        routines: user.profiles[profileIndex].routines, // Conserva rutinas existentes
        weeklyPlan: user.profiles[profileIndex].weeklyPlan, // Conserva plan existente
      );

      final updatedProfiles = List<Profile>.from(user.profiles);
      updatedProfiles[profileIndex] = updatedProfile;

      final updatedUser = User(
        id: user.id,
        name: user.name,
        email: user.email,
        password: user.password,
        profiles: updatedProfiles,
      );

      await _databaseService.saveUser(updatedUser);
      _profiles = updatedProfiles;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectProfile(Profile profile) {
    _selectedProfile = profile;
    _workoutProvider?.setRoutines(profile.routines);
    notifyListeners();
  }

  void clearSelectedProfile() {
    _selectedProfile = null;
    _workoutProvider?.setRoutines([]);
    notifyListeners();
  }
} 