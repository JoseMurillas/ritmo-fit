import 'package:uuid/uuid.dart';
import 'package:ritmo_fit/models/workout_model.dart';

class WorkoutService {
  static List<WorkoutExercise> generateExercises({
    required String targetMuscleGroup,
    required String userGender,
    required String userBMICategory,
    required String userAgeCategory,
    required bool isCardioFocus,
    required bool isLowImpact,
    required bool isBeginner,
  }) {
    switch (targetMuscleGroup.toLowerCase()) {
      case 'piernas':
        return _getPiernaExercises(userGender, userBMICategory, userAgeCategory, isCardioFocus, isLowImpact, isBeginner);
      case 'brazos':
        return _getBrazosExercises(userGender, userBMICategory, userAgeCategory, isCardioFocus, isLowImpact, isBeginner);
      case 'pecho':
        return _getPechoExercises(userGender, userBMICategory, userAgeCategory, isCardioFocus, isLowImpact, isBeginner);
      case 'hombros':
        return _getHombrosExercises(userGender, userBMICategory, userAgeCategory, isCardioFocus, isLowImpact, isBeginner);
      case 'espalda':
        return _getEspaldaExercises(userGender, userBMICategory, userAgeCategory, isCardioFocus, isLowImpact, isBeginner);
      case 'core':
        return _getCoreExercises(userGender, userBMICategory, userAgeCategory, isCardioFocus, isLowImpact, isBeginner);
      case 'full body':
        return _getFullBodyExercises(userGender, userBMICategory, userAgeCategory, isCardioFocus, isLowImpact, isBeginner);
      default:
        return _getFullBodyExercises(userGender, userBMICategory, userAgeCategory, isCardioFocus, isLowImpact, isBeginner);
    }
  }

  static List<WorkoutExercise> _getPiernaExercises(String gender, String bmiCategory, String ageCategory, bool isCardioFocus, bool isLowImpact, bool isBeginner) {
    final exercises = <WorkoutExercise>[];
    
    if (isLowImpact) {
      exercises.addAll([
        WorkoutExercise(
          id: const Uuid().v4(),
          name: 'Sentadillas en Silla',
          description: 'Sentadillas asistidas con silla para bajo impacto',
          sets: 2,
          reps: 10,
          muscleGroup: 'Piernas',
          status: 'pending',
        ),
        WorkoutExercise(
          id: const Uuid().v4(),
          name: 'Elevación de Talones',
          description: 'Ejercicio para pantorrillas',
          sets: 3,
          reps: 15,
          muscleGroup: 'Piernas',
          status: 'pending',
        ),
      ]);
    } else {
      exercises.addAll([
        WorkoutExercise(
          id: const Uuid().v4(),
          name: 'Sentadillas',
          description: 'Ejercicio básico para piernas',
          sets: isBeginner ? 3 : 4,
          reps: bmiCategory == 'Sobrepeso' ? 12 : (isBeginner ? 10 : 15),
          muscleGroup: 'Piernas',
          status: 'pending',
        ),
        WorkoutExercise(
          id: const Uuid().v4(),
          name: 'Peso Muerto',
          description: 'Ejercicio para espalda baja y piernas',
          sets: isBeginner ? 2 : 3,
          reps: isBeginner ? 8 : 12,
          muscleGroup: 'Piernas',
          status: 'pending',
        ),
      ]);
    }

    if (isCardioFocus) {
      exercises.add(
        WorkoutExercise(
          id: const Uuid().v4(),
          name: 'Caminar en el Lugar',
          description: 'Cardio de bajo impacto',
          sets: 1,
          reps: 60,
          muscleGroup: 'Piernas',
          status: 'pending',
        ),
      );
    }

    return exercises;
  }

