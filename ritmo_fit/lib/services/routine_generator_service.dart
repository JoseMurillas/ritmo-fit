import 'dart:math';
import 'package:uuid/uuid.dart';
import 'package:ritmo_fit/models/user_model.dart';
import 'package:ritmo_fit/models/workout_model.dart';

class RoutineGeneratorService {
  static const _uuid = Uuid();

  // Base de datos de ejercicios profesionales
  static final Map<String, List<ExerciseTemplate>> _exerciseDatabase = {
    'principiante': [
      // Pecho
      ExerciseTemplate(
        name: 'Press de banca con mancuernas',
        muscleGroup: 'Pecho',
        instructions: 'Acuéstate en el banco, baja las mancuernas controladamente hasta el pecho y empuja hacia arriba.',
        sets: 3,
        reps: 12,
        restTime: 90,
        imageUrl: 'https://example.com/dumbbell-press.jpg',
        equipment: 'Mancuernas',
      ),
      ExerciseTemplate(
        name: 'Flexiones de pecho',
        muscleGroup: 'Pecho',
        instructions: 'Mantén el cuerpo recto, baja hasta que el pecho casi toque el suelo.',
        sets: 3,
        reps: 10,
        restTime: 60,
        imageUrl: 'https://example.com/push-ups.jpg',
        equipment: 'Peso corporal',
      ),
      
      // Espalda
      ExerciseTemplate(
        name: 'Remo con mancuernas',
        muscleGroup: 'Espalda',
        instructions: 'Inclínate hacia adelante, tira de las mancuernas hacia el abdomen.',
        sets: 3,
        reps: 12,
        restTime: 90,
        imageUrl: 'https://example.com/dumbbell-row.jpg',
        equipment: 'Mancuernas',
      ),
      ExerciseTemplate(
        name: 'Dominadas asistidas',
        muscleGroup: 'Espalda',
        instructions: 'Usa la máquina de asistencia o banda elástica para completar el movimiento.',
        sets: 3,
        reps: 8,
        restTime: 120,
        imageUrl: 'https://example.com/assisted-pullups.jpg',
        equipment: 'Máquina de dominadas',
      ),
      
      // Piernas
      ExerciseTemplate(
        name: 'Sentadillas con peso corporal',
        muscleGroup: 'Piernas',
        instructions: 'Baja como si fueras a sentarte en una silla invisible, mantén la espalda recta.',
        sets: 3,
        reps: 15,
        restTime: 90,
        imageUrl: 'https://example.com/bodyweight-squats.jpg',
        equipment: 'Peso corporal',
      ),
      ExerciseTemplate(
        name: 'Zancadas',
        muscleGroup: 'Piernas',
        instructions: 'Da un paso largo hacia adelante, baja la rodilla trasera casi hasta el suelo.',
        sets: 3,
        reps: 12,
        restTime: 90,
        imageUrl: 'https://example.com/lunges.jpg',
        equipment: 'Peso corporal',
      ),
      
      // Hombros
      ExerciseTemplate(
        name: 'Press militar con mancuernas',
        muscleGroup: 'Hombros',
        instructions: 'Empuja las mancuernas desde los hombros hacia arriba hasta extender completamente los brazos.',
        sets: 3,
        reps: 12,
        restTime: 90,
        imageUrl: 'https://example.com/shoulder-press.jpg',
        equipment: 'Mancuernas',
      ),
      
      // Brazos
      ExerciseTemplate(
        name: 'Curl de bíceps',
        muscleGroup: 'Brazos',
        instructions: 'Mantén los codos pegados al cuerpo, levanta las mancuernas flexionando los bíceps.',
        sets: 3,
        reps: 12,
        restTime: 60,
        imageUrl: 'https://example.com/bicep-curl.jpg',
        equipment: 'Mancuernas',
      ),
      ExerciseTemplate(
        name: 'Extensiones de tríceps',
        muscleGroup: 'Brazos',
        instructions: 'Mantén los codos fijos, extiende los brazos hacia arriba.',
        sets: 3,
        reps: 12,
        restTime: 60,
        imageUrl: 'https://example.com/tricep-extension.jpg',
        equipment: 'Mancuernas',
      ),
    ],
    
    'intermedio': [
      // Pecho
      ExerciseTemplate(
        name: 'Press de banca con barra',
        muscleGroup: 'Pecho',
        instructions: 'Controla la bajada de la barra hasta el pecho, empuja explosivamente hacia arriba.',
        sets: 4,
        reps: 10,
        restTime: 120,
        imageUrl: 'https://example.com/barbell-bench-press.jpg',
        equipment: 'Barra olímpica',
      ),
      ExerciseTemplate(
        name: 'Aperturas con mancuernas',
        muscleGroup: 'Pecho',
        instructions: 'Abre los brazos en arco, siente el estiramiento en el pecho, vuelve controladamente.',
        sets: 3,
        reps: 12,
        restTime: 90,
        imageUrl: 'https://example.com/chest-flyes.jpg',
        equipment: 'Mancuernas',
      ),
      
      // Espalda
      ExerciseTemplate(
        name: 'Peso muerto',
        muscleGroup: 'Espalda',
        instructions: 'Mantén la espalda recta, levanta la barra desde el suelo hasta la cadera.',
        sets: 4,
        reps: 8,
        restTime: 180,
        imageUrl: 'https://example.com/deadlift.jpg',
        equipment: 'Barra olímpica',
      ),
      ExerciseTemplate(
        name: 'Dominadas',
        muscleGroup: 'Espalda',
        instructions: 'Tira de tu cuerpo hacia arriba hasta que la barbilla supere la barra.',
        sets: 4,
        reps: 8,
        restTime: 120,
        imageUrl: 'https://example.com/pull-ups.jpg',
        equipment: 'Barra de dominadas',
      ),
      
      // Piernas
      ExerciseTemplate(
        name: 'Sentadillas con barra',
        muscleGroup: 'Piernas',
        instructions: 'Baja controladamente hasta que los muslos estén paralelos al suelo.',
        sets: 4,
        reps: 10,
        restTime: 180,
        imageUrl: 'https://example.com/barbell-squats.jpg',
        equipment: 'Barra olímpica',
      ),
      ExerciseTemplate(
        name: 'Peso muerto rumano',
        muscleGroup: 'Piernas',
        instructions: 'Enfoca en los glúteos e isquiotibiales, mantén las piernas ligeramente flexionadas.',
        sets: 4,
        reps: 10,
        restTime: 120,
        imageUrl: 'https://example.com/romanian-deadlift.jpg',
        equipment: 'Barra olímpica',
      ),
      
      // Hombros
      ExerciseTemplate(
        name: 'Press militar de pie',
        muscleGroup: 'Hombros',
        instructions: 'Mantén el core activo, empuja la barra desde los hombros hacia arriba.',
        sets: 4,
        reps: 8,
        restTime: 120,
        imageUrl: 'https://example.com/overhead-press.jpg',
        equipment: 'Barra olímpica',
      ),
      ExerciseTemplate(
        name: 'Elevaciones laterales',
        muscleGroup: 'Hombros',
        instructions: 'Levanta las mancuernas hacia los lados hasta la altura de los hombros.',
        sets: 3,
        reps: 15,
        restTime: 60,
        imageUrl: 'https://example.com/lateral-raises.jpg',
        equipment: 'Mancuernas',
      ),
    ],
    
    'avanzado': [
      // Pecho
      ExerciseTemplate(
        name: 'Press de banca inclinado',
        muscleGroup: 'Pecho',
        instructions: 'En banco inclinado 30-45°, enfoca en la parte superior del pecho.',
        sets: 5,
        reps: 6,
        restTime: 180,
        imageUrl: 'https://example.com/incline-bench-press.jpg',
        equipment: 'Barra olímpica',
      ),
      ExerciseTemplate(
        name: 'Fondos en paralelas',
        muscleGroup: 'Pecho',
        instructions: 'Baja controladamente hasta sentir estiramiento en el pecho, empuja hacia arriba.',
        sets: 4,
        reps: 12,
        restTime: 120,
        imageUrl: 'https://example.com/dips.jpg',
        equipment: 'Paralelas',
      ),
      
      // Espalda
      ExerciseTemplate(
        name: 'Peso muerto sumo',
        muscleGroup: 'Espalda',
        instructions: 'Pies anchos, dedos hacia afuera, levanta la barra manteniendo la espalda neutra.',
        sets: 5,
        reps: 5,
        restTime: 240,
        imageUrl: 'https://example.com/sumo-deadlift.jpg',
        equipment: 'Barra olímpica',
      ),
      ExerciseTemplate(
        name: 'Remo con barra',
        muscleGroup: 'Espalda',
        instructions: 'Inclínate 45°, tira de la barra hacia el abdomen bajo.',
        sets: 4,
        reps: 8,
        restTime: 120,
        imageUrl: 'https://example.com/barbell-row.jpg',
        equipment: 'Barra olímpica',
      ),
      
      // Piernas
      ExerciseTemplate(
        name: 'Sentadillas frontales',
        muscleGroup: 'Piernas',
        instructions: 'Barra en la parte frontal de los hombros, mantén el torso erguido.',
        sets: 5,
        reps: 6,
        restTime: 180,
        imageUrl: 'https://example.com/front-squats.jpg',
        equipment: 'Barra olímpica',
      ),
      ExerciseTemplate(
        name: 'Hip Thrust',
        muscleGroup: 'Piernas',
        instructions: 'Espalda apoyada en banco, empuja la cadera hacia arriba activando glúteos.',
        sets: 4,
        reps: 10,
        restTime: 120,
        imageUrl: 'https://example.com/hip-thrust.jpg',
        equipment: 'Barra olímpica',
      ),
    ],
  };


