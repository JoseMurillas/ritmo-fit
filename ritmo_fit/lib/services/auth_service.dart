import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ritmo_fit/models/user_model.dart';
import 'package:ritmo_fit/services/database_service.dart';
import 'package:uuid/uuid.dart';

class AuthService {
  final _storage = const FlutterSecureStorage();
  final _databaseService = DatabaseService();
  static const _userIdKey = 'user_id';
  static const _isLoggedInKey = 'is_logged_in';
  User? _currentUser;

  User? get currentUser => _currentUser;

  Future<void> register(String email, String password, String name) async {
    try {
      final users = await _databaseService.getAllUsers();
      if (users.any((user) => user.email == email)) {
        throw Exception('El email ya está registrado');
      }

      final user = User(
        id: const Uuid().v4(),
        email: email,
        name: name,
        password: password,
        profiles: [], // Lista vacía de perfiles para un nuevo usuario
      );

      await _databaseService.saveUser(user);
      await _storage.write(key: _userIdKey, value: user.id);
      _currentUser = user;
    } catch (e) {
      throw Exception('Error al registrar usuario: ${e.toString()}');
    }
  }

  Future<void> login(String email, String password) async {
    try {
      final users = await _databaseService.getAllUsers();
      final user = users.firstWhere(
        (user) => user.email == email && user.password == password,
        orElse: () => throw Exception('Credenciales inválidas'),
      );

      await _storage.write(key: _userIdKey, value: user.id);
      _currentUser = user;
    } catch (e) {
      throw Exception('Error al iniciar sesión: ${e.toString()}');
    }
  }

  Future<void> logout() async {
    try {
      await _storage.delete(key: _userIdKey);
      _currentUser = null;
    } catch (e) {
      throw Exception('Error al cerrar sesión: ${e.toString()}');
    }
  }

  Future<bool> isLoggedIn() async {
    try {
      final userId = await _storage.read(key: _userIdKey);
      if (userId != null) {
        _currentUser = await _databaseService.getUser(userId);
        return _currentUser != null;
      }
      return false;
    } catch (e) {
      throw Exception('Error al verificar el estado de la sesión: ${e.toString()}');
    }
  }

  Future<User?> getCurrentUser() async {
    try {
      final userId = await _storage.read(key: _userIdKey);
      if (userId == null) return null;
      return _databaseService.getUser(userId);
    } catch (e) {
      throw Exception('Error al obtener el usuario actual: ${e.toString()}');
    }
  }
} 