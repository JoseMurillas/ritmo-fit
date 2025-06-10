import 'package:ritmo_fit/models/workout_model.dart';
import 'package:uuid/uuid.dart';

class WorkoutService {
  static WorkoutRoutine generateRoutine({
    required String gender,
    required String bmiCategory,
    required String targetMuscleGroup,
    required int age,
    required double bmi,
  }) {
    final ageCategory = _getAgeCategory(age);
    final exercises = _getExercisesForCategory(
      gender: gender,
      bmiCategory: bmiCategory,
      targetMuscleGroup: targetMuscleGroup,
      ageCategory: ageCategory,
      bmi: bmi,
    );

    return WorkoutRoutine(
      id: const Uuid().v4(),
      name: _getRoutineName(gender, bmiCategory, targetMuscleGroup, ageCategory),
      description: _getRoutineDescription(gender, bmiCategory, targetMuscleGroup, ageCategory),
      targetMuscleGroup: targetMuscleGroup,
      difficulty: _getDifficultyLevel(bmiCategory, ageCategory),
      exercises: exercises,
    );
  }

  static String _getAgeCategory(int age) {
    if (age < 18) return 'Adolescente';
    if (age < 30) return 'Joven';
    if (age < 50) return 'Adulto';
    if (age < 65) return 'Maduro';
    return 'Senior';
  }

  static String _getRoutineName(String gender, String bmiCategory, String targetMuscleGroup, String ageCategory) {
    final prefix = gender == 'M' ? 'Masculino' : 'Femenino';
    final category = bmiCategory == 'Bajo peso' ? 'Ganancia Muscular' :
                    bmiCategory == 'Sobrepeso' ? 'Pérdida de Peso' :
                    bmiCategory == 'Obesidad' ? 'Quema de Grasa' :
                    'Mantenimiento';
    
    return '$prefix $ageCategory - $category - $targetMuscleGroup';
  }

  static String _getRoutineDescription(String gender, String bmiCategory, String targetMuscleGroup, String ageCategory) {
    final intensity = _getIntensityLevel(bmiCategory, ageCategory);
    final focus = bmiCategory == 'Bajo peso' ? 'ganancia de masa muscular' :
                 bmiCategory == 'Sobrepeso' ? 'pérdida de peso y tonificación' :
                 bmiCategory == 'Obesidad' ? 'quema de grasa y cardio' :
                 'mantenimiento y fuerza';
    
    return 'Rutina de $targetMuscleGroup con intensidad $intensity, diseñada para ${gender == 'M' ? 'hombres' : 'mujeres'} en el rango $ageCategory, enfocada en $focus.';
  }

  static String _getIntensityLevel(String bmiCategory, String ageCategory) {
    // Ajustar intensidad según edad y IMC
    if (ageCategory == 'Senior' || ageCategory == 'Adolescente') {
      return 'baja a moderada';
    }
    
    return bmiCategory == 'Bajo peso' ? 'alta' :
           bmiCategory == 'Sobrepeso' ? 'moderada a alta' :
           bmiCategory == 'Obesidad' ? 'moderada' :
           'media a alta';
  }

  static String _getDifficultyLevel(String bmiCategory, String ageCategory) {
    // Ajustar dificultad según edad
    if (ageCategory == 'Senior') return 'Principiante';
    if (ageCategory == 'Adolescente') return 'Principiante';
    
    return bmiCategory == 'Bajo peso' ? 'Intermedio' :
           bmiCategory == 'Sobrepeso' ? 'Principiante' :
           bmiCategory == 'Obesidad' ? 'Principiante' :
           'Intermedio';
  }

