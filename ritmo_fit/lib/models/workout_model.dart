import 'package:hive/hive.dart';

part 'workout_model.g.dart';

@HiveType(typeId: 2)
class WorkoutRoutine {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final String targetMuscleGroup;

  @HiveField(4)
  final String difficulty;

  @HiveField(5)
  final List<WorkoutExercise> exercises;

  @HiveField(6)
  final int durationWeeks;

  @HiveField(7)
  final int sessionsPerWeek;

  @HiveField(8)
  final String category;

  @HiveField(9)
  final List<String> tags;

  WorkoutRoutine({
    required this.id,
    required this.name,
    required this.description,
    required this.targetMuscleGroup,
    required this.difficulty,
    required this.exercises,
    this.durationWeeks = 4,
    this.sessionsPerWeek = 3,
    this.category = 'General',
    this.tags = const [],
  });

  int get totalExercises => exercises.length;
  
  int get estimatedDurationMinutes {
    // Estimación: 3-4 minutos por serie + tiempo de descanso
    final totalSets = exercises.fold(0, (sum, exercise) => sum + exercise.sets);
    return (totalSets * 3.5).round();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'targetMuscleGroup': targetMuscleGroup,
      'difficulty': difficulty,
      'exercises': exercises.map((e) => e.toJson()).toList(),
      'durationWeeks': durationWeeks,
      'sessionsPerWeek': sessionsPerWeek,
      'category': category,
      'tags': tags,
    };
  }

  factory WorkoutRoutine.fromJson(Map<String, dynamic> json) {
    return WorkoutRoutine(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      targetMuscleGroup: json['targetMuscleGroup'] as String,
      difficulty: json['difficulty'] as String,
      exercises: (json['exercises'] as List)
          .map((e) => WorkoutExercise.fromJson(e as Map<String, dynamic>))
          .toList(),
      durationWeeks: json['durationWeeks'] as int? ?? 4,
      sessionsPerWeek: json['sessionsPerWeek'] as int? ?? 3,
      category: json['category'] as String? ?? 'General',
      tags: (json['tags'] as List?)?.cast<String>() ?? [],
    );
  }
}

@HiveType(typeId: 3)
class WorkoutExercise {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final int sets;

  @HiveField(4)
  final int reps;

  @HiveField(5)
  final double? weight;

  @HiveField(6)
  final String status;

  @HiveField(7)
  final String muscleGroup;

  @HiveField(8)
  final String instructions;

  @HiveField(9)
  final String? imageUrl;

  @HiveField(10)
  final int restTimeSeconds;

  @HiveField(11)
  final String equipment;

  WorkoutExercise({
    required this.id,
    required this.name,
    required this.description,
    required this.sets,
    required this.reps,
    this.weight,
    this.status = 'pending',
    required this.muscleGroup,
    this.instructions = '',
    this.imageUrl,
    this.restTimeSeconds = 60,
    this.equipment = 'Ninguno',
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'sets': sets,
      'reps': reps,
      'weight': weight,
      'status': status,
      'muscleGroup': muscleGroup,
      'instructions': instructions,
      'imageUrl': imageUrl,
      'restTimeSeconds': restTimeSeconds,
      'equipment': equipment,
    };
  }

  factory WorkoutExercise.fromJson(Map<String, dynamic> json) {
    return WorkoutExercise(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      sets: json['sets'] as int,
      reps: json['reps'] as int,
      weight: json['weight'] as double?,
      status: json['status'] as String? ?? 'pending',
      muscleGroup: json['muscleGroup'] as String,
      instructions: json['instructions'] as String? ?? '',
      imageUrl: json['imageUrl'] as String?,
      restTimeSeconds: json['restTimeSeconds'] as int? ?? 60,
      equipment: json['equipment'] as String? ?? 'Ninguno',
    );
  }
}

@HiveType(typeId: 4)
class WorkoutSession {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String routineId;

  @HiveField(2)
  final String profileId;

  @HiveField(3)
  final DateTime date;

  @HiveField(4)
  final DateTime? startTime;

  @HiveField(5)
  final DateTime? endTime;

  @HiveField(6)
  final List<ExerciseLog> exerciseLogs;

