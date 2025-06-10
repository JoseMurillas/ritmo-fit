import 'package:flutter/material.dart';
import 'package:ritmo_fit/models/forum_model.dart';
import 'package:ritmo_fit/models/user_model.dart';
import 'package:ritmo_fit/services/database_service.dart';
import 'package:uuid/uuid.dart';

class ForumProvider extends ChangeNotifier {
  final DatabaseService _databaseService;
  List<ForumMessage> _messages = [];
  bool _isLoading = false;
  String? _error;

  ForumProvider(this._databaseService);

  List<ForumMessage> get messages => _messages;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadMessages() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _messages = await _databaseService.getForumMessages();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addMessage({
    required String userId,
    required String title,
    required String content,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final message = ForumMessage(
        id: const Uuid().v4(),
        userId: userId,
        title: title,
        content: content,
        createdAt: DateTime.now(),
      );

      await _databaseService.saveForumMessage(message);
      _messages.add(message);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addReply({
    required String messageId,
    required String userId,
    required String content,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final messageIndex = _messages.indexWhere((m) => m.id == messageId);
      if (messageIndex == -1) {
        throw Exception('Mensaje no encontrado');
      }

      final reply = ForumReply(
        id: const Uuid().v4(),
        userId: userId,
        content: content,
        createdAt: DateTime.now(),
      );

      final updatedMessage = ForumMessage(
        id: _messages[messageIndex].id,
        userId: _messages[messageIndex].userId,
        title: _messages[messageIndex].title,
        content: _messages[messageIndex].content,
        createdAt: _messages[messageIndex].createdAt,
        replies: [..._messages[messageIndex].replies, reply],
      );

      await _databaseService.saveForumMessage(updatedMessage);
      _messages[messageIndex] = updatedMessage;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteMessage(String messageId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _databaseService.deleteForumMessage(messageId);
      _messages.removeWhere((m) => m.id == messageId);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
} 