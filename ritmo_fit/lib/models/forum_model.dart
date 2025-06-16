import 'package:hive/hive.dart';

part 'forum_model.g.dart';

@HiveType(typeId: 7)
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

@HiveType(typeId: 8)
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

// Nuevas clases para la estructura moderna del foro
@HiveType(typeId: 9)
class ForumPost {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String authorName;

  @HiveField(2)
  final String content;

  @HiveField(3)
  final DateTime createdAt;

  @HiveField(4)
  final List<String> likes;

  @HiveField(5)
  final List<Comment> comments;

  ForumPost({
    required this.id,
    required this.authorName,
    required this.content,
    required this.createdAt,
    this.likes = const [],
    this.comments = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'authorName': authorName,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'likes': likes,
      'comments': comments.map((c) => c.toJson()).toList(),
    };
  }

  factory ForumPost.fromJson(Map<String, dynamic> json) {
    return ForumPost(
      id: json['id'] as String,
      authorName: json['authorName'] as String,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      likes: List<String>.from(json['likes'] ?? []),
      comments: (json['comments'] as List?)
          ?.map((c) => Comment.fromJson(c as Map<String, dynamic>))
          .toList() ?? [],
    );
  }
}

@HiveType(typeId: 10)
class Comment {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String authorName;

  @HiveField(2)
  final String content;

  @HiveField(3)
  final DateTime createdAt;

  Comment({
    required this.id,
    required this.authorName,
    required this.content,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'authorName': authorName,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'] as String,
      authorName: json['authorName'] as String,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
} 