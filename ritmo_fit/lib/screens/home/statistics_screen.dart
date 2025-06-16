import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ritmo_fit/providers/workout_provider.dart';
import 'package:ritmo_fit/providers/profile_provider.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  int _selectedPeriod = 0; // 0: Semana, 1: Mes, 2: Año

  @override
  void initState() {
    super.initState();
    _initAnimation();
  }

  void _initAnimation() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          'Estadísticas',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF667eea),
        foregroundColor: Colors.white,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF667eea), Color(0xFF764ba2)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Consumer2<WorkoutProvider, ProfileProvider>(
        builder: (context, workoutProvider, profileProvider, child) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildPeriodSelector(),
                  const SizedBox(height: 24),
                  _buildOverviewCards(workoutProvider),
                  const SizedBox(height: 24),
                  _buildProgressChart(workoutProvider),
                  const SizedBox(height: 24),
                  _buildWorkoutTypeBreakdown(workoutProvider),
                  const SizedBox(height: 24),
                  _buildPersonalRecords(workoutProvider),
                  const SizedBox(height: 24),
                  _buildConsistencyTracker(workoutProvider),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPeriodSelector() {
    final periods = ['Semana', 'Mes', 'Año'];
    
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: periods.asMap().entries.map((entry) {
          final index = entry.key;
          final period = entry.value;
          final isSelected = _selectedPeriod == index;
          
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedPeriod = index;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF667eea) : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  period,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : const Color(0xFF718096),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildOverviewCards(WorkoutProvider workoutProvider) {
    final sessions = workoutProvider.recentSessions;
    final completedSessions = sessions.where((s) => s.status == 'completed').toList();
    final totalMinutes = completedSessions
        .where((s) => s.durationMinutes != null)
        .fold(0, (sum, s) => sum + s.durationMinutes!);
    final avgRating = completedSessions
        .where((s) => s.rating != null)
        .fold(0.0, (sum, s) => sum + s.rating!) / 
        (completedSessions.where((s) => s.rating != null).length.clamp(1, double.infinity));

    return Row(
      children: [
        Expanded(
          child: _buildOverviewCard(
            'Entrenamientos',
            completedSessions.length.toString(),
            Icons.fitness_center,
            const Color(0xFF667eea),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildOverviewCard(
            'Tiempo Total',
            '${(totalMinutes / 60).toStringAsFixed(1)}h',
            Icons.timer,
            const Color(0xFFED8936),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildOverviewCard(
            'Calificación',
            avgRating.isNaN ? '0.0' : avgRating.toStringAsFixed(1),
            Icons.star,
            const Color(0xFF38A169),
          ),
        ),
      ],
    );
  }

  Widget _buildOverviewCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: const Color(0xFF718096),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildProgressChart(WorkoutProvider workoutProvider) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Progreso de Entrenamientos',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            height: 200,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.show_chart,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Gráfico de progreso',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Próximamente disponible',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[500],
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

  Widget _buildWorkoutTypeBreakdown(WorkoutProvider workoutProvider) {
    final workoutTypes = {
      'Fuerza': 45,
      'Cardio': 30,
      'Flexibilidad': 15,
      'HIIT': 10,
    };

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tipos de Entrenamiento',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 20),
          ...workoutTypes.entries.map((entry) {
            final colors = [
              const Color(0xFF667eea),
              const Color(0xFFED8936),
              const Color(0xFF38A169),
              const Color(0xFF9F7AEA),
            ];
            final colorIndex = workoutTypes.keys.toList().indexOf(entry.key);
            final color = colors[colorIndex % colors.length];
            
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      entry.key,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF2D3748),
                      ),
                    ),
                  ),
                  Text(
                    '${entry.value}%',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildPersonalRecords(WorkoutProvider workoutProvider) {
    final records = [
      {'exercise': 'Press de Banca', 'weight': '80kg', 'date': '15 Dic'},
      {'exercise': 'Sentadillas', 'weight': '100kg', 'date': '12 Dic'},
      {'exercise': 'Peso Muerto', 'weight': '120kg', 'date': '10 Dic'},
    ];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.emoji_events, color: Color(0xFFED8936), size: 24),
              const SizedBox(width: 8),
              Text(
                'Records Personales',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2D3748),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...records.map((record) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFED8936).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFFED8936).withOpacity(0.2),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.trending_up, color: Color(0xFFED8936), size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          record['exercise']!,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF2D3748),
                          ),
                        ),
                        Text(
                          record['date']!,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: const Color(0xFF718096),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    record['weight']!,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFED8936),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildConsistencyTracker(WorkoutProvider workoutProvider) {
    final days = ['L', 'M', 'X', 'J', 'V', 'S', 'D'];
    final completedDays = [true, true, false, true, true, false, true];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.calendar_today, color: Color(0xFF38A169), size: 24),
              const SizedBox(width: 8),
              Text(
                'Consistencia Semanal',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2D3748),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: days.asMap().entries.map((entry) {
              final index = entry.key;
              final day = entry.value;
              final isCompleted = completedDays[index];
              
              return Column(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: isCompleted 
                          ? const Color(0xFF38A169) 
                          : Colors.grey[200],
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: isCompleted
                          ? const Icon(Icons.check, color: Colors.white, size: 20)
                          : Text(
                              day,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[600],
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    day,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: isCompleted 
                          ? const Color(0xFF38A169) 
                          : Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF38A169).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.local_fire_department, color: Color(0xFF38A169), size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Racha actual: 5 días',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF2D3748),
                        ),
                      ),
                      Text(
                        '¡Sigue así para mantener tu racha!',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: const Color(0xFF718096),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 