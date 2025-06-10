// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forum_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ForumMessageAdapter extends TypeAdapter<ForumMessage> {
  @override
  final int typeId = 4;

  @override
  ForumMessage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ForumMessage(
      id: fields[0] as String,
      userId: fields[1] as String,
      title: fields[2] as String,
      content: fields[3] as String,
      createdAt: fields[4] as DateTime,
      replies: (fields[5] as List).cast<ForumReply>(),
    );
  }

  @override
  void write(BinaryWriter writer, ForumMessage obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.content)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.replies);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ForumMessageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ForumReplyAdapter extends TypeAdapter<ForumReply> {
  @override
  final int typeId = 5;

  @override
  ForumReply read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ForumReply(
      id: fields[0] as String,
      userId: fields[1] as String,
      content: fields[2] as String,
      createdAt: fields[3] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, ForumReply obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.content)
      ..writeByte(3)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ForumReplyAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
