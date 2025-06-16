import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ritmo_fit/providers/auth_provider.dart';
import 'package:ritmo_fit/screens/auth/login_screen.dart';
import 'package:ritmo_fit/screens/home/home_screen.dart';
import 'dart:math' as math;

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  bool _isError = false;
  String _errorMessage = '';
  String _status = 'Iniciando...';
  
  late AnimationController _rotationController;
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  
  late Animation<double> _rotationAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _checkAuthStatus();
  }

  void _initAnimations() {
    _rotationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * math.pi,
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.easeInOutCubic,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));

    _rotationController.repeat();
    _fadeController.forward();
    _scaleController.forward();
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _fadeController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  Future<void> _checkAuthStatus() async {
    try {
      setState(() {
        _status = 'Preparando tu experiencia fitness...';
      });
      
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return;

      setState(() {
        _status = 'Conectando con tu progreso...';
      });

      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      
      setState(() {
        _status = 'Verificando tus datos...';
      });
      
      await authProvider.checkAuthStatus();

      if (!mounted) return;

      if (authProvider.error != null) {
        setState(() {
          _isError = true;
          _errorMessage = 'Error de conexión: ${authProvider.error!}';
        });
        return;
      }

      setState(() {
        _status = '¡Listo para entrenar! 💪';
      });

      await Future.delayed(const Duration(milliseconds: 800));

      if (!mounted) return;

      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              authProvider.isAuthenticated
                  ? const HomeScreen()
                  : const LoginScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOutQuart;

            var tween = Tween(begin: begin, end: end).chain(
              CurveTween(curve: curve),
            );

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 600),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isError = true;
        _errorMessage = 'Error en inicialización: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF667eea),
              Color(0xFF764ba2),
              Color(0xFFf093fb),
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Partículas de fondo animadas
            ...List.generate(12, (index) => _buildFloatingParticle(index)),
            
            // Contenido principal
            Center(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo animado
                    ScaleTransition(
                      scale: _scaleAnimation,
                      child: Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: AnimatedBuilder(
                          animation: _rotationAnimation,
                          builder: (context, child) {
                            return Transform.rotate(
                              angle: _rotationAnimation.value,
                              child: const Icon(
                                Icons.fitness_center,
                                size: 70,
                                color: Colors.white,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // Nombre de la app con tipografía moderna
                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [Colors.white, Colors.white70],
                      ).createShader(bounds),
                      child: Text(
                        'RitmoFit',
                        style: GoogleFonts.orbitron(
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Subtítulo
                    Text(
                      'Tu Compañero de Fitness Personal',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.9),
                        fontWeight: FontWeight.w300,
                        letterSpacing: 0.5,
                      ),
                    ),
                    
                    const SizedBox(height: 60),
                    
                    // Indicador de carga o error
                    if (_isError) ...[
                      _buildErrorWidget(),
                    ] else ...[
                      _buildLoadingWidget(),
                    ],
                  ],
                ),
              ),
            ),
            
            // Versión en la esquina
            Positioned(
              bottom: 30,
              left: 0,
              right: 0,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Text(
                  'v1.0.0 - Hecho con 💜 para tu salud',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.6),
                    fontWeight: FontWeight.w300,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingParticle(int index) {
    final double size = (index % 3 + 1) * 4.0;
    final double left = (index * 37) % 100;
    final double animationOffset = index * 0.5;
    
    return Positioned(
      left: MediaQuery.of(context).size.width * (left / 100),
      top: MediaQuery.of(context).size.height * ((index * 13) % 100 / 100),
      child: AnimatedBuilder(
        animation: _rotationController,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(
              math.sin((_rotationController.value * 2 * math.pi) + animationOffset) * 30,
              math.cos((_rotationController.value * 2 * math.pi) + animationOffset) * 20,
            ),
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return Column(
      children: [
        Container(
          width: 200,
          height: 4,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            color: Colors.white.withOpacity(0.2),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: AnimatedBuilder(
              animation: _rotationController,
              builder: (context, child) {
                return LinearProgressIndicator(
                  value: (_rotationController.value * 3) % 1.0,
                  backgroundColor: Colors.transparent,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.white.withOpacity(0.8),
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          _status,
          style: GoogleFonts.poppins(
            color: Colors.white.withOpacity(0.9),
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 32),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.warning_rounded,
            color: Colors.white,
            size: 40,
          ),
          const SizedBox(height: 16),
          Text(
            _errorMessage,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _isError = false;
                _errorMessage = '';
                _status = 'Reintentando...';
              });
              _checkAuthStatus();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Color(0xFF667eea),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Text(
              'Reintentar',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
} 