import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ritmo_fit/models/workout_model.dart';
import 'package:ritmo_fit/providers/workout_provider.dart';

class WorkoutSessionScreen extends StatefulWidget {
  final WorkoutSession session;

  const WorkoutSessionScreen({
    super.key,
    required this.session,
  });

  @override
  State<WorkoutSessionScreen> createState() => _WorkoutSessionScreenState();
}

class _WorkoutSessionScreenState extends State<WorkoutSessionScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  int _currentExerciseIndex = 0;
  bool _isResting = false;
  int _restTimeRemaining = 0;
  Timer? _restTimer;

  @override
  void initState() {
    super.initState();
    _initAnimation();
  }

  void _initAnimation() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
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
    _restTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          'Entrenamiento',
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
        actions: [
          IconButton(
            onPressed: () => _showFinishDialog(),
            icon: const Icon(Icons.stop),
          ),
        ],
      ),
      body: Consumer<WorkoutProvider>(
        builder: (context, workoutProvider, child) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              children: [
                _buildProgressHeader(),
                Expanded(
                  child: _isResting 
                      ? _buildRestScreen()
                      : _buildExerciseScreen(),
                ),
                _buildBottomControls(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProgressHeader() {
    final totalExercises = widget.session.exerciseLogs.length;
    final progress = totalExercises > 0 ? (_currentExerciseIndex + 1) / totalExercises : 0.0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF667eea), Color(0xFF764ba2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Ejercicio ${_currentExerciseIndex + 1} de $totalExercises',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.9),
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '${(progress * 100).toInt()}%',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.white.withOpacity(0.3),
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            minHeight: 6,
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseScreen() {
    if (widget.session.exerciseLogs.isEmpty || _currentExerciseIndex >= widget.session.exerciseLogs.length) {
      return const Center(
        child: Text('No hay ejercicios disponibles'),
      );
    }

    final currentExercise = widget.session.exerciseLogs[_currentExerciseIndex];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _buildExerciseCard(currentExercise),
          const SizedBox(height: 24),
          _buildSetsSection(currentExercise),
          const SizedBox(height: 24),
          _buildExerciseInstructions(currentExercise),
        ],
      ),
    );
  }

  Widget _buildExerciseCard(ExerciseLog exercise) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFF667eea).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.fitness_center,
              size: 40,
              color: Color(0xFF667eea),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            exercise.exerciseName,
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF2D3748),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            '${exercise.setLogs.length} series',
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: const Color(0xFF718096),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSetsSection(ExerciseLog exercise) {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Series',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 16),
          ...exercise.setLogs.asMap().entries.map((entry) {
            final index = entry.key;
            final set = entry.value;
            
            return AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: set.completed 
                    ? const Color(0xFF38A169).withOpacity(0.15)
                    : Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: set.completed 
                      ? const Color(0xFF38A169)
                      : Colors.grey[300]!,
                  width: set.completed ? 2 : 1,
                ),
                boxShadow: set.completed ? [
                  BoxShadow(
                    color: const Color(0xFF38A169).withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ] : null,
              ),
              child: Row(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: set.completed 
                          ? const Color(0xFF38A169)
                          : const Color(0xFF667eea),
                      shape: BoxShape.circle,
                      boxShadow: set.completed ? [
                        BoxShadow(
                          color: const Color(0xFF38A169).withOpacity(0.4),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ] : null,
                    ),
                    child: Center(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: set.completed
                            ? const Icon(
                                Icons.check, 
                                color: Colors.white, 
                                size: 18,
                                key: ValueKey('check'),
                              )
                            : Text(
                                '${index + 1}',
                                key: ValueKey('number_${index + 1}'),
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Serie ${index + 1}',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: set.completed 
                                    ? const Color(0xFF38A169)
                                    : const Color(0xFF2D3748),
                              ),
                            ),
                            if (set.completed) ...[
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.check_circle,
                                color: Color(0xFF38A169),
                                size: 16,
                              ),
                            ],
                          ],
                        ),
                        Text(
                          '${set.reps} repeticiones${set.weight != null ? ' - ${set.weight}kg' : ''}',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: set.completed 
                                ? const Color(0xFF38A169).withOpacity(0.8)
                                : const Color(0xFF718096),
                            decoration: set.completed 
                                ? TextDecoration.lineThrough 
                                : null,
                          ),
                        ),
                        if (set.completed)
                          Text(
                            '¡Completada! 💪',
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF38A169),
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (!set.completed)
                    AnimatedScale(
                      scale: 1.0,
                      duration: const Duration(milliseconds: 150),
                      child: ElevatedButton.icon(
                        onPressed: () => _completeSet(index),
                        icon: const Icon(Icons.check, size: 16),
                        label: Text(
                          'Completar',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF667eea),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 2,
                        ),
                      ),
                    )
                  else
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF38A169),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.check_circle,
                            color: Colors.white,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Completada',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
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

  Widget _buildExerciseInstructions(ExerciseLog exercise) {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.info_outline, color: Color(0xFF667eea), size: 20),
              const SizedBox(width: 8),
              Text(
                'Instrucciones',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2D3748),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Mantén una postura correcta durante todo el ejercicio. Controla el movimiento tanto en la fase concéntrica como excéntrica. Respira adecuadamente: exhala en el esfuerzo e inhala en la relajación.',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: const Color(0xFF718096),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRestScreen() {
    final progress = _restTimeRemaining / 60.0;
    
    return Center(
      child: Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Indicador circular de progreso
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 160,
                  height: 160,
                  child: CircularProgressIndicator(
                    value: 1.0 - progress,
                    strokeWidth: 8,
                    backgroundColor: const Color(0xFFED8936).withOpacity(0.2),
                    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFED8936)),
                  ),
                ),
                Column(
                  children: [
                    const Icon(
                      Icons.timer,
                      size: 40,
                      color: Color(0xFFED8936),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '$_restTimeRemaining',
                      style: GoogleFonts.poppins(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFED8936),
                      ),
                    ),
                    Text(
                      'segundos',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: const Color(0xFF718096),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 32),
            Text(
              'Tiempo de Descanso',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF2D3748),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Relájate y prepárate para la siguiente serie',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: const Color(0xFF718096),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                _restTimer?.cancel();
                setState(() {
                  _isResting = false;
                  _restTimeRemaining = 0;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF38A169),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Saltar Descanso',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomControls() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          if (_currentExerciseIndex > 0)
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _currentExerciseIndex--;
                  });
                },
                icon: const Icon(Icons.arrow_back),
                label: const Text('Anterior'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[300],
                  foregroundColor: Colors.grey[700],
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          if (_currentExerciseIndex > 0) const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _nextExercise,
              icon: Icon(_currentExerciseIndex < widget.session.exerciseLogs.length - 1 
                  ? Icons.arrow_forward 
                  : Icons.check),
              label: Text(_currentExerciseIndex < widget.session.exerciseLogs.length - 1 
                  ? 'Siguiente' 
                  : 'Finalizar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF667eea),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _completeSet(int setIndex) {
    final currentExercise = widget.session.exerciseLogs[_currentExerciseIndex];
    
    // Primero actualizar el estado
    setState(() {
      // Marcar la serie como completada
      if (setIndex < currentExercise.setLogs.length) {
        final updatedSetLogs = List<SetLog>.from(currentExercise.setLogs);
        updatedSetLogs[setIndex] = SetLog(
          setNumber: updatedSetLogs[setIndex].setNumber,
          reps: updatedSetLogs[setIndex].reps,
          weight: updatedSetLogs[setIndex].weight,
          restTimeSeconds: updatedSetLogs[setIndex].restTimeSeconds,
          completed: true,
        );
        
        // Actualizar el ejercicio con las series modificadas
        final updatedExercise = ExerciseLog(
          exerciseId: currentExercise.exerciseId,
          exerciseName: currentExercise.exerciseName,
          setLogs: updatedSetLogs,
          completed: currentExercise.completed,
          notes: currentExercise.notes,
          completedAt: currentExercise.completedAt,
        );
        
        // Actualizar la sesión
        final updatedExerciseLogs = List<ExerciseLog>.from(widget.session.exerciseLogs);
        updatedExerciseLogs[_currentExerciseIndex] = updatedExercise;
      }
    });
    
    // Mostrar notificación verde de éxito con animación
    _showSuccessNotification('¡Serie ${setIndex + 1} completada! 💪');
    
    // Pequeño delay para que se vea la animación
    Future.delayed(const Duration(milliseconds: 500), () {
      // Iniciar descanso si no es la última serie
      if (setIndex < currentExercise.setLogs.length - 1) {
        _startRest();
      }
    });
  }

  void _startRest() {
    setState(() {
      _isResting = true;
      _restTimeRemaining = 60; // 60 segundos de descanso
    });
    
    // Cancelar timer anterior si existe
    _restTimer?.cancel();
    
    // Iniciar nuevo timer
    _restTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _restTimeRemaining--;
      });
      
      if (_restTimeRemaining <= 0) {
        timer.cancel();
        setState(() {
          _isResting = false;
        });
        
        // Mostrar notificación de que el descanso terminó
        _showRestCompleteNotification();
      }
    });
  }

  void _nextExercise() {
    if (_currentExerciseIndex < widget.session.exerciseLogs.length - 1) {
      setState(() {
        _currentExerciseIndex++;
      });
    } else {
      _finishWorkout();
    }
  }

  void _finishWorkout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          '¡Entrenamiento Completado!',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        content: Text(
          '¡Excelente trabajo! Has completado tu entrenamiento.',
          style: GoogleFonts.poppins(),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: Text(
              'Finalizar',
              style: GoogleFonts.poppins(
                color: const Color(0xFF667eea),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSuccessNotification(String message) {
    // Mostrar SnackBar verde con animación
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check,
                color: Color(0xFF38A169),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF38A169),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );

    // Mostrar también un overlay temporal con animación
    _showSuccessOverlay();
  }

  void _showSuccessOverlay() {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).size.height * 0.3,
        left: MediaQuery.of(context).size.width * 0.1,
        right: MediaQuery.of(context).size.width * 0.1,
        child: Material(
          color: Colors.transparent,
          child: TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 800),
            tween: Tween(begin: 0.0, end: 1.0),
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: Opacity(
                  opacity: value > 0.5 ? 2.0 - value * 2 : value * 2,
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: const Color(0xFF38A169),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF38A169).withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check,
                            color: Color(0xFF38A169),
                            size: 30,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '¡Serie Completada!',
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '¡Excelente trabajo! 💪',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.white.withOpacity(0.9),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            onEnd: () {
              overlayEntry.remove();
            },
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);
  }

  void _showFinishDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Finalizar Entrenamiento',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        content: Text(
          '¿Estás seguro de que quieres finalizar el entrenamiento?',
          style: GoogleFonts.poppins(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancelar',
              style: GoogleFonts.poppins(color: Colors.grey[600]),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: Text(
              'Finalizar',
              style: GoogleFonts.poppins(
                color: const Color(0xFF667eea),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showRestCompleteNotification() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.timer_off,
                color: Color(0xFF667eea),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                '¡Descanso terminado! Continúa con el siguiente ejercicio',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF667eea),
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}


