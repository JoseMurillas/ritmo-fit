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

  @HiveField(7)
  final Map<String, String>? weeklyPlan;

  @HiveField(8)
  final double muscleMassPercentage;

  @HiveField(9)
  final String fitnessLevel;

  @HiveField(10)
  final String? currentRoutineId;

  Profile({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.weight,
    required this.height,
    required this.routines,
    this.weeklyPlan,
    this.muscleMassPercentage = 0.0,
    String? fitnessLevel,
    this.currentRoutineId,
  }) : fitnessLevel = fitnessLevel ?? _calculateFitnessLevel(age, muscleMassPercentage, weight, height);

  double get bmi => weight / (height * height);

  String get bmiCategory {
    if (bmi < 18.5) return 'Bajo peso';
    if (bmi < 25) return 'Normal';
    if (bmi < 30) return 'Sobrepeso';
    return 'Obesidad';
  }

  static String _calculateFitnessLevel(int age, double muscleMass, double weight, double height) {
    final bmi = weight / (height * height);
    
    // Algoritmo para determinar nivel de fitness basado en edad, IMC y masa muscular
    int score = 0;
    
    // Puntuación por edad
    if (age <= 25) score += 3;
    else if (age <= 35) score += 2;
    else if (age <= 45) score += 1;
    
    // Puntuación por IMC
    if (bmi >= 18.5 && bmi < 25) score += 3;
    else if (bmi >= 25 && bmi < 30) score += 2;
    else score += 1;
    
    // Puntuación por masa muscular
    if (muscleMass >= 40) score += 3;
    else if (muscleMass >= 30) score += 2;
    else if (muscleMass >= 20) score += 1;
    
    // Determinar nivel
    if (score >= 7) return 'avanzado';
    else if (score >= 5) return 'intermedio';
    else return 'principiante';
  }

  String get fitnessLevelDescription {
    switch (fitnessLevel) {
      case 'principiante':
        return 'Nuevo en el gimnasio o con poca experiencia';
      case 'intermedio':
        return 'Experiencia moderada con entrenamientos regulares';
      case 'avanzado':
        return 'Experiencia avanzada con rutinas intensas';
      default:
        return 'Sin definir';
    }
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
      'weeklyPlan': weeklyPlan,
      'muscleMassPercentage': muscleMassPercentage,
      'fitnessLevel': fitnessLevel,
      'currentRoutineId': currentRoutineId,
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
      weeklyPlan: (json['weeklyPlan'] as Map?)?.map((k, v) => MapEntry(k as String, v as String)),
      muscleMassPercentage: json['muscleMassPercentage'] as double? ?? 0.0,
      fitnessLevel: json['fitnessLevel'] as String?,
      currentRoutineId: json['currentRoutineId'] as String?,
    );
  }
} 