  static List<WorkoutRoutine> generateRoutinesForProfile(Profile profile) {
    final routines = <WorkoutRoutine>[];
    final level = profile.fitnessLevel;
    final exercises = _exerciseDatabase[level] ?? _exerciseDatabase['principiante']!;
    
    // Generar rutina de cuerpo completo
    routines.add(_generateFullBodyRoutine(level, exercises, profile));
    
    // Generar rutina de fuerza (solo para intermedio y avanzado)
    if (level != 'principiante') {
      routines.add(_generateStrengthRoutine(level, exercises, profile));
    }
    
    // Generar rutina específica según género
    if (profile.gender.toLowerCase() == 'femenino') {
      routines.add(_generateGlutesAndLegsRoutine(level, exercises, profile));
    } else {
      routines.add(_generateUpperBodyRoutine(level, exercises, profile));
    }
    
    return routines;
  }

  static WorkoutRoutine _generateFullBodyRoutine(String level, List<ExerciseTemplate> exercises, Profile profile) {
    final selectedExercises = <WorkoutExercise>[];
    final muscleGroups = ['Pecho', 'Espalda', 'Piernas', 'Hombros', 'Brazos'];
    
    for (final group in muscleGroups) {
      final groupExercises = exercises.where((e) => e.muscleGroup == group).toList();
      if (groupExercises.isNotEmpty) {
        final exercise = groupExercises[Random().nextInt(groupExercises.length)];
        selectedExercises.add(_createWorkoutExercise(exercise));
      }
    }

    return WorkoutRoutine(
      id: _uuid.v4(),
      name: 'Rutina de Cuerpo Completo - ${level.toUpperCase()}',
      description: 'Rutina balanceada que trabaja todos los grupos musculares principales en una sola sesión.',
      targetMuscleGroup: 'Todo el cuerpo',
      difficulty: level,
      exercises: selectedExercises,
      durationWeeks: level == 'principiante' ? 6 : 4,
      sessionsPerWeek: level == 'principiante' ? 3 : 4,
      category: 'Cuerpo Completo',
      tags: ['Fuerza', 'Masa muscular', 'Acondicionamiento'],
    );
  }

