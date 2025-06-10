import 'package:ritmo_fit/models/user_model.dart';
import 'package:uuid/uuid.dart';

class WorkoutService {
  static WorkoutRoutine generateRoutine({
    required String gender,
    required String bmiCategory,
    required String targetMuscleGroup,
  }) {
    final exercises = _getExercisesForCategory(
      gender: gender,
      bmiCategory: bmiCategory,
      targetMuscleGroup: targetMuscleGroup,
    );

    return WorkoutRoutine(
      id: const Uuid().v4(),
      name: _getRoutineName(gender, bmiCategory, targetMuscleGroup),
      description: _getRoutineDescription(gender, bmiCategory, targetMuscleGroup),
      exercises: exercises,
      targetMuscleGroup: targetMuscleGroup,
      difficulty: _getDifficultyLevel(bmiCategory),
    );
  }

  static String _getRoutineName(String gender, String bmiCategory, String targetMuscleGroup) {
    final prefix = gender == 'M' ? 'Masculino' : 'Femenino';
    final category = bmiCategory == 'Bajo peso' ? 'Ganancia Muscular' :
                    bmiCategory == 'Sobrepeso' ? 'Pérdida de Peso' :
                    'Mantenimiento';
    
    return '$prefix - $category - $targetMuscleGroup';
  }

  static String _getRoutineDescription(String gender, String bmiCategory, String targetMuscleGroup) {
    final intensity = bmiCategory == 'Bajo peso' ? 'alta' :
                     bmiCategory == 'Sobrepeso' ? 'moderada' :
                     'media';
    
    return 'Rutina de $targetMuscleGroup con intensidad $intensity, diseñada para ${gender == 'M' ? 'hombres' : 'mujeres'} con $bmiCategory.';
  }

  static String _getDifficultyLevel(String bmiCategory) {
    return bmiCategory == 'Bajo peso' ? 'Intermedio' :
           bmiCategory == 'Sobrepeso' ? 'Principiante' :
           'Intermedio';
  }

  static List<Exercise> _getExercisesForCategory({
    required String gender,
    required String bmiCategory,
    required String targetMuscleGroup,
  }) {
    final exercises = <Exercise>[];
    
    switch (targetMuscleGroup) {
      case 'Piernas':
        exercises.addAll([
          Exercise(
            id: const Uuid().v4(),
            name: 'Sentadillas',
            description: 'Ejercicio básico para piernas',
            sets: bmiCategory == 'Sobrepeso' ? 3 : 4,
            reps: bmiCategory == 'Sobrepeso' ? 12 : 15,
          ),
          Exercise(
            id: const Uuid().v4(),
            name: 'Peso Muerto',
            description: 'Ejercicio para espalda baja y piernas',
            sets: bmiCategory == 'Sobrepeso' ? 3 : 4,
            reps: bmiCategory == 'Sobrepeso' ? 10 : 12,
          ),
          Exercise(
            id: const Uuid().v4(),
            name: 'Extensiones de Cuádriceps',
            description: 'Ejercicio de aislamiento para cuádriceps',
            sets: 3,
            reps: 15,
          ),
        ]);
        break;

      case 'Brazos':
        exercises.addAll([
          Exercise(
            id: const Uuid().v4(),
            name: 'Curl de Bíceps',
            description: 'Ejercicio para bíceps',
            sets: 3,
            reps: gender == 'M' ? 12 : 15,
          ),
          Exercise(
            id: const Uuid().v4(),
            name: 'Extensiones de Tríceps',
            description: 'Ejercicio para tríceps',
            sets: 3,
            reps: gender == 'M' ? 12 : 15,
          ),
          Exercise(
            id: const Uuid().v4(),
            name: 'Martillo',
            description: 'Ejercicio para antebrazos y bíceps',
            sets: 3,
            reps: 12,
          ),
        ]);
        break;

      case 'Pecho':
        exercises.addAll([
          Exercise(
            id: const Uuid().v4(),
            name: 'Press de Banca',
            description: 'Ejercicio principal para pecho',
            sets: bmiCategory == 'Sobrepeso' ? 3 : 4,
            reps: bmiCategory == 'Sobrepeso' ? 10 : 12,
          ),
          Exercise(
            id: const Uuid().v4(),
            name: 'Aperturas',
            description: 'Ejercicio de aislamiento para pecho',
            sets: 3,
            reps: 15,
          ),
          Exercise(
            id: const Uuid().v4(),
            name: 'Fondos',
            description: 'Ejercicio compuesto para pecho y tríceps',
            sets: 3,
            reps: gender == 'M' ? 12 : 10,
          ),
        ]);
        break;

      case 'Hombros':
        exercises.addAll([
          Exercise(
            id: const Uuid().v4(),
            name: 'Press Militar',
            description: 'Ejercicio principal para hombros',
            sets: 3,
            reps: 12,
          ),
          Exercise(
            id: const Uuid().v4(),
            name: 'Elevaciones Laterales',
            description: 'Ejercicio para deltoides laterales',
            sets: 3,
            reps: 15,
          ),
          Exercise(
            id: const Uuid().v4(),
            name: 'Elevaciones Frontales',
            description: 'Ejercicio para deltoides frontales',
            sets: 3,
            reps: 15,
          ),
        ]);
        break;

      default:
        exercises.addAll([
          Exercise(
            id: const Uuid().v4(),
            name: 'Plancha',
            description: 'Ejercicio para core',
            sets: 3,
            reps: 1,
          ),
          Exercise(
            id: const Uuid().v4(),
            name: 'Abdominales',
            description: 'Ejercicio para abdominales',
            sets: 3,
            reps: 15,
          ),
          Exercise(
            id: const Uuid().v4(),
            name: 'Mountain Climbers',
            description: 'Ejercicio cardio y core',
            sets: 3,
            reps: 20,
          ),
        ]);
    }

    return exercises;
  }
} 