import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ritmo_fit/providers/theme_provider.dart';
import 'package:ritmo_fit/providers/auth_provider.dart';
import 'package:ritmo_fit/providers/profile_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  bool _notificationsEnabled = true;
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;
  String _selectedLanguage = 'Español';
  String _selectedUnits = 'Métrico';

  @override
  void initState() {
    super.initState();
    _initAnimation();
  }

  void _initAnimation() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
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
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildProfileSection(),
                      const SizedBox(height: 24),
                      _buildAppearanceSection(),
                      const SizedBox(height: 24),
                      _buildNotificationsSection(),
                      const SizedBox(height: 24),
                      _buildPreferencesSection(),
                      const SizedBox(height: 24),
                      _buildDataSection(),
                      const SizedBox(height: 24),
                      _buildAboutSection(),
                      const SizedBox(height: 24),
                      _buildAccountSection(),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF4C6EF5),
            Color(0xFF7B68EE),
            Color(0xFF9C27B0),
          ],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.settings_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Configuración',
                        style: GoogleFonts.poppins(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Personaliza tu experiencia',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    return Consumer2<ProfileProvider, AuthProvider>(
      builder: (context, profileProvider, authProvider, child) {
        final profile = profileProvider.selectedProfile;
        final user = authProvider.currentUser;
        
        return _buildSection(
          'Mi Perfil',
          Icons.person_rounded,
          const Color(0xFF4C6EF5),
          [
            _buildProfileCard(profile, user),
          ],
        );
      },
    );
  }

  Widget _buildProfileCard(profile, user) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF4C6EF5).withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF4C6EF5).withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: const Color(0xFF4C6EF5),
            child: Text(
              profile?.name.isNotEmpty == true ? profile!.name[0].toUpperCase() : 'U',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profile?.name ?? user?.email ?? 'Usuario',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF2D3748),
                  ),
                ),
                if (profile != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Nivel ${profile.fitnessLevel} • IMC ${profile.bmi.toStringAsFixed(1)}',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: const Color(0xFF718096),
                    ),
                  ),
                ],
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              // Navegar a editar perfil
              DefaultTabController.of(context)?.animateTo(2);
            },
            icon: const Icon(
              Icons.edit_rounded,
              color: Color(0xFF4C6EF5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppearanceSection() {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return _buildSection(
          'Apariencia',
          Icons.palette_rounded,
          const Color(0xFF7B68EE),
          [
            _buildSwitchTile(
              'Modo Oscuro',
              'Cambiar a tema oscuro',
              Icons.dark_mode_rounded,
              themeProvider.isDarkMode,
              (value) {
                themeProvider.toggleTheme();
              },
            ),
            _buildListTile(
              'Tamaño de Fuente',
              'Mediano',
              Icons.text_fields_rounded,
              () {
                _showFontSizeDialog();
              },
            ),
            _buildListTile(
              'Color de Acento',
              'Púrpura',
              Icons.color_lens_rounded,
              () {
                _showAccentColorDialog();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildNotificationsSection() {
    return _buildSection(
      'Notificaciones',
      Icons.notifications_rounded,
      const Color(0xFFFF6B6B),
      [
        _buildSwitchTile(
          'Notificaciones Push',
          'Recibir recordatorios de entrenamiento',
          Icons.notifications_active_rounded,
          _notificationsEnabled,
          (value) {
            setState(() {
              _notificationsEnabled = value;
            });
          },
        ),
        _buildSwitchTile(
          'Sonidos',
          'Reproducir sonidos en notificaciones',
          Icons.volume_up_rounded,
          _soundEnabled,
          (value) {
            setState(() {
              _soundEnabled = value;
            });
          },
        ),
        _buildSwitchTile(
          'Vibración',
          'Vibrar en notificaciones',
          Icons.vibration_rounded,
          _vibrationEnabled,
          (value) {
            setState(() {
              _vibrationEnabled = value;
            });
          },
        ),
        _buildListTile(
          'Horario de Recordatorios',
          '8:00 AM - 10:00 PM',
          Icons.schedule_rounded,
          () {
            _showScheduleDialog();
          },
        ),
      ],
    );
  }

  Widget _buildPreferencesSection() {
    return _buildSection(
      'Preferencias',
      Icons.tune_rounded,
      const Color(0xFF4ECDC4),
      [
        _buildListTile(
          'Idioma',
          _selectedLanguage,
          Icons.language_rounded,
          () {
            _showLanguageDialog();
          },
        ),
        _buildListTile(
          'Unidades',
          _selectedUnits,
          Icons.straighten_rounded,
          () {
            _showUnitsDialog();
          },
        ),
        _buildListTile(
          'Formato de Fecha',
          'DD/MM/YYYY',
          Icons.calendar_today_rounded,
          () {
            _showDateFormatDialog();
          },
        ),
      ],
    );
  }

  Widget _buildDataSection() {
    return _buildSection(
      'Datos y Almacenamiento',
      Icons.storage_rounded,
      const Color(0xFFFFB74D),
      [
        _buildListTile(
          'Sincronización',
          'Automática',
          Icons.sync_rounded,
          () {
            _showSyncDialog();
          },
        ),
        _buildListTile(
          'Copia de Seguridad',
          'Última: Hoy',
          Icons.backup_rounded,
          () {
            _showBackupDialog();
          },
        ),
        _buildListTile(
          'Limpiar Datos',
          'Liberar espacio de almacenamiento',
          Icons.cleaning_services_rounded,
          () {
            _showClearDataDialog();
          },
        ),
      ],
    );
  }

  Widget _buildAboutSection() {
    return _buildSection(
      'Acerca de',
      Icons.info_rounded,
      const Color(0xFF9C27B0),
      [
        _buildListTile(
          'Versión de la App',
          '1.0.0',
          Icons.phone_android_rounded,
          () {
            _showVersionDialog();
          },
        ),
        _buildListTile(
          'Términos y Condiciones',
          'Leer términos de uso',
          Icons.description_rounded,
          () {
            _showTermsDialog();
          },
        ),
        _buildListTile(
          'Política de Privacidad',
          'Leer política de privacidad',
          Icons.privacy_tip_rounded,
          () {
            _showPrivacyDialog();
          },
        ),
        _buildListTile(
          'Calificar App',
          'Ayúdanos con tu valoración',
          Icons.star_rounded,
          () {
            _showRateDialog();
          },
        ),
      ],
    );
  }

  Widget _buildAccountSection() {
    return _buildSection(
      'Cuenta',
      Icons.account_circle_rounded,
      const Color(0xFFE91E63),
      [
        _buildListTile(
          'Cambiar Contraseña',
          'Actualizar tu contraseña',
          Icons.lock_rounded,
          () {
            _showPasswordDialog();
          },
        ),
        _buildListTile(
          'Cerrar Sesión',
          'Salir de tu cuenta',
          Icons.logout_rounded,
          () {
            _showLogoutDialog();
          },
          isDestructive: true,
        ),
      ],
    );
  }

  Widget _buildSection(String title, IconData icon, Color color, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF2D3748),
                  ),
                ),
              ],
            ),
          ),
          ...children.map((child) => Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
            child: child,
          )),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildSwitchTile(
    String title,
    String subtitle,
    IconData icon,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    // Colores especiales para el modo oscuro
    final isDarkModeSwitch = title == 'Modo Oscuro';
    final backgroundColor = isDarkModeSwitch && value 
        ? const Color(0xFF2D3748) 
        : const Color(0xFFF7FAFC);
    final borderColor = isDarkModeSwitch && value 
        ? const Color(0xFF9F7AEA).withOpacity(0.3)
        : const Color(0xFFE2E8F0);
    final iconColor = isDarkModeSwitch && value 
        ? const Color(0xFF9F7AEA) 
        : const Color(0xFF718096);
    final titleColor = isDarkModeSwitch && value 
        ? Colors.white 
        : const Color(0xFF2D3748);
    final subtitleColor = isDarkModeSwitch && value 
        ? Colors.white70 
        : const Color(0xFF718096);

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
        boxShadow: isDarkModeSwitch && value ? [
          BoxShadow(
            color: const Color(0xFF9F7AEA).withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ] : null,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isDarkModeSwitch && value 
                  ? const Color(0xFF9F7AEA).withOpacity(0.2)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: titleColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: subtitleColor,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: (newValue) {
              onChanged(newValue);
              
              // Mostrar feedback visual especial para modo oscuro
              if (isDarkModeSwitch) {
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
                          child: Icon(
                            newValue ? Icons.dark_mode : Icons.light_mode,
                            color: newValue ? const Color(0xFF9F7AEA) : const Color(0xFF4C6EF5),
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            newValue 
                                ? '¡Modo oscuro activado! 🌙' 
                                : '¡Modo claro activado! ☀️',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    backgroundColor: newValue 
                        ? const Color(0xFF9F7AEA) 
                        : const Color(0xFF4C6EF5),
                    duration: const Duration(seconds: 2),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.all(16),
                  ),
                );
              }
            },
            activeColor: isDarkModeSwitch ? const Color(0xFF9F7AEA) : const Color(0xFF4C6EF5),
            activeTrackColor: isDarkModeSwitch 
                ? const Color(0xFF9F7AEA).withOpacity(0.3)
                : const Color(0xFF4C6EF5).withOpacity(0.3),
            inactiveThumbColor: Colors.grey[400],
            inactiveTrackColor: Colors.grey[300],
          ),
        ],
      ),
    );
  }

  Widget _buildListTile(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(
          icon,
          color: isDestructive ? const Color(0xFFE53E3E) : const Color(0xFF718096),
          size: 24,
        ),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isDestructive ? const Color(0xFFE53E3E) : const Color(0xFF2D3748),
          ),
        ),
        subtitle: Text(
          subtitle,
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: const Color(0xFF718096),
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right_rounded,
          color: Color(0xFF718096),
        ),
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        tileColor: const Color(0xFFF7FAFC),
      ),
    );
  }

  // Métodos para mostrar diálogos
  void _showFontSizeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tamaño de Fuente'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Pequeño'),
              leading: Radio(value: 'small', groupValue: 'medium', onChanged: (value) {}),
            ),
            ListTile(
              title: const Text('Mediano'),
              leading: Radio(value: 'medium', groupValue: 'medium', onChanged: (value) {}),
            ),
            ListTile(
              title: const Text('Grande'),
              leading: Radio(value: 'large', groupValue: 'medium', onChanged: (value) {}),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Aplicar'),
          ),
        ],
      ),
    );
  }

  void _showAccentColorDialog() {
    final colors = [
      {'name': 'Púrpura', 'color': const Color(0xFF7B68EE)},
      {'name': 'Azul', 'color': const Color(0xFF4C6EF5)},
      {'name': 'Verde', 'color': const Color(0xFF4ECDC4)},
      {'name': 'Naranja', 'color': const Color(0xFFFFB74D)},
      {'name': 'Rosa', 'color': const Color(0xFFE91E63)},
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Color de Acento'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: colors.map((colorInfo) => ListTile(
            leading: CircleAvatar(
              backgroundColor: colorInfo['color'] as Color,
              radius: 12,
            ),
            title: Text(colorInfo['name'] as String),
            onTap: () => Navigator.pop(context),
          )).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog() {
    final languages = ['Español', 'English', 'Français', 'Português'];
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Seleccionar Idioma'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: languages.map((lang) => ListTile(
            title: Text(lang),
            leading: Radio(
              value: lang,
              groupValue: _selectedLanguage,
              onChanged: (value) {
                setState(() {
                  _selectedLanguage = value as String;
                });
                Navigator.pop(context);
              },
            ),
          )).toList(),
        ),
      ),
    );
  }

  void _showUnitsDialog() {
    final units = ['Métrico', 'Imperial'];
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sistema de Unidades'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: units.map((unit) => ListTile(
            title: Text(unit),
            subtitle: Text(unit == 'Métrico' ? 'kg, cm, km' : 'lb, ft, mi'),
            leading: Radio(
              value: unit,
              groupValue: _selectedUnits,
              onChanged: (value) {
                setState(() {
                  _selectedUnits = value as String;
                });
                Navigator.pop(context);
              },
            ),
          )).toList(),
        ),
      ),
    );
  }

  void _showScheduleDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Horario de Recordatorios'),
        content: const Text('Configurar el horario en el que deseas recibir notificaciones de entrenamiento.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Configurar'),
          ),
        ],
      ),
    );
  }

  void _showDateFormatDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Formato de Fecha'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('DD/MM/YYYY'),
              leading: Radio(value: 'dd/mm/yyyy', groupValue: 'dd/mm/yyyy', onChanged: (value) {}),
            ),
            ListTile(
              title: const Text('MM/DD/YYYY'),
              leading: Radio(value: 'mm/dd/yyyy', groupValue: 'dd/mm/yyyy', onChanged: (value) {}),
            ),
            ListTile(
              title: const Text('YYYY-MM-DD'),
              leading: Radio(value: 'yyyy-mm-dd', groupValue: 'dd/mm/yyyy', onChanged: (value) {}),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Aplicar'),
          ),
        ],
      ),
    );
  }

  void _showSyncDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sincronización'),
        content: const Text('Configura cómo y cuándo sincronizar tus datos con la nube.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Configurar'),
          ),
        ],
      ),
    );
  }

  void _showBackupDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Copia de Seguridad'),
        content: const Text('Crear una copia de seguridad de todos tus datos y configuraciones.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Copia de seguridad creada')),
              );
            },
            child: const Text('Crear Copia'),
          ),
        ],
      ),
    );
  }

  void _showClearDataDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Limpiar Datos'),
        content: const Text('Esta acción eliminará los datos temporales y liberará espacio de almacenamiento. ¿Continuar?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Datos temporales eliminados')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Limpiar'),
          ),
        ],
      ),
    );
  }

  void _showVersionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('RitmoFit'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.fitness_center,
              size: 64,
              color: Colors.purple[400],
            ),
            const SizedBox(height: 16),
            const Text('Versión 1.0.0'),
            const SizedBox(height: 8),
            const Text('Tu compañero fitness personal'),
            const SizedBox(height: 16),
            const Text('© 2024 RitmoFit Team'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  void _showTermsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Términos y Condiciones'),
        content: const SingleChildScrollView(
          child: Text(
            'Al usar RitmoFit, aceptas nuestros términos y condiciones. Esta aplicación está diseñada para ayudarte en tu viaje fitness...',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Política de Privacidad'),
        content: const SingleChildScrollView(
          child: Text(
            'Tu privacidad es importante para nosotros. Esta política explica cómo recopilamos, usamos y protegemos tu información personal...',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  void _showRateDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Calificar RitmoFit'),
        content: const Text('¿Te gusta RitmoFit? ¡Ayúdanos calificando la app en la tienda!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Más tarde'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('¡Gracias por tu feedback!')),
              );
            },
            child: const Text('Calificar'),
          ),
        ],
      ),
    );
  }

  void _showPasswordDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cambiar Contraseña'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Contraseña actual',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Nueva contraseña',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Confirmar nueva contraseña',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Contraseña actualizada')),
              );
            },
            child: const Text('Cambiar'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cerrar Sesión'),
        content: const Text('¿Estás seguro de que quieres cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              final authProvider = Provider.of<AuthProvider>(context, listen: false);
              authProvider.logout();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Cerrar Sesión'),
          ),
        ],
      ),
    );
  }
} 