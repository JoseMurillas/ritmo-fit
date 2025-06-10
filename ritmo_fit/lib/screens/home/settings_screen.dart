import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ritmo_fit/providers/auth_provider.dart';
import 'package:ritmo_fit/providers/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).currentUser;

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.person),
              ),
              title: Text(user?.name ?? 'Usuario'),
              subtitle: Text(user?.email ?? ''),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.notifications),
                  title: const Text('Notificaciones'),
                  trailing: Switch(
                    value: true, // TODO: Implementar estado de notificaciones
                    onChanged: (value) {
                      // TODO: Implementar cambio de estado de notificaciones
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Funcionalidad de notificaciones próximamente'),
                        ),
                      );
                    },
                  ),
                ),
                const Divider(),
                Consumer<ThemeProvider>(
                  builder: (context, themeProvider, child) {
                    return ListTile(
                      leading: Icon(
                        themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                      ),
                      title: const Text('Modo Oscuro'),
                      trailing: Switch(
                        value: themeProvider.isDarkMode,
                        onChanged: (value) {
                          themeProvider.setDarkMode(value);
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.info),
                  title: const Text('Acerca de'),
                  onTap: () {
                    showAboutDialog(
                      context: context,
                      applicationName: 'RitmoFit',
                      applicationVersion: '1.0.0',
                      applicationIcon: const FlutterLogo(size: 64),
                      children: const [
                        Text(
                          'RitmoFit es una aplicación de gestión de gimnasio que te ayuda a mantener un registro de tus rutinas y progreso.',
                        ),
                      ],
                    );
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.help),
                  title: const Text('Ayuda'),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Ayuda'),
                        content: const Text(
                          '¿Necesitas ayuda?\n\n'
                          '• Crea perfiles para diferentes usuarios\n'
                          '• Genera rutinas personalizadas según tu IMC\n'
                          '• Participa en el foro de la comunidad\n'
                          '• Cambia el tema en configuración\n\n'
                          'Para más información, contacta al soporte.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cerrar'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Cerrar Sesión'),
              onTap: () async {
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Cerrar Sesión'),
                    content: const Text('¿Estás seguro de que deseas cerrar sesión?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text('Cancelar'),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const Text('Cerrar Sesión'),
                      ),
                    ],
                  ),
                );

                if (confirmed == true) {
                  await Provider.of<AuthProvider>(context, listen: false).logout();
                  if (!context.mounted) return;
                  Navigator.of(context).pushReplacementNamed('/login');
                }
              },
            ),
          ),
        ],
      ),
    );
  }
} 