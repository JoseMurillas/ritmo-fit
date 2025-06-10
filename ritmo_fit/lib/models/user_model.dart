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

  Profile({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.weight,
    required this.height,
    required this.routines,
    this.weeklyPlan,
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
      'weeklyPlan': weeklyPlan,
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
    );
  }
} 