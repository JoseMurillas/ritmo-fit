import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:ritmo_fit/providers/workout_provider.dart';
import 'package:ritmo_fit/providers/profile_provider.dart';
import 'package:ritmo_fit/screens/workout/workout_session_screen.dart';
import 'package:ritmo_fit/screens/workout/workout_routines_screen.dart';
import 'package:ritmo_fit/screens/workout/workout_stats_screen.dart';
import 'package:ritmo_fit/models/workout_model.dart';
import 'package:intl/intl.dart';

class WorkoutHomeScreen extends StatefulWidget {
  const WorkoutHomeScreen({super.key});

  @override
  State<WorkoutHomeScreen> createState() => _WorkoutHomeScreenState();
}

class _WorkoutHomeScreenState extends State<WorkoutHomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeWorkoutData();
    });
  }

  Future<void> _initializeWorkoutData() async {
    final workoutProvider = Provider.of<WorkoutProvider>(context, listen: false);
    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    
    await workoutProvider.initialize();
    
    if (profileProvider.selectedProfile != null) {
      await workoutProvider.setCurrentProfile(profileProvider.selectedProfile!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Consumer<WorkoutProvider>(
        builder: (context, workoutProvider, child) {
          if (workoutProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (workoutProvider.currentProfile == null) {
            return const Center(
              child: Text(
                'Selecciona un perfil para comenzar',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          return CustomScrollView(
            slivers: [
              _buildAppBar(context, workoutProvider),
              SliverPadding(
                padding: const EdgeInsets.all(16.0),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _buildProfileCard(workoutProvider),
                    const SizedBox(height: 20),
                    _buildQuickActions(context, workoutProvider),
                    const SizedBox(height: 20),
                    _buildWeeklyProgress(workoutProvider),
                    const SizedBox(height: 20),
                    _buildCurrentRoutine(context, workoutProvider),
                    const SizedBox(height: 20),
                    _buildRecentSessions(context, workoutProvider),
                  ]),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, WorkoutProvider workoutProvider) {
    return SliverAppBar(
      expandedHeight: 100,
      floating: false,
      pinned: true,
      backgroundColor: Colors.indigo,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        title: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '¡Hola, ${workoutProvider.currentProfile?.name ?? 'Usuario'}!',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'Hora de entrenar 💪',
              style: GoogleFonts.poppins(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.data_thresholding, color: Colors.white),
          onPressed: () async {
            final workoutProvider = Provider.of<WorkoutProvider>(context, listen: false);
            await workoutProvider.addSampleData();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('✅ Datos de ejemplo agregados'),
                backgroundColor: Colors.green,
              ),
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.analytics_outlined, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const WorkoutStatsScreen(),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildProfileCard(WorkoutProvider workoutProvider) {
    final profile = workoutProvider.currentProfile!;
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.indigo, Colors.indigoAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.indigo.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: Colors.white,
                child: Text(
                  profile.name[0].toUpperCase(),
                  style: GoogleFonts.poppins(
                    color: Colors.indigo,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile.name,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '${profile.age} años • ${profile.gender}',
                      style: GoogleFonts.poppins(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildProfileStat(
                  'IMC',
                  profile.bmi.toStringAsFixed(1),
                  profile.bmiCategory,
                  Icons.monitor_weight,
                ),
              ),
              Expanded(
                child: _buildProfileStat(
                  'Nivel',
                  profile.fitnessLevel.toUpperCase(),
                  profile.fitnessLevelDescription,
                  Icons.fitness_center,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileStat(String title, String value, String subtitle, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white70, size: 20),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: GoogleFonts.poppins(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
          Text(
            subtitle,
            style: GoogleFonts.poppins(
              color: Colors.white60,
              fontSize: 10,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context, WorkoutProvider workoutProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Acciones Rápidas',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                title: workoutProvider.hasActiveSession ? 'Continuar Entrenamiento' : 'Iniciar Entrenamiento',
                subtitle: workoutProvider.hasActiveSession ? 'Sesión en progreso' : 'Comenzar rutina de hoy',
                icon: workoutProvider.hasActiveSession ? Icons.play_circle_filled : Icons.play_arrow,
                color: Colors.green,
                onTap: () async {
                  if (workoutProvider.hasActiveSession) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WorkoutSessionScreen(
                          session: workoutProvider.activeSession!,
                        ),
                      ),
                    );
                  } else {
                    if (workoutProvider.currentRoutine != null) {
                      final session = await workoutProvider.startWorkoutSession();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WorkoutSessionScreen(session: session),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('No hay rutina seleccionada')),
                      );
                    }
                  }
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionCard(
                title: 'Rutinas',
                subtitle: 'Ver todas las rutinas',
                icon: Icons.list_alt,
                color: Colors.blue,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WorkoutRoutinesScreen(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 12),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklyProgress(WorkoutProvider workoutProvider) {
    final stats = workoutProvider.getWeeklyStats();
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Progreso Semanal',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildWeekStat(
                  'Entrenamientos',
                  '${stats['sessionsCompleted']}',
                  Icons.fitness_center,
                  Colors.blue,
                ),
              ),
              Expanded(
                child: _buildWeekStat(
                  'Tiempo Total',
                  '${stats['totalMinutes']} min',
                  Icons.timer,
                  Colors.green,
                ),
              ),
              Expanded(
                child: _buildWeekStat(
                  'Días Activos',
                  '${stats['daysActive']}/7',
                  Icons.calendar_today,
                  Colors.orange,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeekStat(String title, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
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
          title,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildCurrentRoutine(BuildContext context, WorkoutProvider workoutProvider) {
    final routine = workoutProvider.currentRoutine;
    
    if (routine == null) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(Icons.fitness_center, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No hay rutina asignada',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Ve a Rutinas para seleccionar una',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Rutina Actual',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
              ),
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
            ],
          ),
          const SizedBox(height: 12),
          Text(
            routine.name,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            routine.description,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[600],
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
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
        ],
      ),
    );
  }

  Widget _buildRoutineInfo(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[500]),
        const SizedBox(width: 4),
        Text(
          text,
          style: GoogleFonts.poppins(
            fontSize: 12,
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

  Widget _buildRecentSessions(BuildContext context, WorkoutProvider workoutProvider) {
    final recentSessions = workoutProvider.recentSessions.take(5).toList();
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Entrenamientos Recientes',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WorkoutStatsScreen(),
                    ),
                  );
                },
                child: Text(
                  'Ver Todo',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.indigo,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (recentSessions.isEmpty)
            Center(
              child: Column(
                children: [
                  Icon(Icons.history, size: 48, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'No hay entrenamientos registrados',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            )
          else
            ...recentSessions.map((session) => _buildSessionItem(session)),
        ],
      ),
    );
  }

  Widget _buildSessionItem(WorkoutSession session) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: session.status == 'completed' ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              session.status == 'completed' ? Icons.check_circle : Icons.schedule,
              color: session.status == 'completed' ? Colors.green : Colors.orange,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat('dd MMM yyyy').format(session.date),
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  session.status == 'completed' 
                      ? '${session.durationMinutes ?? 0} min • ${session.completionPercentage.toInt()}% completado'
                      : 'En progreso',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          if (session.rating != null)
            Row(
              children: List.generate(5, (index) {
                return Icon(
                  index < session.rating!.round() ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                  size: 16,
                );
              }),
            ),
        ],
      ),
    );
  }
} 