  static List<WorkoutExercise> _getBrazosExercises(String gender, String bmiCategory, String ageCategory, bool isCardioFocus, bool isLowImpact, bool isBeginner) {
    final exercises = <WorkoutExercise>[];
    final reps = gender == 'M' ? (isBeginner ? 8 : 12) : (isBeginner ? 6 : 10);
    
    exercises.addAll([
      WorkoutExercise(
        id: const Uuid().v4(),
        name: isLowImpact ? 'Curl de Bíceps con Banda' : 'Curl de Bíceps',
        description: isLowImpact ? 'Ejercicio con banda elástica' : 'Ejercicio para bíceps con mancuernas',
        sets: isBeginner ? 2 : 3,
        reps: reps,
        muscleGroup: 'Brazos',
        status: 'pending',
      ),
      WorkoutExercise(
        id: const Uuid().v4(),
        name: isLowImpact ? 'Extensiones de Tríceps Sentado' : 'Extensiones de Tríceps',
        description: 'Ejercicio para tríceps',
        sets: isBeginner ? 2 : 3,
        reps: reps,
        muscleGroup: 'Brazos',
        status: 'pending',
      ),
    ]);

    if (!isLowImpact && !isBeginner) {
      exercises.add(
        WorkoutExercise(
          id: const Uuid().v4(),
          name: 'Martillo',
          description: 'Ejercicio para antebrazos y bíceps',
          sets: 3,
          reps: 12,
          muscleGroup: 'Brazos',
          status: 'pending',
        ),
      );
    }

    return exercises;
  }

  static List<WorkoutExercise> _getPechoExercises(String gender, String bmiCategory, String ageCategory, bool isCardioFocus, bool isLowImpact, bool isBeginner) {
    final exercises = <WorkoutExercise>[];
    
    if (isLowImpact || isBeginner) {
      exercises.addAll([
        WorkoutExercise(
          id: const Uuid().v4(),
          name: 'Flexiones de Rodillas',
          description: 'Flexiones modificadas para principiantes',
          sets: 2,
          reps: gender == 'M' ? 8 : 5,
          muscleGroup: 'Pecho',
          status: 'pending',
        ),
        WorkoutExercise(
          id: const Uuid().v4(),
          name: 'Press de Pecho con Banda',
          description: 'Ejercicio con banda elástica',
          sets: 3,
          reps: 12,
          muscleGroup: 'Pecho',
          status: 'pending',
        ),
      ]);
    } else {
      exercises.addAll([
        WorkoutExercise(
          id: const Uuid().v4(),
          name: 'Press de Banca',
          description: 'Ejercicio principal para pecho',
          sets: bmiCategory == 'Sobrepeso' ? 3 : 4,
          reps: bmiCategory == 'Sobrepeso' ? 10 : 12,
          muscleGroup: 'Pecho',
          status: 'pending',
        ),
        WorkoutExercise(
          id: const Uuid().v4(),
          name: 'Flexiones',
          description: 'Ejercicio corporal para pecho',
          sets: 3,
          reps: gender == 'M' ? 12 : 8,
          muscleGroup: 'Pecho',
          status: 'pending',
        ),
      ]);
    }

    return exercises;
  }

  static List<WorkoutExercise> _getHombrosExercises(String gender, String bmiCategory, String ageCategory, bool isCardioFocus, bool isLowImpact, bool isBeginner) {
    final exercises = <WorkoutExercise>[];
    
    exercises.addAll([
      WorkoutExercise(
        id: const Uuid().v4(),
        name: isLowImpact ? 'Elevaciones Laterales Sentado' : 'Elevaciones Laterales',
        description: 'Ejercicio para deltoides laterales',
        sets: isBeginner ? 2 : 3,
        reps: 12,
        muscleGroup: 'Hombros',
        status: 'pending',
      ),
      WorkoutExercise(
        id: const Uuid().v4(),
        name: isLowImpact ? 'Press de Hombros Sentado' : 'Press Militar',
        description: 'Ejercicio principal para hombros',
        sets: isBeginner ? 2 : 3,
        reps: isBeginner ? 8 : 10,
        muscleGroup: 'Hombros',
        status: 'pending',
      ),
    ]);

    if (!isBeginner) {
      exercises.add(
        WorkoutExercise(
          id: const Uuid().v4(),
          name: 'Elevaciones Frontales',
          description: 'Ejercicio para deltoides frontales',
          sets: 3,
          reps: 15,
          muscleGroup: 'Hombros',
          status: 'pending',
        ),
      );
    }

    return exercises;
  }