  static WorkoutRoutine _generateStrengthRoutine(String level, List<ExerciseTemplate> exercises, Profile profile) {
    final selectedExercises = <WorkoutExercise>[];
    
    // Ejercicios principales de fuerza
    final strengthExercises = exercises.where((e) => 
      ['Press de banca con barra', 'Peso muerto', 'Sentadillas con barra', 'Press militar de pie']
        .contains(e.name)
    ).toList();
    
    selectedExercises.addAll(strengthExercises.map((e) => _createWorkoutExercise(e)));
    
    // Agregar ejercicios accesorios
    final accessoryExercises = exercises.where((e) => 
      !strengthExercises.contains(e) && 
      ['Espalda', 'Brazos'].contains(e.muscleGroup)
    ).take(3).toList();
    
    selectedExercises.addAll(accessoryExercises.map((e) => _createWorkoutExercise(e)));

    return WorkoutRoutine(
      id: _uuid.v4(),
      name: 'Rutina de Fuerza - ${level.toUpperCase()}',
      description: 'Enfocada en desarrollar fuerza máxima con ejercicios compuestos principales.',
      targetMuscleGroup: 'Fuerza general',
      difficulty: level,
      exercises: selectedExercises,
      durationWeeks: 8,
      sessionsPerWeek: 3,
      category: 'Fuerza',
      tags: ['Fuerza máxima', 'Powerlifting', 'Ejercicios compuestos'],
    );
  }

