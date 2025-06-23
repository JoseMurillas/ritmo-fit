import 'dart:math';
import 'package:uuid/uuid.dart';
import 'package:ritmo_fit/models/user_model.dart';
import 'package:ritmo_fit/models/workout_model.dart';

class RoutineGeneratorService {
  static const _uuid = Uuid();

  // Base de datos de ejercicios profesionales expandida
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
      ExerciseTemplate(
        name: 'Flexiones inclinadas (pies elevados)',
        muscleGroup: 'Pecho',
        instructions: 'Apoya los pies en un banco, realiza flexiones para trabajar el pecho superior.',
        sets: 2,
        reps: 8,
        restTime: 90,
        imageUrl: 'https://example.com/incline-pushups.jpg',
        equipment: 'Banco',
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
      ExerciseTemplate(
        name: 'Superman',
        muscleGroup: 'Espalda',
        instructions: 'Acostado boca abajo, levanta simultáneamente brazos y piernas del suelo.',
        sets: 3,
        reps: 15,
        restTime: 60,
        imageUrl: 'https://example.com/superman.jpg',
        equipment: 'Peso corporal',
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
      ExerciseTemplate(
        name: 'Puente de glúteos',
        muscleGroup: 'Piernas',
        instructions: 'Acostado boca arriba, eleva la cadera contrayendo los glúteos.',
        sets: 3,
        reps: 20,
        restTime: 60,
        imageUrl: 'https://example.com/glute-bridge.jpg',
        equipment: 'Peso corporal',
      ),
      ExerciseTemplate(
        name: 'Sentadillas sumo',
        muscleGroup: 'Piernas',
        instructions: 'Pies más anchos que los hombros, dedos hacia afuera, baja manteniendo la espalda recta.',
        sets: 3,
        reps: 12,
        restTime: 90,
        imageUrl: 'https://example.com/sumo-squats.jpg',
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
      ExerciseTemplate(
        name: 'Elevaciones frontales',
        muscleGroup: 'Hombros',
        instructions: 'Levanta las mancuernas hacia adelante hasta la altura de los hombros.',
        sets: 3,
        reps: 12,
        restTime: 60,
        imageUrl: 'https://example.com/front-raises.jpg',
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
      ExerciseTemplate(
        name: 'Fondos en silla',
        muscleGroup: 'Brazos',
        instructions: 'Apoya las manos en una silla, baja y sube el cuerpo usando los tríceps.',
        sets: 3,
        reps: 10,
        restTime: 90,
        imageUrl: 'https://example.com/chair-dips.jpg',
        equipment: 'Silla',
      ),
      
      // Core
      ExerciseTemplate(
        name: 'Plancha',
        muscleGroup: 'Core',
        instructions: 'Mantén el cuerpo recto como una tabla, contrae el abdomen.',
        sets: 3,
        reps: 30,
        restTime: 60,
        imageUrl: 'https://example.com/plank.jpg',
        equipment: 'Peso corporal',
      ),
      ExerciseTemplate(
        name: 'Crunch abdominal',
        muscleGroup: 'Core',
        instructions: 'Acostado boca arriba, levanta los hombros del suelo contrayendo el abdomen.',
        sets: 3,
        reps: 20,
        restTime: 45,
        imageUrl: 'https://example.com/crunches.jpg',
        equipment: 'Peso corporal',
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
      ExerciseTemplate(
        name: 'Press inclinado con mancuernas',
        muscleGroup: 'Pecho',
        instructions: 'En banco inclinado 45°, presiona las mancuernas hacia arriba enfocando el pecho superior.',
        sets: 4,
        reps: 10,
        restTime: 120,
        imageUrl: 'https://example.com/incline-dumbbell-press.jpg',
        equipment: 'Mancuernas',
      ),
      ExerciseTemplate(
        name: 'Fondos en paralelas',
        muscleGroup: 'Pecho',
        instructions: 'Baja controladamente hasta sentir estiramiento en el pecho, empuja hacia arriba.',
        sets: 3,
        reps: 10,
        restTime: 120,
        imageUrl: 'https://example.com/dips.jpg',
        equipment: 'Paralelas',
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
      ExerciseTemplate(
        name: 'Remo con barra',
        muscleGroup: 'Espalda',
        instructions: 'Inclínate 45°, tira de la barra hacia el abdomen bajo manteniendo la espalda recta.',
        sets: 4,
        reps: 10,
        restTime: 120,
        imageUrl: 'https://example.com/barbell-row.jpg',
        equipment: 'Barra olímpica',
      ),
      ExerciseTemplate(
        name: 'Jalones al pecho',
        muscleGroup: 'Espalda',
        instructions: 'Tira de la barra hacia el pecho, contrae las escápulas al final del movimiento.',
        sets: 4,
        reps: 12,
        restTime: 90,
        imageUrl: 'https://example.com/lat-pulldowns.jpg',
        equipment: 'Máquina de poleas',
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
      ExerciseTemplate(
        name: 'Prensa de piernas',
        muscleGroup: 'Piernas',
        instructions: 'Empuja la plataforma con los pies, baja controladamente hasta 90°.',
        sets: 4,
        reps: 12,
        restTime: 120,
        imageUrl: 'https://example.com/leg-press.jpg',
        equipment: 'Máquina de prensa',
      ),
      ExerciseTemplate(
        name: 'Zancadas con mancuernas',
        muscleGroup: 'Piernas',
        instructions: 'Da un paso largo hacia adelante con mancuernas, baja la rodilla trasera.',
        sets: 3,
        reps: 12,
        restTime: 90,
        imageUrl: 'https://example.com/dumbbell-lunges.jpg',
        equipment: 'Mancuernas',
      ),
      ExerciseTemplate(
        name: 'Hip thrust con barra',
        muscleGroup: 'Piernas',
        instructions: 'Espalda apoyada en banco, empuja la cadera hacia arriba activando glúteos.',
        sets: 4,
        reps: 12,
        restTime: 120,
        imageUrl: 'https://example.com/barbell-hip-thrust.jpg',
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
      ExerciseTemplate(
        name: 'Press de hombros con mancuernas',
        muscleGroup: 'Hombros',
        instructions: 'Sentado o de pie, presiona las mancuernas hacia arriba desde los hombros.',
        sets: 4,
        reps: 10,
        restTime: 90,
        imageUrl: 'https://example.com/dumbbell-shoulder-press.jpg',
        equipment: 'Mancuernas',
      ),
      ExerciseTemplate(
        name: 'Elevaciones posteriores',
        muscleGroup: 'Hombros',
        instructions: 'Inclínate hacia adelante, levanta las mancuernas hacia los lados trabajando deltoides posterior.',
        sets: 3,
        reps: 15,
        restTime: 60,
        imageUrl: 'https://example.com/rear-delt-flyes.jpg',
        equipment: 'Mancuernas',
      ),
      
      // Brazos
      ExerciseTemplate(
        name: 'Curl de bíceps con barra',
        muscleGroup: 'Brazos',
        instructions: 'Mantén los codos fijos, levanta la barra flexionando los bíceps.',
        sets: 4,
        reps: 10,
        restTime: 90,
        imageUrl: 'https://example.com/barbell-curl.jpg',
        equipment: 'Barra',
      ),
      ExerciseTemplate(
        name: 'Press francés',
        muscleGroup: 'Brazos',
        instructions: 'Acostado, baja la barra hacia la frente manteniendo los codos fijos.',
        sets: 4,
        reps: 10,
        restTime: 90,
        imageUrl: 'https://example.com/skull-crushers.jpg',
        equipment: 'Barra',
      ),
      ExerciseTemplate(
        name: 'Curl martillo',
        muscleGroup: 'Brazos',
        instructions: 'Levanta las mancuernas manteniendo los pulgares hacia arriba.',
        sets: 3,
        reps: 12,
        restTime: 60,
        imageUrl: 'https://example.com/hammer-curls.jpg',
        equipment: 'Mancuernas',
      ),
      ExerciseTemplate(
        name: 'Extensiones de tríceps con polea',
        muscleGroup: 'Brazos',
        instructions: 'Empuja la cuerda hacia abajo manteniendo los codos fijos.',
        sets: 3,
        reps: 15,
        restTime: 60,
        imageUrl: 'https://example.com/tricep-pushdowns.jpg',
        equipment: 'Máquina de poleas',
      ),
      
      // Core
      ExerciseTemplate(
        name: 'Plancha lateral',
        muscleGroup: 'Core',
        instructions: 'Mantén el cuerpo recto de lado, apoyado en un antebrazo.',
        sets: 3,
        reps: 30,
        restTime: 60,
        imageUrl: 'https://example.com/side-plank.jpg',
        equipment: 'Peso corporal',
      ),
      ExerciseTemplate(
        name: 'Abdominales bicicleta',
        muscleGroup: 'Core',
        instructions: 'Alterna llevando el codo hacia la rodilla opuesta en movimiento de pedaleo.',
        sets: 3,
        reps: 20,
        restTime: 45,
        imageUrl: 'https://example.com/bicycle-crunches.jpg',
        equipment: 'Peso corporal',
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
        name: 'Fondos en paralelas con peso',
        muscleGroup: 'Pecho',
        instructions: 'Agrega peso con cinturón o mancuerna entre las piernas para mayor resistencia.',
        sets: 4,
        reps: 8,
        restTime: 150,
        imageUrl: 'https://example.com/weighted-dips.jpg',
        equipment: 'Paralelas + peso',
      ),
      ExerciseTemplate(
        name: 'Press declinado con barra',
        muscleGroup: 'Pecho',
        instructions: 'En banco declinado, enfoca en la parte inferior del pecho.',
        sets: 4,
        reps: 8,
        restTime: 120,
        imageUrl: 'https://example.com/decline-bench-press.jpg',
        equipment: 'Barra olímpica',
      ),
      ExerciseTemplate(
        name: 'Flexiones con palmada',
        muscleGroup: 'Pecho',
        instructions: 'Flexiones explosivas donde das una palmada en el aire.',
        sets: 3,
        reps: 6,
        restTime: 120,
        imageUrl: 'https://example.com/clap-pushups.jpg',
        equipment: 'Peso corporal',
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
        name: 'Remo Pendlay',
        muscleGroup: 'Espalda',
        instructions: 'Remo explosivo donde la barra toca el suelo en cada repetición.',
        sets: 5,
        reps: 5,
        restTime: 180,
        imageUrl: 'https://example.com/pendlay-row.jpg',
        equipment: 'Barra olímpica',
      ),
      ExerciseTemplate(
        name: 'Dominadas con peso',
        muscleGroup: 'Espalda',
        instructions: 'Agrega peso con cinturón o mancuerna entre las piernas.',
        sets: 4,
        reps: 6,
        restTime: 180,
        imageUrl: 'https://example.com/weighted-pullups.jpg',
        equipment: 'Barra + peso',
      ),
      ExerciseTemplate(
        name: 'Muscle-up',
        muscleGroup: 'Espalda',
        instructions: 'Transición explosiva de dominada a fondo en la barra.',
        sets: 3,
        reps: 3,
        restTime: 180,
        imageUrl: 'https://example.com/muscle-up.jpg',
        equipment: 'Barra de dominadas',
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
        name: 'Sentadillas búlgaras con mancuernas',
        muscleGroup: 'Piernas',
        instructions: 'Pie trasero elevado en banco, baja profundo trabajando una pierna.',
        sets: 4,
        reps: 10,
        restTime: 120,
        imageUrl: 'https://example.com/bulgarian-split-squats.jpg',
        equipment: 'Mancuernas',
      ),
      ExerciseTemplate(
        name: 'Hip Thrust pesado',
        muscleGroup: 'Piernas',
        instructions: 'Hip thrust con barra cargada, enfoque en activación máxima de glúteos.',
        sets: 5,
        reps: 8,
        restTime: 150,
        imageUrl: 'https://example.com/heavy-hip-thrust.jpg',
        equipment: 'Barra olímpica',
      ),
      ExerciseTemplate(
        name: 'Sentadillas pistola',
        muscleGroup: 'Piernas',
        instructions: 'Sentadilla a una pierna, requiere fuerza y equilibrio extremo.',
        sets: 3,
        reps: 5,
        restTime: 120,
        imageUrl: 'https://example.com/pistol-squats.jpg',
        equipment: 'Peso corporal',
      ),
      
      // Hombros
      ExerciseTemplate(
        name: 'Press militar estricto',
        muscleGroup: 'Hombros',
        instructions: 'Press de pie sin impulso de piernas, fuerza pura de hombros.',
        sets: 5,
        reps: 5,
        restTime: 180,
        imageUrl: 'https://example.com/strict-press.jpg',
        equipment: 'Barra olímpica',
      ),
      ExerciseTemplate(
        name: 'Handstand push-ups',
        muscleGroup: 'Hombros',
        instructions: 'Flexiones en posición de parada de manos contra la pared.',
        sets: 3,
        reps: 8,
        restTime: 150,
        imageUrl: 'https://example.com/handstand-pushups.jpg',
        equipment: 'Peso corporal',
      ),
      ExerciseTemplate(
        name: 'Elevaciones laterales 21s',
        muscleGroup: 'Hombros',
        instructions: '7 reps parciales abajo, 7 arriba, 7 completas sin descanso.',
        sets: 3,
        reps: 21,
        restTime: 120,
        imageUrl: 'https://example.com/lateral-raises-21s.jpg',
        equipment: 'Mancuernas',
      ),
      
      // Brazos
      ExerciseTemplate(
        name: 'Curl de bíceps 21s',
        muscleGroup: 'Brazos',
        instructions: '7 reps parciales abajo, 7 arriba, 7 completas sin descanso.',
        sets: 3,
        reps: 21,
        restTime: 120,
        imageUrl: 'https://example.com/bicep-21s.jpg',
        equipment: 'Barra',
      ),
      ExerciseTemplate(
        name: 'Fondos en paralelas para tríceps',
        muscleGroup: 'Brazos',
        instructions: 'Torso más vertical, enfoque en tríceps con peso adicional.',
        sets: 4,
        reps: 10,
        restTime: 120,
        imageUrl: 'https://example.com/tricep-dips-weighted.jpg',
        equipment: 'Paralelas + peso',
      ),
      ExerciseTemplate(
        name: 'Curl concentrado',
        muscleGroup: 'Brazos',
        instructions: 'Sentado, codo apoyado en muslo, curl lento y controlado.',
        sets: 4,
        reps: 12,
        restTime: 60,
        imageUrl: 'https://example.com/concentration-curls.jpg',
        equipment: 'Mancuernas',
      ),
      
      // Core
      ExerciseTemplate(
        name: 'Dragon flags',
        muscleGroup: 'Core',
        instructions: 'Ejercicio avanzado de Bruce Lee, cuerpo recto horizontal.',
        sets: 3,
        reps: 8,
        restTime: 120,
        imageUrl: 'https://example.com/dragon-flags.jpg',
        equipment: 'Banco',
      ),
      ExerciseTemplate(
        name: 'L-sit',
        muscleGroup: 'Core',
        instructions: 'Mantén las piernas extendidas horizontalmente en paralelas.',
        sets: 3,
        reps: 15,
        restTime: 90,
        imageUrl: 'https://example.com/l-sit.jpg',
        equipment: 'Paralelas',
      ),
      ExerciseTemplate(
        name: 'Plancha con peso',
        muscleGroup: 'Core',
        instructions: 'Plancha tradicional con disco en la espalda.',
        sets: 3,
        reps: 45,
        restTime: 90,
        imageUrl: 'https://example.com/weighted-plank.jpg',
        equipment: 'Disco',
      ),
    ],
    
    // Nuevas rutinas especializadas
    'hiit': [
      ExerciseTemplate(
        name: 'Burpees',
        muscleGroup: 'Cardio',
        instructions: 'Desde de pie, baja a plancha, flexión, salta hacia arriba.',
        sets: 4,
        reps: 20,
        restTime: 30,
        imageUrl: 'https://example.com/burpees.jpg',
        equipment: 'Peso corporal',
      ),
      ExerciseTemplate(
        name: 'Mountain climbers',
        muscleGroup: 'Cardio',
        instructions: 'En posición de plancha, alterna llevando las rodillas al pecho.',
        sets: 4,
        reps: 30,
        restTime: 30,
        imageUrl: 'https://example.com/mountain-climbers.jpg',
        equipment: 'Peso corporal',
      ),
      ExerciseTemplate(
        name: 'Jump squats',
        muscleGroup: 'Cardio',
        instructions: 'Sentadillas explosivas con salto al final.',
        sets: 4,
        reps: 15,
        restTime: 30,
        imageUrl: 'https://example.com/jump-squats.jpg',
        equipment: 'Peso corporal',
      ),
      ExerciseTemplate(
        name: 'High knees',
        muscleGroup: 'Cardio',
        instructions: 'Corre en el lugar llevando las rodillas al pecho.',
        sets: 4,
        reps: 30,
        restTime: 30,
        imageUrl: 'https://example.com/high-knees.jpg',
        equipment: 'Peso corporal',
      ),
    ],
    
    'funcional': [
      ExerciseTemplate(
        name: 'Thrusters',
        muscleGroup: 'Funcional',
        instructions: 'Sentadilla frontal combinada con press de hombros.',
        sets: 4,
        reps: 12,
        restTime: 90,
        imageUrl: 'https://example.com/thrusters.jpg',
        equipment: 'Mancuernas',
      ),
      ExerciseTemplate(
        name: 'Turkish get-up',
        muscleGroup: 'Funcional',
        instructions: 'Movimiento complejo desde acostado hasta de pie con kettlebell.',
        sets: 3,
        reps: 5,
        restTime: 120,
        imageUrl: 'https://example.com/turkish-getup.jpg',
        equipment: 'Kettlebell',
      ),
      ExerciseTemplate(
        name: 'Farmer\'s walk',
        muscleGroup: 'Funcional',
        instructions: 'Camina cargando peso pesado en cada mano.',
        sets: 3,
        reps: 30,
        restTime: 90,
        imageUrl: 'https://example.com/farmers-walk.jpg',
        equipment: 'Mancuernas pesadas',
      ),
      ExerciseTemplate(
        name: 'Swing con kettlebell',
        muscleGroup: 'Funcional',
        instructions: 'Impulso explosivo de cadera para elevar la kettlebell.',
        sets: 4,
        reps: 20,
        restTime: 90,
        imageUrl: 'https://example.com/kettlebell-swing.jpg',
        equipment: 'Kettlebell',
      ),
    ],
  };


  static List<WorkoutRoutine> generateRoutinesForProfile(Profile profile) {
    final routines = <WorkoutRoutine>[];
    final level = profile.fitnessLevel.toLowerCase();
    final exercises = _exerciseDatabase[level] ?? _exerciseDatabase['principiante']!;
    
    // Generar rutina de cuerpo completo (para todos los niveles)
    routines.add(_generateFullBodyRoutine(level, exercises, profile));
    
    // Generar rutina HIIT (para todos los niveles)
    routines.add(_generateHIITRoutine(profile));
    
    // Generar rutina de fuerza (solo para intermedio y avanzado)
    if (level != 'principiante') {
      routines.add(_generateStrengthRoutine(level, exercises, profile));
      
      // Rutina funcional para niveles avanzados
      if (level == 'avanzado') {
        routines.add(_generateFunctionalRoutine(profile));
      }
    }
    
    // Generar rutina específica según género y preferencias
    if (profile.gender.toLowerCase().contains('femenino')) {
      routines.add(_generateGlutesAndLegsRoutine(level, exercises, profile));
      // Rutina de tonificación para mujeres
      routines.add(_generateTonificacionRoutine(level, exercises, profile));
    } else {
      routines.add(_generateUpperBodyRoutine(level, exercises, profile));
      // Rutina de masa muscular para hombres
      if (level != 'principiante') {
        routines.add(_generateMassMuscularRoutine(level, exercises, profile));
      }
    }
    
    // Rutina de rehabilitación/movilidad para todos
    routines.add(_generateMobilityRoutine(profile));
    
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

  static WorkoutRoutine _generateHIITRoutine(Profile profile) {
    final hiitExercises = _exerciseDatabase['hiit']!;
    final selectedExercises = hiitExercises.map((e) => _createWorkoutExercise(e)).toList();

    return WorkoutRoutine(
      id: _uuid.v4(),
      name: 'Rutina HIIT - Quema Grasa',
      description: 'Entrenamiento de alta intensidad para quemar grasa y mejorar resistencia cardiovascular.',
      targetMuscleGroup: 'Cardio/Quema grasa',
      difficulty: profile.fitnessLevel,
      exercises: selectedExercises,
      durationWeeks: 4,
      sessionsPerWeek: 3,
      category: 'Cardio',
      tags: ['HIIT', 'Quema grasa', 'Cardio', 'Alta intensidad'],
    );
  }

  static WorkoutRoutine _generateFunctionalRoutine(Profile profile) {
    final functionalExercises = _exerciseDatabase['funcional']!;
    final selectedExercises = functionalExercises.map((e) => _createWorkoutExercise(e)).toList();

    return WorkoutRoutine(
      id: _uuid.v4(),
      name: 'Entrenamiento Funcional',
      description: 'Movimientos naturales que mejoran la fuerza aplicable a la vida diaria.',
      targetMuscleGroup: 'Funcional',
      difficulty: profile.fitnessLevel,
      exercises: selectedExercises,
      durationWeeks: 6,
      sessionsPerWeek: 3,
      category: 'Funcional',
      tags: ['Funcional', 'Movimiento natural', 'Fuerza aplicada', 'CrossTraining'],
    );
  }

  static WorkoutRoutine _generateTonificacionRoutine(String level, List<ExerciseTemplate> exercises, Profile profile) {
    final selectedExercises = <WorkoutExercise>[];
    
    // Enfoque en tonificación: más repeticiones, menos peso
    final toneExercises = exercises.where((e) => 
      ['Piernas', 'Core', 'Brazos'].contains(e.muscleGroup)
    ).toList();
    
    for (var exercise in toneExercises) {
      final modifiedExercise = ExerciseTemplate(
        name: exercise.name,
        muscleGroup: exercise.muscleGroup,
        instructions: exercise.instructions,
        sets: 3,
        reps: exercise.reps + 5, // Más repeticiones para tonificación
        restTime: exercise.restTime - 15, // Menos descanso
        imageUrl: exercise.imageUrl,
        equipment: exercise.equipment,
      );
      selectedExercises.add(_createWorkoutExercise(modifiedExercise));
    }

    return WorkoutRoutine(
      id: _uuid.v4(),
      name: 'Rutina de Tonificación Femenina',
      description: 'Enfocada en tonificar y definir músculos sin ganar volumen excesivo.',
      targetMuscleGroup: 'Tonificación',
      difficulty: level,
      exercises: selectedExercises,
      durationWeeks: 8,
      sessionsPerWeek: 4,
      category: 'Tonificación',
      tags: ['Tonificación', 'Definición', 'Femenino', 'Esculpir'],
    );
  }

  static WorkoutRoutine _generateMassMuscularRoutine(String level, List<ExerciseTemplate> exercises, Profile profile) {
    final selectedExercises = <WorkoutExercise>[];
    
    // Enfoque en masa muscular: menos repeticiones, más peso, más series
    final massExercises = exercises.where((e) => 
      ['Pecho', 'Espalda', 'Piernas', 'Hombros', 'Brazos'].contains(e.muscleGroup)
    ).toList();
    
    for (var exercise in massExercises.take(6)) {
      final modifiedExercise = ExerciseTemplate(
        name: exercise.name,
        muscleGroup: exercise.muscleGroup,
        instructions: exercise.instructions,
        sets: exercise.sets + 1, // Más series
        reps: exercise.reps - 2, // Menos repeticiones (más peso)
        restTime: exercise.restTime + 30, // Más descanso
        imageUrl: exercise.imageUrl,
        equipment: exercise.equipment,
      );
      selectedExercises.add(_createWorkoutExercise(modifiedExercise));
    }

    return WorkoutRoutine(
      id: _uuid.v4(),
      name: 'Rutina de Masa Muscular',
      description: 'Programa intensivo para aumentar volumen y masa muscular.',
      targetMuscleGroup: 'Hipertrofia',
      difficulty: level,
      exercises: selectedExercises,
      durationWeeks: 10,
      sessionsPerWeek: 4,
      category: 'Hipertrofia',
      tags: ['Masa muscular', 'Volumen', 'Hipertrofia', 'Fuerza'],
    );
  }

  static WorkoutRoutine _generateMobilityRoutine(Profile profile) {
    final mobilityExercises = [
      ExerciseTemplate(
        name: 'Estiramiento de isquiotibiales',
        muscleGroup: 'Movilidad',
        instructions: 'Sentado, extiende una pierna y alcanza los dedos del pie.',
        sets: 2,
        reps: 30,
        restTime: 30,
        imageUrl: 'https://example.com/hamstring-stretch.jpg',
        equipment: 'Peso corporal',
      ),
      ExerciseTemplate(
        name: 'Gato-Camello',
        muscleGroup: 'Movilidad',
        instructions: 'En cuatro patas, alterna entre arquear y redondear la espalda.',
        sets: 2,
        reps: 15,
        restTime: 30,
        imageUrl: 'https://example.com/cat-camel.jpg',
        equipment: 'Peso corporal',
      ),
      ExerciseTemplate(
        name: 'Estiramiento de pecho en puerta',
        muscleGroup: 'Movilidad',
        instructions: 'Apoya el brazo en el marco de una puerta y gira el cuerpo.',
        sets: 2,
        reps: 30,
        restTime: 30,
        imageUrl: 'https://example.com/doorway-chest-stretch.jpg',
        equipment: 'Marco de puerta',
      ),
      ExerciseTemplate(
        name: 'Círculos de brazos',
        muscleGroup: 'Movilidad',
        instructions: 'Brazos extendidos, realiza círculos hacia adelante y atrás.',
        sets: 2,
        reps: 20,
        restTime: 30,
        imageUrl: 'https://example.com/arm-circles.jpg',
        equipment: 'Peso corporal',
      ),
      ExerciseTemplate(
        name: 'Rotación de cadera',
        muscleGroup: 'Movilidad',
        instructions: 'De pie, realiza círculos con las caderas en ambas direcciones.',
        sets: 2,
        reps: 15,
        restTime: 30,
        imageUrl: 'https://example.com/hip-circles.jpg',
        equipment: 'Peso corporal',
      ),
    ];

    final selectedExercises = mobilityExercises.map((e) => _createWorkoutExercise(e)).toList();

    return WorkoutRoutine(
      id: _uuid.v4(),
      name: 'Rutina de Movilidad y Estiramiento',
      description: 'Ejercicios para mejorar flexibilidad, movilidad articular y prevenir lesiones.',
      targetMuscleGroup: 'Movilidad',
      difficulty: 'principiante',
      exercises: selectedExercises,
      durationWeeks: 12,
      sessionsPerWeek: 2,
      category: 'Rehabilitación',
      tags: ['Movilidad', 'Flexibilidad', 'Prevención', 'Recuperación'],
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