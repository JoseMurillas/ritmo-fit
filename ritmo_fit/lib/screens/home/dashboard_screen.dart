import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ritmo_fit/providers/profile_provider.dart';
import 'package:ritmo_fit/providers/workout_provider.dart';
import 'package:ritmo_fit/models/workout_model.dart';
import 'package:ritmo_fit/providers/auth_provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final profile = Provider.of<ProfileProvider>(context, listen: false).selectedProfile;
    if (profile != null) {
      Provider.of<WorkoutProvider>(context, listen: false).setRoutines(profile.routines);
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = Provider.of<ProfileProvider>(context).selectedProfile;
    final workoutProvider = Provider.of<WorkoutProvider>(context);
    final routines = workoutProvider.routines;
    final user = Provider.of<AuthProvider>(context).currentUser;

    if (profile == null) {
      return const Center(
        child: Text(
          'Selecciona un perfil para ver tus rutinas',
          style: TextStyle(fontSize: 18),
        ),
      );
    }

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    profile.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('Edad: ${profile.age} años'),
                  Text('Género: ${profile.gender == 'M' ? 'Masculino' : 'Femenino'}'),
                  Text('Peso: ${profile.weight} kg'),
                  Text('Estatura: ${profile.height} m'),
                  Text('IMC: ${profile.bmi.toStringAsFixed(2)} (${profile.bmiCategory})'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (routines.isEmpty)
            const Center(
              child: Text(
                'No hay rutinas disponibles',
                style: TextStyle(fontSize: 18),
              ),
            )
          else
            ...routines.map((routine) => Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: ExpansionTile(
                    title: Text(
                      routine.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('${routine.targetMuscleGroup} - ${routine.difficulty}'),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(routine.description),
                            const SizedBox(height: 16),
                            const Text(
                              'Ejercicios:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            ...routine.exercises.map((exercise) => ListTile(
                                  title: Text(exercise.name),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(exercise.description),
                                      Text(
                                          '${exercise.sets} series x ${exercise.reps} repeticiones'),
                                      if (exercise.weight != null)
                                        Text('Peso: ${exercise.weight} kg'),
                                    ],
                                  ),
                                  trailing: IconButton(
                                    icon: Icon(
                                      exercise.status == 'completed'
                                          ? Icons.check_circle
                                          : Icons.circle_outlined,
                                      color: exercise.status == 'completed'
                                          ? Colors.green
                                          : Colors.grey,
                                    ),
                                    onPressed: () {
                                      if (user != null) {
                                        workoutProvider.updateExerciseStatus(
                                          userId: user.id,
                                          profileId: profile.id,
                                          routineId: routine.id,
                                          exerciseId: exercise.id,
                                          status: exercise.status == 'completed'
                                              ? 'pending'
                                              : 'completed',
                                        );
                                      }
                                    },
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final profile = Provider.of<ProfileProvider>(context, listen: false).selectedProfile;
          final user = Provider.of<AuthProvider>(context, listen: false).currentUser;
          
          if (profile == null || user == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Selecciona un perfil primero'),
                backgroundColor: Colors.red,
              ),
            );
            return;
          }

          try {
            await Provider.of<WorkoutProvider>(context, listen: false).generateRoutine(
              userId: user.id,
              profileId: profile.id,
              targetMuscleGroup: 'Full Body',
            );
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Rutina generada exitosamente'),
                backgroundColor: Colors.green,
              ),
            );
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error al generar la rutina: $e'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
} 