  static List<WorkoutExercise> _getEspaldaExercises(String gender, String bmiCategory, String ageCategory, bool isCardioFocus, bool isLowImpact, bool isBeginner) {
    final exercises = <WorkoutExercise>[];
    
    exercises.addAll([
      WorkoutExercise(
        id: const Uuid().v4(),
        name: isLowImpact ? 'Remo Sentado con Banda' : 'Remo con Mancuernas',
        description: 'Ejercicio para dorsales',
        sets: isBeginner ? 2 : 3,
        reps: 12,
        muscleGroup: 'Espalda',
        status: 'pending',
      ),
      WorkoutExercise(
        id: const Uuid().v4(),
        name: 'Extensiones de Espalda',
        description: 'Ejercicio para espalda baja',
        sets: 2,
        reps: 10,
        muscleGroup: 'Espalda',
        status: 'pending',
      ),
    ]);

    if (!isLowImpact && !isBeginner) {
      exercises.add(
        WorkoutExercise(
          id: const Uuid().v4(),
          name: 'Dominadas Asistidas',
          description: 'Ejercicio para dorsales con asistencia',
          sets: 3,
          reps: 8,
          muscleGroup: 'Espalda',
          status: 'pending',
        ),
      );
    }

    return exercises;
  }

  static List<WorkoutExercise> _getCoreExercises(String gender, String bmiCategory, String ageCategory, bool isCardioFocus, bool isLowImpact, bool isBeginner) {
    final exercises = <WorkoutExercise>[];
    
    exercises.addAll([
      WorkoutExercise(
        id: const Uuid().v4(),
        name: isLowImpact ? 'Plank Modificado' : 'Plank',
        description: 'Ejercicio de estabilidad del core',
        sets: 3,
        reps: isBeginner ? 20 : 45,
        muscleGroup: 'Core',
        status: 'pending',
      ),
      WorkoutExercise(
        id: const Uuid().v4(),
        name: 'Abdominales',
        description: 'Ejercicio básico para abdominales',
        sets: isBeginner ? 2 : 3,
        reps: isBeginner ? 10 : 20,
        muscleGroup: 'Core',
        status: 'pending',
      ),
    ]);

    if (!isLowImpact) {
      exercises.add(
        WorkoutExercise(
          id: const Uuid().v4(),
          name: 'Mountain Climbers',
          description: 'Ejercicio cardio para core',
          sets: 3,
          reps: 20,
          muscleGroup: 'Core',
          status: 'pending',
        ),
      );
    }

    return exercises;
  }

  static List<WorkoutExercise> _getFullBodyExercises(String gender, String bmiCategory, String ageCategory, bool isCardioFocus, bool isLowImpact, bool isBeginner) {
    final exercises = <WorkoutExercise>[];
    
    // Combinar ejercicios de todos los grupos musculares
    exercises.addAll(_getPechoExercises(gender, bmiCategory, ageCategory, isCardioFocus, isLowImpact, isBeginner).take(1));
    exercises.addAll(_getEspaldaExercises(gender, bmiCategory, ageCategory, isCardioFocus, isLowImpact, isBeginner).take(1));
    exercises.addAll(_getPiernaExercises(gender, bmiCategory, ageCategory, isCardioFocus, isLowImpact, isBeginner).take(1));
    exercises.addAll(_getHombrosExercises(gender, bmiCategory, ageCategory, isCardioFocus, isLowImpact, isBeginner).take(1));
    exercises.addAll(_getBrazosExercises(gender, bmiCategory, ageCategory, isCardioFocus, isLowImpact, isBeginner).take(1));
    exercises.addAll(_getCoreExercises(gender, bmiCategory, ageCategory, isCardioFocus, isLowImpact, isBeginner).take(1));

    return exercises;
  }
} 