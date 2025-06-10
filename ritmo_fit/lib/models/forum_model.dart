import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'forum_model.g.dart';

@HiveType(typeId: 2)
class ForumMessage {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String userId;

  @HiveField(2)
  final String title;

  @HiveField(3)
  final String content;

  @HiveField(4)
  final DateTime createdAt;

  @HiveField(5)
  final List<ForumReply> replies;

  ForumMessage({
    required this.id,
    required this.userId,
    required this.title,
    required this.content,
    required this.createdAt,
    this.replies = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'replies': replies.map((r) => r.toJson()).toList(),
    };
  }

  factory ForumMessage.fromJson(Map<String, dynamic> json) {
    return ForumMessage(
      id: json['id'] as String,
      userId: json['userId'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      replies: (json['replies'] as List)
          .map((r) => ForumReply.fromJson(r as Map<String, dynamic>))
          .toList(),
    );
  }
}

@HiveType(typeId: 3)
class ForumReply {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String userId;

  @HiveField(2)
  final String content;

  @HiveField(3)
  final DateTime createdAt;

  ForumReply({
    required this.id,
    required this.userId,
    required this.content,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory ForumReply.fromJson(Map<String, dynamic> json) {
    return ForumReply(
      id: json['id'] as String,
      userId: json['userId'] as String,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
} 