  @HiveField(7)
  final String status;

  @HiveField(8)
  final String? notes;

  @HiveField(9)
  final double? rating;

  WorkoutSession({
    required this.id,
    required this.routineId,
    required this.profileId,
    required this.date,
    this.startTime,
    this.endTime,
    this.exerciseLogs = const [],
    this.status = 'planned',
    this.notes,
    this.rating,
  });

  int? get durationMinutes {
    if (startTime != null && endTime != null) {
      return endTime!.difference(startTime!).inMinutes;
    }
    return null;
  }

  double get completionPercentage {
    if (exerciseLogs.isEmpty) return 0.0;
    final completedCount = exerciseLogs.where((log) => log.completed).length;
    return (completedCount / exerciseLogs.length) * 100;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'routineId': routineId,
      'profileId': profileId,
      'date': date.toIso8601String(),
      'startTime': startTime?.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'exerciseLogs': exerciseLogs.map((e) => e.toJson()).toList(),
      'status': status,
      'notes': notes,
      'rating': rating,
    };
  }

  factory WorkoutSession.fromJson(Map<String, dynamic> json) {
    return WorkoutSession(
      id: json['id'] as String,
      routineId: json['routineId'] as String,
      profileId: json['profileId'] as String,
      date: DateTime.parse(json['date'] as String),
      startTime: json['startTime'] != null ? DateTime.parse(json['startTime'] as String) : null,
      endTime: json['endTime'] != null ? DateTime.parse(json['endTime'] as String) : null,
      exerciseLogs: (json['exerciseLogs'] as List)
          .map((e) => ExerciseLog.fromJson(e as Map<String, dynamic>))
          .toList(),
      status: json['status'] as String? ?? 'planned',
      notes: json['notes'] as String?,
      rating: json['rating'] as double?,
    );
  }
}

@HiveType(typeId: 5)
class ExerciseLog {
  @HiveField(0)
  final String exerciseId;

  @HiveField(1)
  final String exerciseName;

  @HiveField(2)
  final List<SetLog> setLogs;

  @HiveField(3)
  final bool completed;

  @HiveField(4)
  final String? notes;

  @HiveField(5)
  final DateTime? completedAt;

  ExerciseLog({
    required this.exerciseId,
    required this.exerciseName,
    this.setLogs = const [],
    this.completed = false,
    this.notes,
    this.completedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'exerciseId': exerciseId,
      'exerciseName': exerciseName,
      'setLogs': setLogs.map((s) => s.toJson()).toList(),
      'completed': completed,
      'notes': notes,
      'completedAt': completedAt?.toIso8601String(),
    };
  }

  factory ExerciseLog.fromJson(Map<String, dynamic> json) {
    return ExerciseLog(
      exerciseId: json['exerciseId'] as String,
      exerciseName: json['exerciseName'] as String,
      setLogs: (json['setLogs'] as List)
          .map((s) => SetLog.fromJson(s as Map<String, dynamic>))
          .toList(),
      completed: json['completed'] as bool? ?? false,
      notes: json['notes'] as String?,
      completedAt: json['completedAt'] != null 
          ? DateTime.parse(json['completedAt'] as String) 
          : null,
    );
  }
}

@HiveType(typeId: 6)
class SetLog {
  @HiveField(0)
  final int setNumber;

  @HiveField(1)
  final int reps;

  @HiveField(2)
  final double? weight;

  @HiveField(3)
  final int? restTimeSeconds;

  @HiveField(4)
  final bool completed;

  SetLog({
    required this.setNumber,
    required this.reps,
    this.weight,
    this.restTimeSeconds,
    this.completed = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'setNumber': setNumber,
      'reps': reps,
      'weight': weight,
      'restTimeSeconds': restTimeSeconds,
      'completed': completed,
    };
  }

  factory SetLog.fromJson(Map<String, dynamic> json) {
    return SetLog(
      setNumber: json['setNumber'] as int,
      reps: json['reps'] as int,
      weight: json['weight'] as double?,
      restTimeSeconds: json['restTimeSeconds'] as int?,
      completed: json['completed'] as bool? ?? false,
    );
  }
} 