  static List<WorkoutExercise> _getExercisesForCategory({
    required String gender,
    required String bmiCategory,
    required String targetMuscleGroup,
    required String ageCategory,
    required double bmi,
  }) {
    final exercises = <WorkoutExercise>[];
    final isCardioFocus = bmiCategory == 'Sobrepeso' || bmiCategory == 'Obesidad';
    final isLowImpact = ageCategory == 'Senior' || bmi > 30;
    final isBeginner = ageCategory == 'Adolescente' || ageCategory == 'Senior';
    
    switch (targetMuscleGroup) {
      case 'Piernas':
        exercises.addAll(_getPiernaExercises(gender, bmiCategory, ageCategory, isCardioFocus, isLowImpact, isBeginner));
        break;
      case 'Brazos':
        exercises.addAll(_getBrazosExercises(gender, bmiCategory, ageCategory, isCardioFocus, isLowImpact, isBeginner));
        break;
      case 'Pecho':
        exercises.addAll(_getPechoExercises(gender, bmiCategory, ageCategory, isCardioFocus, isLowImpact, isBeginner));
        break;
      case 'Hombros':
        exercises.addAll(_getHombrosExercises(gender, bmiCategory, ageCategory, isCardioFocus, isLowImpact, isBeginner));
        break;
      case 'Espalda':
        exercises.addAll(_getEspaldaExercises(gender, bmiCategory, ageCategory, isCardioFocus, isLowImpact, isBeginner));
        break;
      case 'Core':
        exercises.addAll(_getCoreExercises(gender, bmiCategory, ageCategory, isCardioFocus, isLowImpact, isBeginner));
        break;
      default:
        exercises.addAll(_getFullBodyExercises(gender, bmiCategory, ageCategory, isCardioFocus, isLowImpact, isBeginner));
    }

    return exercises;
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
          status: 'pending',
        ),
        WorkoutExercise(
          id: const Uuid().v4(),
          name: 'Elevación de Talones',
          description: 'Ejercicio para pantorrillas',
          sets: 3,
          reps: 15,
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
          status: 'pending',
        ),
        WorkoutExercise(
          id: const Uuid().v4(),
          name: 'Peso Muerto',
          description: 'Ejercicio para espalda baja y piernas',
          sets: isBeginner ? 2 : 3,
          reps: isBeginner ? 8 : 12,
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
          reps: 60, // segundos
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
        status: 'pending',
      ),
      WorkoutExercise(
        id: const Uuid().v4(),
        name: isLowImpact ? 'Extensiones de Tríceps Sentado' : 'Extensiones de Tríceps',
        description: 'Ejercicio para tríceps',
        sets: isBeginner ? 2 : 3,
        reps: reps,
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
          status: 'pending',
        ),
        WorkoutExercise(
          id: const Uuid().v4(),
          name: 'Press de Pecho con Banda',
          description: 'Ejercicio con banda elástica',
          sets: 3,
          reps: 12,
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
          status: 'pending',
        ),
        WorkoutExercise(
          id: const Uuid().v4(),
          name: 'Flexiones',
          description: 'Ejercicio corporal para pecho',
          sets: 3,
          reps: gender == 'M' ? 12 : 8,
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
        status: 'pending',
      ),
      WorkoutExercise(
        id: const Uuid().v4(),
        name: isLowImpact ? 'Press de Hombros Sentado' : 'Press Militar',
        description: 'Ejercicio principal para hombros',
        sets: isBeginner ? 2 : 3,
        reps: isBeginner ? 8 : 10,
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
        status: 'pending',
      ),
      WorkoutExercise(
        id: const Uuid().v4(),
        name: 'Extensiones de Espalda',
        description: 'Ejercicio para espalda baja',
        sets: 2,
        reps: 10,
        status: 'pending',
      ),
    ]);

    if (!isLowImpact && !isBeginner) {
      exercises.add(
        WorkoutExercise(
          id: const Uuid().v4(),
          name: 'Dominadas Asistidas',
          description: 'Ejercicio compuesto para espalda',
          sets: 2,
          reps: gender == 'M' ? 6 : 4,
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
        name: isLowImpact ? 'Plancha Modificada' : 'Plancha',
        description: isLowImpact ? 'Plancha desde rodillas' : 'Ejercicio para core',
        sets: isBeginner ? 2 : 3,
        reps: 1, // tiempo en segundos
        status: 'pending',
      ),
      WorkoutExercise(
        id: const Uuid().v4(),
        name: 'Abdominales',
        description: 'Ejercicio para abdominales',
        sets: isBeginner ? 2 : 3,
        reps: isBeginner ? 10 : 15,
        status: 'pending',
      ),
    ]);

    if (isCardioFocus && !isLowImpact) {
      exercises.add(
        WorkoutExercise(
          id: const Uuid().v4(),
          name: 'Mountain Climbers',
          description: 'Ejercicio cardio y core',
          sets: 3,
          reps: isBeginner ? 10 : 20,
          status: 'pending',
        ),
      );
    }

    return exercises;
  }

  static List<WorkoutExercise> _getFullBodyExercises(String gender, String bmiCategory, String ageCategory, bool isCardioFocus, bool isLowImpact, bool isBeginner) {
    final exercises = <WorkoutExercise>[];
    
    // Combinación de ejercicios para todo el cuerpo
    exercises.addAll([
      ..._getPiernaExercises(gender, bmiCategory, ageCategory, isCardioFocus, isLowImpact, isBeginner).take(1),
      ..._getBrazosExercises(gender, bmiCategory, ageCategory, isCardioFocus, isLowImpact, isBeginner).take(1),
      ..._getCoreExercises(gender, bmiCategory, ageCategory, isCardioFocus, isLowImpact, isBeginner).take(1),
    ]);

    return exercises;
  }
} 