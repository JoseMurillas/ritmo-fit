// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WorkoutRoutineAdapter extends TypeAdapter<WorkoutRoutine> {
  @override
  final int typeId = 2;

  @override
  WorkoutRoutine read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WorkoutRoutine(
      id: fields[0] as String,
      name: fields[1] as String,
      description: fields[2] as String,
      targetMuscleGroup: fields[3] as String,
      difficulty: fields[4] as String,
      exercises: (fields[5] as List).cast<WorkoutExercise>(),
      durationWeeks: fields[6] as int,
      sessionsPerWeek: fields[7] as int,
      category: fields[8] as String,
      tags: (fields[9] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, WorkoutRoutine obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.targetMuscleGroup)
      ..writeByte(4)
      ..write(obj.difficulty)
      ..writeByte(5)
      ..write(obj.exercises)
      ..writeByte(6)
      ..write(obj.durationWeeks)
      ..writeByte(7)
      ..write(obj.sessionsPerWeek)
      ..writeByte(8)
      ..write(obj.category)
      ..writeByte(9)
      ..write(obj.tags);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkoutRoutineAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class WorkoutExerciseAdapter extends TypeAdapter<WorkoutExercise> {
  @override
  final int typeId = 3;

  @override
  WorkoutExercise read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WorkoutExercise(
      id: fields[0] as String,
      name: fields[1] as String,
      description: fields[2] as String,
      sets: fields[3] as int,
      reps: fields[4] as int,
      weight: fields[5] as double?,
      status: fields[6] as String,
      muscleGroup: fields[7] as String,
      instructions: fields[8] as String,
      imageUrl: fields[9] as String?,
      restTimeSeconds: fields[10] as int,
      equipment: fields[11] as String,
    );
  }

  @override
  void write(BinaryWriter writer, WorkoutExercise obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.sets)
      ..writeByte(4)
      ..write(obj.reps)
      ..writeByte(5)
      ..write(obj.weight)
      ..writeByte(6)
      ..write(obj.status)
      ..writeByte(7)
      ..write(obj.muscleGroup)
      ..writeByte(8)
      ..write(obj.instructions)
      ..writeByte(9)
      ..write(obj.imageUrl)
      ..writeByte(10)
      ..write(obj.restTimeSeconds)
      ..writeByte(11)
      ..write(obj.equipment);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkoutExerciseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class WorkoutSessionAdapter extends TypeAdapter<WorkoutSession> {
  @override
  final int typeId = 4;

  @override
  WorkoutSession read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WorkoutSession(
      id: fields[0] as String,
      routineId: fields[1] as String,
      profileId: fields[2] as String,
      date: fields[3] as DateTime,
      startTime: fields[4] as DateTime?,
      endTime: fields[5] as DateTime?,
      exerciseLogs: (fields[6] as List).cast<ExerciseLog>(),
      status: fields[7] as String,
      notes: fields[8] as String?,
      rating: fields[9] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, WorkoutSession obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.routineId)
      ..writeByte(2)
      ..write(obj.profileId)
      ..writeByte(3)
      ..write(obj.date)
      ..writeByte(4)
      ..write(obj.startTime)
      ..writeByte(5)
      ..write(obj.endTime)
      ..writeByte(6)
      ..write(obj.exerciseLogs)
      ..writeByte(7)
      ..write(obj.status)
      ..writeByte(8)
      ..write(obj.notes)
      ..writeByte(9)
      ..write(obj.rating);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkoutSessionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ExerciseLogAdapter extends TypeAdapter<ExerciseLog> {
  @override
  final int typeId = 5;

  @override
  ExerciseLog read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ExerciseLog(
      exerciseId: fields[0] as String,
      exerciseName: fields[1] as String,
      setLogs: (fields[2] as List).cast<SetLog>(),
      completed: fields[3] as bool,
      notes: fields[4] as String?,
      completedAt: fields[5] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, ExerciseLog obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.exerciseId)
      ..writeByte(1)
      ..write(obj.exerciseName)
      ..writeByte(2)
      ..write(obj.setLogs)
      ..writeByte(3)
      ..write(obj.completed)
      ..writeByte(4)
      ..write(obj.notes)
      ..writeByte(5)
      ..write(obj.completedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExerciseLogAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SetLogAdapter extends TypeAdapter<SetLog> {
  @override
  final int typeId = 6;

  @override
  SetLog read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SetLog(
      setNumber: fields[0] as int,
      reps: fields[1] as int,
      weight: fields[2] as double?,
      restTimeSeconds: fields[3] as int?,
      completed: fields[4] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, SetLog obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.setNumber)
      ..writeByte(1)
      ..write(obj.reps)
      ..writeByte(2)
      ..write(obj.weight)
      ..writeByte(3)
      ..write(obj.restTimeSeconds)
      ..writeByte(4)
      ..write(obj.completed);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SetLogAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
