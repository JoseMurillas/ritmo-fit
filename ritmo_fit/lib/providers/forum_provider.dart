import 'package:flutter/material.dart';
import 'package:ritmo_fit/models/forum_model.dart';
import 'package:ritmo_fit/services/database_service.dart';
import 'package:uuid/uuid.dart';

class ForumProvider extends ChangeNotifier {
  final DatabaseService _databaseService;
  List<ForumPost> _posts = [];
  bool _isLoading = false;
  String? _error;

  ForumProvider(this._databaseService);

  List<ForumPost> get posts => _posts;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Métodos para compatibilidad con la versión anterior
  List<ForumMessage> get messages => [];

  Future<void> loadPosts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Por ahora, vamos a crear algunos posts de ejemplo
      _posts = [
        ForumPost(
          id: const Uuid().v4(),
          authorName: 'Carlos Fitness',
          content: '¡Acabo de completar mi primera maratón! 42km en 3h 45min. La preparación fue intensa pero valió totalmente la pena. Gracias a todos por el apoyo 🏃‍♂️💪',
          createdAt: DateTime.now().subtract(const Duration(hours: 2)),
          likes: ['user1', 'user2'],
          comments: [
            Comment(
              id: const Uuid().v4(),
              authorName: 'Ana Runner',
              content: '¡Increíble tiempo! ¿Cuál fue tu plan de entrenamiento?',
              createdAt: DateTime.now().subtract(const Duration(hours: 1)),
            ),
          ],
        ),
        ForumPost(
          id: const Uuid().v4(),
          authorName: 'María Yoga',
          content: 'Rutina matutina perfecta ✨ 30 minutos de yoga + 15 minutos de meditación. Así empiezo todos mis días desde hace 6 meses y mi energía ha cambiado completamente.',
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
          likes: ['user3'],
          comments: [
            Comment(
              id: const Uuid().v4(),
              authorName: 'Luis Zen',
              content: 'Me inspiraste! Voy a intentar hacer lo mismo',
              createdAt: DateTime.now().subtract(const Duration(hours: 12)),
            ),
            Comment(
              id: const Uuid().v4(),
              authorName: 'Sofia Wellness',
              content: '¿Qué app usas para la meditación?',
              createdAt: DateTime.now().subtract(const Duration(hours: 8)),
            ),
          ],
        ),
        ForumPost(
          id: const Uuid().v4(),
          authorName: 'Javier Strong',
          content: 'Nuevo PR en sentadillas! 💪 150kg x 5 reps. Llevaba 3 meses estancado y por fin logré romper la barrera. La constancia y una buena nutrición son clave.',
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
          likes: ['user1', 'user4', 'user5'],
          comments: [
            Comment(
              id: const Uuid().v4(),
              authorName: 'Pedro Gym',
              content: '¡Bestial! ¿Cuánto tiempo llevas entrenando?',
              createdAt: DateTime.now().subtract(const Duration(days: 1)),
            ),
          ],
        ),
      ];
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createPost({
    required String content,
    required String authorName,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final post = ForumPost(
        id: const Uuid().v4(),
        authorName: authorName,
        content: content,
        createdAt: DateTime.now(),
        likes: [],
        comments: [],
      );

      _posts.insert(0, post); // Agregar al inicio
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addComment({
    required String postId,
    required String content,
    required String authorName,
  }) async {
    try {
      final postIndex = _posts.indexWhere((p) => p.id == postId);
      if (postIndex == -1) return;

      final comment = Comment(
        id: const Uuid().v4(),
        authorName: authorName,
        content: content,
        createdAt: DateTime.now(),
      );

      final updatedPost = ForumPost(
        id: _posts[postIndex].id,
        authorName: _posts[postIndex].authorName,
        content: _posts[postIndex].content,
        createdAt: _posts[postIndex].createdAt,
        likes: _posts[postIndex].likes,
        comments: [..._posts[postIndex].comments, comment],
      );

      _posts[postIndex] = updatedPost;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> toggleLike(String postId) async {
    try {
      final postIndex = _posts.indexWhere((p) => p.id == postId);
      if (postIndex == -1) return;

      final currentLikes = List<String>.from(_posts[postIndex].likes);
      const currentUser = 'current_user'; // En una app real, esto vendría del auth

      if (currentLikes.contains(currentUser)) {
        currentLikes.remove(currentUser);
      } else {
        currentLikes.add(currentUser);
      }

      final updatedPost = ForumPost(
        id: _posts[postIndex].id,
        authorName: _posts[postIndex].authorName,
        content: _posts[postIndex].content,
        createdAt: _posts[postIndex].createdAt,
        likes: currentLikes,
        comments: _posts[postIndex].comments,
      );

      _posts[postIndex] = updatedPost;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Métodos legacy para compatibilidad
  Future<void> loadMessages() async {
    await loadPosts();
  }

  Future<void> addMessage({
    required String userId,
    required String title,
    required String content,
  }) async {
    await createPost(content: '$title\n$content', authorName: 'Usuario');
  }

  Future<void> addReply({
    required String messageId,
    required String userId,
    required String content,
  }) async {
    await addComment(postId: messageId, content: content, authorName: 'Usuario');
  }

  Future<void> deleteMessage(String messageId) async {
    _posts.removeWhere((p) => p.id == messageId);
    notifyListeners();
  }
} 