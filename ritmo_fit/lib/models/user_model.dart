import 'package:hive/hive.dart';
import 'package:ritmo_fit/models/workout_model.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class User {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String email;

  @HiveField(2)
  final String name;

  @HiveField(3)
  final String password;

  @HiveField(4)
  final List<Profile> profiles;

  User({
    required this.id,
    required this.email,
    required this.name,
    required this.password,
    required this.profiles,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'password': password,
      'profiles': profiles.map((p) => p.toJson()).toList(),
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      password: json['password'] as String,
      profiles: (json['profiles'] as List)
          .map((p) => Profile.fromJson(p as Map<String, dynamic>))
          .toList(),
    );
  }
}

@HiveType(typeId: 1)
class Profile {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final int age;

  @HiveField(3)
  final String gender;

  @HiveField(4)
  final double weight;

  @HiveField(5)
  final double height;

  @HiveField(6)
  final List<WorkoutRoutine> routines;

  Profile({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.weight,
    required this.height,
    required this.routines,
  });

  double get bmi => weight / (height * height);

  String get bmiCategory {
    if (bmi < 18.5) return 'Bajo peso';
    if (bmi < 25) return 'Normal';
    if (bmi < 30) return 'Sobrepeso';
    return 'Obesidad';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'gender': gender,
      'weight': weight,
      'height': height,
      'routines': routines.map((r) => r.toJson()).toList(),
    };
  }

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'] as String,
      name: json['name'] as String,
      age: json['age'] as int,
      gender: json['gender'] as String,
      weight: json['weight'] as double,
      height: json['height'] as double,
      routines: (json['routines'] as List)
          .map((r) => WorkoutRoutine.fromJson(r as Map<String, dynamic>))
          .toList(),
    );
  }
}

@HiveType(typeId: 2)
class WorkoutRoutine extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final List<Exercise> exercises;

  @HiveField(4)
  final String targetMuscleGroup;

  @HiveField(5)
  final String difficulty;

  WorkoutRoutine({
    required this.id,
    required this.name,
    required this.description,
    required this.exercises,
    required this.targetMuscleGroup,
    required this.difficulty,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'exercises': exercises.map((exercise) => exercise.toJson()).toList(),
      'targetMuscleGroup': targetMuscleGroup,
      'difficulty': difficulty,
    };
  }

  factory WorkoutRoutine.fromJson(Map<String, dynamic> json) {
    return WorkoutRoutine(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      exercises: (json['exercises'] as List)
          .map((exercise) => Exercise.fromJson(exercise))
          .toList(),
      targetMuscleGroup: json['targetMuscleGroup'],
      difficulty: json['difficulty'],
    );
  }
}

@HiveType(typeId: 3)
class Exercise extends HiveObject {
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
  final String status; // 'pending', 'in_progress', 'completed'

  Exercise({
    required this.id,
    required this.name,
    required this.description,
    required this.sets,
    required this.reps,
    this.weight,
    this.status = 'pending',
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

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      sets: json['sets'],
      reps: json['reps'],
      weight: json['weight']?.toDouble(),
      status: json['status'],
    );
  }
} 