import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:ritmo_fit/providers/workout_provider.dart';
import 'package:ritmo_fit/models/workout_model.dart';
import 'package:intl/intl.dart';

class WorkoutStatsScreen extends StatefulWidget {
  const WorkoutStatsScreen({super.key});

  @override
  State<WorkoutStatsScreen> createState() => _WorkoutStatsScreenState();
}

class _WorkoutStatsScreenState extends State<WorkoutStatsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeWorkoutProvider();
    });
  }

  Future<void> _initializeWorkoutProvider() async {
    final workoutProvider = Provider.of<WorkoutProvider>(context, listen: false);
    if (!workoutProvider.isInitialized) {
      await workoutProvider.initialize();
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Estadísticas de Entrenamiento',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: 'Resumen'),
            Tab(text: 'Progreso'),
            Tab(text: 'Historial'),
          ],
        ),
      ),
      body: Consumer<WorkoutProvider>(
        builder: (context, workoutProvider, child) {
          if (workoutProvider.recentSessions.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.bar_chart,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No hay datos de entrenamiento',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Completa algunas sesiones para ver estadísticas',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () async {
                      await workoutProvider.addSampleData();
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('✅ Datos de ejemplo agregados'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.data_thresholding),
                    label: const Text('Agregar datos de ejemplo'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                  ),
                ],
              ),
            );
          }

          return TabBarView(
            controller: _tabController,
            children: [
              _buildOverviewTab(workoutProvider),
              _buildProgressTab(workoutProvider),
              _buildHistoryTab(workoutProvider),
            ],
          );
        },
      ),
    );
  }

  Widget _buildOverviewTab(WorkoutProvider workoutProvider) {
    final weeklyStats = workoutProvider.getWeeklyStats();
    final monthlyStats = workoutProvider.getMonthlyStats();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildWeeklyOverview(weeklyStats),
          const SizedBox(height: 20),
          _buildMonthlyOverview(monthlyStats),
          const SizedBox(height: 20),
          _buildCurrentStreak(workoutProvider),
          const SizedBox(height: 20),
          _buildGoalsSection(workoutProvider),
        ],
      ),
    );
  }

  Widget _buildWeeklyOverview(Map<String, dynamic> stats) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.blue, Colors.blueAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Esta Semana',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Entrenamientos',
                  '${stats['sessionsCompleted']}',
                  Icons.fitness_center,
                  Colors.white,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Tiempo Total',
                  '${stats['totalMinutes']}m',
                  Icons.timer,
                  Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Días Activos',
                  '${stats['daysActive']}/7',
                  Icons.calendar_today,
                  Colors.white,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Cumplimiento',
                  '${stats['averageCompletion'].toStringAsFixed(0)}%',
                  Icons.trending_up,
                  Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlyOverview(Map<String, dynamic> stats) {
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
            'Este Mes',
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
                child: _buildMonthStat(
                  'Entrenamientos',
                  '${stats['sessionsCompleted']}',
                  Icons.fitness_center,
                  Colors.indigo,
                ),
              ),
              Expanded(
                child: _buildMonthStat(
                  'Horas',
                  '${(stats['totalMinutes'] / 60).toStringAsFixed(1)}h',
                  Icons.timer,
                  Colors.green,
                ),
              ),
              Expanded(
                child: _buildMonthStat(
                  'Días Activos',
                  '${stats['daysActive']}/${stats['totalDaysInMonth']}',
                  Icons.calendar_today,
                  Colors.orange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: stats['daysActive'] / stats['totalDaysInMonth'],
            backgroundColor: Colors.grey[200],
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.indigo),
            minHeight: 6,
          ),
          const SizedBox(height: 8),
          Text(
            'Progreso del mes: ${((stats['daysActive'] / stats['totalDaysInMonth']) * 100).toStringAsFixed(0)}%',
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.poppins(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: GoogleFonts.poppins(
              color: color.withOpacity(0.8),
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMonthStat(String title, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 18,
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

  Widget _buildCurrentStreak(WorkoutProvider workoutProvider) {
    // Calcular racha actual (días consecutivos con entrenamientos)
    int currentStreak = _calculateCurrentStreak(workoutProvider.recentSessions);
    int longestStreak = _calculateLongestStreak(workoutProvider.recentSessions);

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
            'Rachas de Entrenamiento',
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
                child: _buildStreakCard(
                  'Racha Actual',
                  '$currentStreak días',
                  Icons.local_fire_department,
                  Colors.orange,
                  currentStreak > 0,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStreakCard(
                  'Mejor Racha',
                  '$longestStreak días',
                  Icons.emoji_events,
                  Colors.amber,
                  true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStreakCard(String title, String value, IconData icon, Color color, bool isActive) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isActive ? color.withOpacity(0.1) : Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isActive ? color.withOpacity(0.3) : Colors.grey[200]!,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: isActive ? color : Colors.grey[400],
            size: 32,
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isActive ? color : Colors.grey[600],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildGoalsSection(WorkoutProvider workoutProvider) {
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
            'Objetivos Semanales',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 16),
          _buildGoalItem('Entrenamientos', 3, workoutProvider.getWeeklyStats()['sessionsCompleted']),
          const SizedBox(height: 12),
          _buildGoalItem('Tiempo de ejercicio', 150, workoutProvider.getWeeklyStats()['totalMinutes']),
          const SizedBox(height: 12),
          _buildGoalItem('Días activos', 4, workoutProvider.getWeeklyStats()['daysActive']),
        ],
      ),
    );
  }

  Widget _buildGoalItem(String title, int target, int current) {
    final progress = (current / target).clamp(0.0, 1.0);
    final isCompleted = current >= target;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
            Row(
              children: [
                Text(
                  '$current/$target',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isCompleted ? Colors.green : Colors.grey[600],
                  ),
                ),
                const SizedBox(width: 8),
                if (isCompleted)
                  const Icon(Icons.check_circle, color: Colors.green, size: 20),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.grey[200],
          valueColor: AlwaysStoppedAnimation<Color>(
            isCompleted ? Colors.green : Colors.indigo,
          ),
          minHeight: 6,
        ),
      ],
    );
  }

  Widget _buildProgressTab(WorkoutProvider workoutProvider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildWeeklyProgressChart(workoutProvider),
          const SizedBox(height: 20),
          _buildMonthlyTrendChart(workoutProvider),
          const SizedBox(height: 20),
          _buildMuscleGroupProgress(workoutProvider),
        ],
      ),
    );
  }

  Widget _buildWeeklyProgressChart(WorkoutProvider workoutProvider) {
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
            'Actividad Semanal',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 120,
                barTouchData: BarTouchData(enabled: true),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const days = ['L', 'M', 'X', 'J', 'V', 'S', 'D'];
                        return Text(
                          days[value.toInt()],
                          style: GoogleFonts.poppins(fontSize: 12),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toInt()}m',
                          style: GoogleFonts.poppins(fontSize: 10),
                        );
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                barGroups: _generateWeeklyData(workoutProvider),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<BarChartGroupData> _generateWeeklyData(WorkoutProvider workoutProvider) {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    
    return List.generate(7, (index) {
      final date = weekStart.add(Duration(days: index));
      final sessions = workoutProvider.getSessionsByDate(date);
      final totalMinutes = sessions.fold<int>(0, (sum, session) {
        return sum + (session.durationMinutes ?? 0);
      });

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: totalMinutes.toDouble(),
            color: totalMinutes > 0 ? Colors.indigo : Colors.grey[300],
            width: 20,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
          ),
        ],
      );
    });
  }

  Widget _buildMonthlyTrendChart(WorkoutProvider workoutProvider) {
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
            'Tendencia Mensual',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: true),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toInt()}',
                          style: GoogleFonts.poppins(fontSize: 10),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toInt()}',
                          style: GoogleFonts.poppins(fontSize: 10),
                        );
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: true),
                lineBarsData: [
                  LineChartBarData(
                    spots: _generateMonthlyData(workoutProvider),
                    isCurved: true,
                    color: Colors.indigo,
                    barWidth: 3,
                    dotData: const FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      color: Colors.indigo.withOpacity(0.1),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<FlSpot> _generateMonthlyData(WorkoutProvider workoutProvider) {
    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month, 1);
    final spots = <FlSpot>[];
    
    for (int i = 1; i <= now.day; i++) {
      final date = DateTime(now.year, now.month, i);
      final sessions = workoutProvider.getSessionsByDate(date);
      final sessionCount = sessions.where((s) => s.status == 'completed').length;
      
      spots.add(FlSpot(i.toDouble(), sessionCount.toDouble()));
    }
    
    return spots;
  }

  Widget _buildMuscleGroupProgress(WorkoutProvider workoutProvider) {
    final muscleGroups = ['Pecho', 'Espalda', 'Piernas', 'Hombros', 'Brazos'];
    final muscleGroupData = <String, int>{};
    
    for (final group in muscleGroups) {
      muscleGroupData[group] = 0;
    }
    
    // Contar entrenamientos por grupo muscular en las sesiones recientes
    for (final session in workoutProvider.recentSessions) {
      if (session.status == 'completed') {
        for (final log in session.exerciseLogs) {
          if (log.completed) {
            // Esto sería mejor si tuviéramos el grupo muscular en el log
            // Por ahora, asumimos una distribución
            muscleGroupData['Pecho'] = (muscleGroupData['Pecho'] ?? 0) + 1;
          }
        }
      }
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
          Text(
            'Progreso por Grupo Muscular',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 20),
          ...muscleGroups.map((group) {
            final count = muscleGroupData[group] ?? 0;
            final maxCount = muscleGroupData.values.reduce((a, b) => a > b ? a : b);
            final progress = maxCount > 0 ? count / maxCount : 0.0;
            
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        group,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700],
                        ),
                      ),
                      Text(
                        '$count ejercicios',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey[200],
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.indigo),
                    minHeight: 6,
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildHistoryTab(WorkoutProvider workoutProvider) {
    final sessions = workoutProvider.recentSessions;
    
    if (sessions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.history,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 20),
            Text(
              'No hay historial de entrenamientos',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Realiza tu primer entrenamiento\npara ver las estadísticas',
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

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sessions.length,
      itemBuilder: (context, index) {
        final session = sessions[index];
        return _buildHistoryItem(session);
      },
    );
  }

  Widget _buildHistoryItem(WorkoutSession session) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: session.status == 'completed' 
                      ? Colors.green.withOpacity(0.1) 
                      : Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Icon(
                  session.status == 'completed' 
                      ? Icons.check_circle 
                      : Icons.schedule,
                  color: session.status == 'completed' 
                      ? Colors.green 
                      : Colors.orange,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat('EEEE, d MMMM yyyy', 'es_ES').format(session.date),
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      session.status == 'completed' 
                          ? 'Completado • ${session.durationMinutes ?? 0} min'
                          : 'En progreso',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
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
                      index < session.rating!.round() 
                          ? Icons.star 
                          : Icons.star_border,
                      color: Colors.amber,
                      size: 16,
                    );
                  }),
                ),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: session.completionPercentage / 100,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(
              session.status == 'completed' ? Colors.green : Colors.indigo,
            ),
            minHeight: 4,
          ),
          const SizedBox(height: 8),
          Text(
            '${session.completionPercentage.toInt()}% completado • ${session.exerciseLogs.length} ejercicios',
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          if (session.notes != null && session.notes!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                session.notes!,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.grey[700],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  int _calculateCurrentStreak(List<WorkoutSession> sessions) {
    if (sessions.isEmpty) return 0;
    
    final completedSessions = sessions
        .where((s) => s.status == 'completed')
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
    
    if (completedSessions.isEmpty) return 0;
    
    int streak = 0;
    DateTime lastDate = DateTime.now();
    
    for (final session in completedSessions) {
      final difference = lastDate.difference(session.date).inDays;
      
      if (difference <= 1) {
        streak++;
        lastDate = session.date;
      } else {
        break;
      }
    }
    
    return streak;
  }

  int _calculateLongestStreak(List<WorkoutSession> sessions) {
    if (sessions.isEmpty) return 0;
    
    final completedSessions = sessions
        .where((s) => s.status == 'completed')
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));
    
    if (completedSessions.isEmpty) return 0;
    
    int maxStreak = 1;
    int currentStreak = 1;
    
    for (int i = 1; i < completedSessions.length; i++) {
      final previous = completedSessions[i - 1];
      final current = completedSessions[i];
      
      final difference = current.date.difference(previous.date).inDays;
      
      if (difference <= 1) {
        currentStreak++;
      } else {
        maxStreak = currentStreak > maxStreak ? currentStreak : maxStreak;
        currentStreak = 1;
      }
    }
    
    return currentStreak > maxStreak ? currentStreak : maxStreak;
  }
} 