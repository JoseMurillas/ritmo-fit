import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ritmo_fit/providers/workout_provider.dart';
import 'package:ritmo_fit/models/workout_model.dart';

class WorkoutRoutinesScreen extends StatelessWidget {
  const WorkoutRoutinesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Rutinas de Entrenamiento',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Consumer<WorkoutProvider>(
        builder: (context, workoutProvider, child) {
          if (workoutProvider.currentProfile == null) {
            return const Center(
              child: Text('No hay perfil seleccionado'),
            );
          }

          final routines = workoutProvider.currentProfile!.routines;

          if (routines.isEmpty) {
            return _buildEmptyState();
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: routines.length,
            itemBuilder: (context, index) {
              final routine = routines[index];
              final isSelected = workoutProvider.currentRoutine?.id == routine.id;
              
              return _buildRoutineCard(
                context,
                workoutProvider,
                routine,
                isSelected,
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.fitness_center_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 20),
          Text(
            'No hay rutinas disponibles',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Las rutinas se generan automáticamente\nbasadas en tu perfil',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildRoutineCard(
    BuildContext context,
    WorkoutProvider workoutProvider,
    WorkoutRoutine routine,
    bool isSelected,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: isSelected
            ? Border.all(color: Colors.indigo, width: 2)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => _showRoutineDetails(context, workoutProvider, routine),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          routine.name,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[800],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          routine.description,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getDifficultyColor(routine.difficulty).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          routine.difficulty.toUpperCase(),
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: _getDifficultyColor(routine.difficulty),
                          ),
                        ),
                      ),
                      if (isSelected) ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.indigo.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'ACTIVA',
                            style: GoogleFonts.poppins(
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                              color: Colors.indigo,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: routine.tags.map((tag) => _buildTag(tag)).toList(),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _buildRoutineInfo(
                    Icons.fitness_center,
                    '${routine.exercises.length} ejercicios',
                  ),
                  const SizedBox(width: 16),
                  _buildRoutineInfo(
                    Icons.timer,
                    '~${routine.estimatedDurationMinutes} min',
                  ),
                  const SizedBox(width: 16),
                  _buildRoutineInfo(
                    Icons.category,
                    routine.targetMuscleGroup,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _buildRoutineInfo(
                    Icons.event_repeat,
                    '${routine.sessionsPerWeek}x/semana',
                  ),
                  const SizedBox(width: 16),
                  _buildRoutineInfo(
                    Icons.schedule,
                    '${routine.durationWeeks} semanas',
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (!isSelected)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      workoutProvider.setCurrentRoutine(routine);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Rutina "${routine.name}" seleccionada'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Seleccionar Rutina',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTag(String tag) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        tag,
        style: GoogleFonts.poppins(
          fontSize: 11,
          color: Colors.grey[700],
        ),
      ),
    );
  }

  Widget _buildRoutineInfo(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey[500]),
        const SizedBox(width: 4),
        Text(
          text,
          style: GoogleFonts.poppins(
            fontSize: 11,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'principiante':
        return Colors.green;
      case 'intermedio':
        return Colors.orange;
      case 'avanzado':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _showRoutineDetails(
    BuildContext context,
    WorkoutProvider workoutProvider,
    WorkoutRoutine routine,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) {
          return _buildRoutineDetailsSheet(
            context,
            workoutProvider,
            routine,
            scrollController,
          );
        },
      ),
    );
  }

  Widget _buildRoutineDetailsSheet(
    BuildContext context,
    WorkoutProvider workoutProvider,
    WorkoutRoutine routine,
    ScrollController scrollController,
  ) {
    final isSelected = workoutProvider.currentRoutine?.id == routine.id;

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          
          // Header
          Row(
            children: [
              Expanded(
                child: Text(
                  routine.name,
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _getDifficultyColor(routine.difficulty).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  routine.difficulty.toUpperCase(),
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: _getDifficultyColor(routine.difficulty),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          Text(
            routine.description,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[600],
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          
          // Stats
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    '${routine.exercises.length}',
                    'Ejercicios',
                    Icons.fitness_center,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    '${routine.estimatedDurationMinutes}',
                    'Minutos',
                    Icons.timer,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    '${routine.sessionsPerWeek}x',
                    'Por semana',
                    Icons.event_repeat,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          
          // Exercises
          Text(
            'Ejercicios (${routine.exercises.length})',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 12),
          
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              itemCount: routine.exercises.length,
              itemBuilder: (context, index) {
                final exercise = routine.exercises[index];
                return _buildExerciseItem(exercise);
              },
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Actions
          Row(
            children: [
              if (!isSelected) ...[
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.grey),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      'Cerrar',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: () {
                      workoutProvider.setCurrentRoutine(routine);
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Rutina "${routine.name}" seleccionada'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      'Seleccionar Rutina',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ] else ...[
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      'Rutina Activa',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.indigo, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildExerciseItem(WorkoutExercise exercise) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.indigo.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.fitness_center,
              color: Colors.indigo,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  exercise.name,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${exercise.sets} series × ${exercise.reps} reps',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Text(
            exercise.muscleGroup,
            style: GoogleFonts.poppins(
              fontSize: 11,
              color: Colors.indigo,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
} 