  static WorkoutRoutine _generateGlutesAndLegsRoutine(String level, List<ExerciseTemplate> exercises, Profile profile) {
    final selectedExercises = <WorkoutExercise>[];
    
    // Enfocar en piernas y glúteos
    final legExercises = exercises.where((e) => e.muscleGroup == 'Piernas').toList();
    selectedExercises.addAll(legExercises.map((e) => _createWorkoutExercise(e)));
    
    // Agregar algunos ejercicios de tren superior para balance
    final upperExercises = exercises.where((e) => 
      ['Pecho', 'Espalda'].contains(e.muscleGroup)
    ).take(2).toList();
    
    selectedExercises.addAll(upperExercises.map((e) => _createWorkoutExercise(e)));

    return WorkoutRoutine(
      id: _uuid.v4(),
      name: 'Rutina Piernas y Glúteos - ${level.toUpperCase()}',
      description: 'Rutina especializada en desarrollo de piernas y glúteos con enfoque femenino.',
      targetMuscleGroup: 'Piernas y Glúteos',
      difficulty: level,
      exercises: selectedExercises,
      durationWeeks: 6,
      sessionsPerWeek: 4,
      category: 'Especializada',
      tags: ['Glúteos', 'Piernas', 'Tonificación', 'Fuerza funcional'],
    );
  }

  static WorkoutRoutine _generateUpperBodyRoutine(String level, List<ExerciseTemplate> exercises, Profile profile) {
    final selectedExercises = <WorkoutExercise>[];
    
    // Enfocar en tren superior
    final upperExercises = exercises.where((e) => 
      ['Pecho', 'Espalda', 'Hombros', 'Brazos'].contains(e.muscleGroup)
    ).toList();
    
    selectedExercises.addAll(upperExercises.map((e) => _createWorkoutExercise(e)));
    
    // Agregar una pierna para balance
    final legExercise = exercises.where((e) => e.muscleGroup == 'Piernas').first;
    selectedExercises.add(_createWorkoutExercise(legExercise));

    return WorkoutRoutine(
      id: _uuid.v4(),
      name: 'Rutina Tren Superior - ${level.toUpperCase()}',
      description: 'Rutina especializada en desarrollo del tren superior: pecho, espalda, hombros y brazos.',
      targetMuscleGroup: 'Tren Superior',
      difficulty: level,
      exercises: selectedExercises,
      durationWeeks: 6,
      sessionsPerWeek: 4,
      category: 'Especializada',
      tags: ['Tren superior', 'Masa muscular', 'Definición'],
    );
  }

  static WorkoutExercise _createWorkoutExercise(ExerciseTemplate template) {
    return WorkoutExercise(
      id: _uuid.v4(),
      name: template.name,
      description: template.instructions,
      sets: template.sets,
      reps: template.reps,
      muscleGroup: template.muscleGroup,
      instructions: template.instructions,
      imageUrl: template.imageUrl,
      restTimeSeconds: template.restTime,
      equipment: template.equipment,
    );
  }
}

class ExerciseTemplate {
  final String name;
  final String muscleGroup;
  final String instructions;
  final int sets;
  final int reps;
  final int restTime;
  final String imageUrl;
  final String equipment;

  ExerciseTemplate({
    required this.name,
    required this.muscleGroup,
    required this.instructions,
    required this.sets,
    required this.reps,
    required this.restTime,
    required this.imageUrl,
    required this.equipment,
  });
} 