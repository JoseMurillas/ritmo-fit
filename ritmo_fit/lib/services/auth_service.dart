import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ritmo_fit/models/user_model.dart';
import 'package:ritmo_fit/services/database_service.dart';
import 'package:uuid/uuid.dart';

class AuthService {
  final _storage = const FlutterSecureStorage();
  static const _userIdKey = 'user_id';
  static const _isLoggedInKey = 'is_logged_in';
  User? _currentUser;

  User? get currentUser => _currentUser;

  Future<void> register(String email, String password, String name) async {
    final users = await DatabaseService().getAllUsers();
    if (users.any((user) => user.email == email)) {
      throw Exception('El email ya está registrado');
    }

    final user = User(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      email: email,
      name: name,
      password: password,
    );

    await DatabaseService().saveUser(user);
    await _storage.write(key: _userIdKey, value: user.id);
    _currentUser = user;
  }

  Future<void> login(String email, String password) async {
    final users = await DatabaseService().getAllUsers();
    final user = users.firstWhere(
      (user) => user.email == email && user.password == password,
      orElse: () => throw Exception('Credenciales inválidas'),
    );

    await _storage.write(key: _userIdKey, value: user.id);
    _currentUser = user;
  }

  Future<void> logout() async {
    await _storage.delete(key: _userIdKey);
    _currentUser = null;
  }

  Future<bool> isLoggedIn() async {
    final userId = await _storage.read(key: _userIdKey);
    if (userId != null) {
      _currentUser = await DatabaseService().getUser(userId);
      return _currentUser != null;
    }
    return false;
  }

  Future<User?> getCurrentUser() async {
    final userId = await _storage.read(key: _userIdKey);
    if (userId == null) return null;
    return DatabaseService().getUser(userId);
  }
} 