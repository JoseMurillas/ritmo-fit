import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ritmo_fit/providers/auth_provider.dart';
import 'package:ritmo_fit/screens/home/dashboard_screen.dart';
import 'package:ritmo_fit/screens/home/profiles_screen.dart';
import 'package:ritmo_fit/screens/workout/workout_home_screen.dart';
import 'package:ritmo_fit/screens/home/forum_screen.dart';
import 'package:ritmo_fit/screens/home/settings_screen.dart';
import 'dart:math' as math;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _fabController;
  late AnimationController _navController;
  late Animation<double> _fabAnimation;
  late Animation<double> _navAnimation;
  
  final List<Widget> _screens = [
    const DashboardScreen(),
    const WorkoutHomeScreen(),
    const ProfilesScreen(),
    const ForumScreen(),
    const SettingsScreen(),
  ];

  final List<NavItem> _navItems = [
    NavItem(icon: Icons.dashboard, activeIcon: Icons.dashboard_rounded, label: 'Inicio', color: Colors.indigo),
    NavItem(icon: Icons.fitness_center, activeIcon: Icons.fitness_center_rounded, label: 'Entrenamientos', color: Colors.orange),
    NavItem(icon: Icons.person, activeIcon: Icons.person_rounded, label: 'Perfiles', color: Colors.green),
    NavItem(icon: Icons.forum, activeIcon: Icons.forum_rounded, label: 'Foro', color: Colors.purple),
    NavItem(icon: Icons.settings, activeIcon: Icons.settings_rounded, label: 'Ajustes', color: Colors.blueGrey),
  ];

  @override
  void initState() {
    super.initState();
    _initAnimations();
  }

  void _initAnimations() {
    _fabController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _navController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _fabAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fabController,
      curve: Curves.elasticOut,
    ));

    _navAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _navController,
      curve: Curves.easeInOut,
    ));

    _fabController.forward();
    _navController.forward();
  }

  @override
  void dispose() {
    _fabController.dispose();
    _navController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).currentUser;

    return Scaffold(
      appBar: _buildModernAppBar(context, user),
      body: Stack(
        children: [
          _buildBackgroundGradient(),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.1, 0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              );
            },
            child: _screens[_selectedIndex],
          ),
        ],
      ),
      bottomNavigationBar: _buildCustomBottomNav(),
      floatingActionButton: _buildFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildBackgroundGradient() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.indigo.withOpacity(0.02),
            Colors.purple.withOpacity(0.02),
            Colors.pink.withOpacity(0.02),
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildModernAppBar(BuildContext context, user) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.indigo,
              Colors.purple,
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
      ),
      title: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.2),
            ),
            child: const Icon(
              Icons.fitness_center,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'RitmoFit',
            style: GoogleFonts.orbitron(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 8),
          child: IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.2),
              ),
              child: const Icon(
                Icons.notifications_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
            onPressed: () {
              // TODO: Implementar notificaciones
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Notificaciones próximamente'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
        ),
        Container(
          margin: const EdgeInsets.only(right: 16),
          child: IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.2),
              ),
              child: const Icon(
                Icons.logout_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
            onPressed: () => _showLogoutDialog(context),
          ),
        ),
      ],
    );
  }

  Widget _buildCustomBottomNav() {
    return AnimatedBuilder(
      animation: _navAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 100 * (1 - _navAnimation.value)),
          child: Container(
            height: 80,
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(_navItems.length, (index) {
                if (index == 2) {
                  // Espacio para el FAB
                  return const SizedBox(width: 40);
                }
                return _buildNavItem(index, index > 2 ? index - 1 : index);
              }),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNavItem(int itemIndex, int actualIndex) {
    final isSelected = _selectedIndex == actualIndex;
    final item = _navItems[actualIndex];
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = actualIndex;
        });
        _navController.forward(from: 0);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: isSelected ? item.color.withOpacity(0.1) : Colors.transparent,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                isSelected ? item.activeIcon : item.icon,
                key: ValueKey(isSelected),
                color: isSelected ? item.color : Colors.grey[600],
                size: 24,
              ),
            ),
            const SizedBox(height: 4),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: GoogleFonts.poppins(
                fontSize: isSelected ? 12 : 10,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? item.color : Colors.grey[600],
              ),
              child: Text(item.label),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return AnimatedBuilder(
      animation: _fabAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _fabAnimation.value,
          child: Transform.rotate(
            angle: _fabAnimation.value * 2 * math.pi,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.orange,
                    Colors.deepOrange,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.orange.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(30),
                  onTap: () {
                    setState(() {
                      _selectedIndex = 1; // Ir a entrenamientos
                    });
                    _fabController.forward(from: 0);
                  },
                  child: const Icon(
                    Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _showLogoutDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red.withOpacity(0.1),
              ),
              child: const Icon(
                Icons.logout_rounded,
                color: Colors.red,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Cerrar Sesión',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        content: Text(
          '¿Estás seguro de que deseas cerrar sesión?',
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              'Cancelar',
              style: GoogleFonts.poppins(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await Provider.of<AuthProvider>(context, listen: false).logout();
              if (!context.mounted) return;
              Navigator.of(context).pushReplacementNamed('/login');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            child: Text(
              'Cerrar Sesión',
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

class NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final Color color;

  NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.color,
  });
} 