import 'package:hive/hive.dart';
import 'package:ritmo_fit/models/user_model.dart';
import 'package:ritmo_fit/models/forum_model.dart';

class DatabaseService {
  static const String _usersBoxName = 'users';
  static const String _forumBoxName = 'forum';

  Future<void> init() async {
    await Hive.openBox<User>(_usersBoxName);
    await Hive.openBox<ForumMessage>(_forumBoxName);
  }

  // Métodos para usuarios
  Future<void> saveUser(User user) async {
    final box = await Hive.openBox<User>(_usersBoxName);
    await box.put(user.id, user);
  }

  Future<User?> getUser(String id) async {
    final box = await Hive.openBox<User>(_usersBoxName);
    return box.get(id);
  }

  Future<List<User>> getAllUsers() async {
    final box = await Hive.openBox<User>(_usersBoxName);
    return box.values.toList();
  }

  Future<void> deleteUser(String id) async {
    final box = await Hive.openBox<User>(_usersBoxName);
    await box.delete(id);
  }

  // Métodos para perfiles
  Future<void> addProfile(String userId, Profile profile) async {
    final user = await getUser(userId);
    if (user != null) {
      final updatedProfiles = List<Profile>.from(user.profiles)..add(profile);
      final updatedUser = User(
        id: user.id,
        name: user.name,
        email: user.email,
        password: user.password,
        profiles: updatedProfiles,
      );
      await saveUser(updatedUser);
    }
  }

  Future<void> updateProfile(String userId, Profile updatedProfile) async {
    final user = await getUser(userId);
    if (user != null) {
      final updatedProfiles = user.profiles.map((profile) {
        return profile.id == updatedProfile.id ? updatedProfile : profile;
      }).toList();
      final updatedUser = User(
        id: user.id,
        name: user.name,
        email: user.email,
        password: user.password,
        profiles: updatedProfiles,
      );
      await saveUser(updatedUser);
    }
  }

  // Métodos para el foro
  Future<void> saveForumMessage(ForumMessage message) async {
    final box = await Hive.openBox<ForumMessage>(_forumBoxName);
    await box.put(message.id, message);
  }

  Future<List<ForumMessage>> getForumMessages() async {
    final box = await Hive.openBox<ForumMessage>(_forumBoxName);
    return box.values.toList();
  }

  Future<void> deleteForumMessage(String id) async {
    final box = await Hive.openBox<ForumMessage>(_forumBoxName);
    await box.delete(id);
  }

  Future<void> addForumReply(String messageId, ForumReply reply) async {
    final box = await Hive.openBox<ForumMessage>(_forumBoxName);
    final message = box.get(messageId);
    if (message != null) {
      final updatedMessage = ForumMessage(
        id: message.id,
        userId: message.userId,
        title: message.title,
        content: message.content,
        createdAt: message.createdAt,
        replies: [...message.replies, reply],
      );
      await box.put(messageId, updatedMessage);
    }
  }
} 