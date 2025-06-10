import 'package:flutter/material.dart';
import 'package:ritmo_fit/models/user_model.dart';
import 'package:ritmo_fit/services/database_service.dart';
import 'package:uuid/uuid.dart';

class ProfileProvider extends ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();
  List<Profile> _profiles = [];
  Profile? _selectedProfile;
  bool _isLoading = false;
  String? _error;

  List<Profile> get profiles => _profiles;
  Profile? get selectedProfile => _selectedProfile;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadProfiles(String userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final user = await _databaseService.getUser(userId);
      if (user != null) {
        _profiles = user.profiles;
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

      final profile = Profile(
        id: const Uuid().v4(),
        name: name,
        age: age,
        gender: gender,
        weight: weight,
        height: height,
        routines: [], // Lista vacía de rutinas para un nuevo perfil
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
        routines: user.profiles[profileIndex].routines,
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
    notifyListeners();
  }

  void clearSelectedProfile() {
    _selectedProfile = null;
    notifyListeners();
  }
} 