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

  WorkoutRoutine({
    required this.id,
    required this.name,
    required this.description,
    required this.targetMuscleGroup,
    required this.difficulty,
    required this.exercises,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'targetMuscleGroup': targetMuscleGroup,
      'difficulty': difficulty,
      'exercises': exercises.map((e) => e.toJson()).toList(),
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

  WorkoutExercise({
    required this.id,
    required this.name,
    required this.description,
    required this.sets,
    required this.reps,
    this.weight,
    required this.status,
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
      status: json['status'] as String,
    );
  }
} 