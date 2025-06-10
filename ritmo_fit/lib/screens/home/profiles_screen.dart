import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ritmo_fit/providers/auth_provider.dart';
import 'package:ritmo_fit/providers/profile_provider.dart';
import 'package:ritmo_fit/models/user_model.dart';

class ProfilesScreen extends StatefulWidget {
  const ProfilesScreen({super.key});

  @override
  State<ProfilesScreen> createState() => _ProfilesScreenState();
}

class _ProfilesScreenState extends State<ProfilesScreen> {
  @override
  void initState() {
    super.initState();
    _loadProfiles();
  }

  Future<void> _loadProfiles() async {
    final user = Provider.of<AuthProvider>(context, listen: false).currentUser;
    if (user != null) {
      await Provider.of<ProfileProvider>(context, listen: false)
          .loadProfiles(user.id);
    }
  }

  Future<void> _showAddProfileDialog() async {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final ageController = TextEditingController();
    final weightController = TextEditingController();
    final heightController = TextEditingController();
    String selectedGender = 'M';

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nuevo Perfil'),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nombre',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese un nombre';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: ageController,
                  decoration: const InputDecoration(
                    labelText: 'Edad',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese la edad';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Por favor ingrese un número válido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedGender,
                  decoration: const InputDecoration(
                    labelText: 'Género',
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'M',
                      child: Text('Masculino'),
                    ),
                    DropdownMenuItem(
                      value: 'F',
                      child: Text('Femenino'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      selectedGender = value;
                    }
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: weightController,
                  decoration: const InputDecoration(
                    labelText: 'Peso (kg)',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese el peso';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Por favor ingrese un número válido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: heightController,
                  decoration: const InputDecoration(
                    labelText: 'Estatura (m)',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese la estatura';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Por favor ingrese un número válido';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                final user = Provider.of<AuthProvider>(context, listen: false).currentUser;
                if (user != null) {
                  await Provider.of<ProfileProvider>(context, listen: false).addProfile(
                    userId: user.id,
                    name: nameController.text,
                    age: int.parse(ageController.text),
                    gender: selectedGender,
                    weight: double.parse(weightController.text),
                    height: _parseHeight(heightController.text),
                  );
                }
                if (!mounted) return;
                Navigator.of(context).pop();
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  Future<void> _showEditProfileDialog(Profile profile) async {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: profile.name);
    final ageController = TextEditingController(text: profile.age.toString());
    final weightController = TextEditingController(text: profile.weight.toString());
    final heightController = TextEditingController(text: profile.height.toString());
    String selectedGender = profile.gender;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar Perfil'),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nombre',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese un nombre';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: ageController,
                  decoration: const InputDecoration(
                    labelText: 'Edad',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese la edad';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Por favor ingrese un número válido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedGender,
                  decoration: const InputDecoration(
                    labelText: 'Género',
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'M',
                      child: Text('Masculino'),
                    ),
                    DropdownMenuItem(
                      value: 'F',
                      child: Text('Femenino'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      selectedGender = value;
                    }
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: weightController,
                  decoration: const InputDecoration(
                    labelText: 'Peso (kg)',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese el peso';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Por favor ingrese un número válido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: heightController,
                  decoration: const InputDecoration(
                    labelText: 'Estatura (m)',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese la estatura';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Por favor ingrese un número válido';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                final user = Provider.of<AuthProvider>(context, listen: false).currentUser;
                if (user != null) {
                  await Provider.of<ProfileProvider>(context, listen: false).updateProfile(
                    userId: user.id,
                    profileId: profile.id,
                    name: nameController.text,
                    age: int.parse(ageController.text),
                    gender: selectedGender,
                    weight: double.parse(weightController.text),
                    height: _parseHeight(heightController.text),
                  );
                }
                if (!mounted) return;
                Navigator.of(context).pop();
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);
    final profiles = profileProvider.profiles;

    return Scaffold(
      body: profiles.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'No hay perfiles creados',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _showAddProfileDialog,
                    child: const Text('Crear Perfil'),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: profiles.length,
              itemBuilder: (context, index) {
                final profile = profiles[index];
                final isSelected = profileProvider.selectedProfile?.id == profile.id;

                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: ListTile(
                    title: Text(profile.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Edad: ${profile.age} años'),
                        Text('Género: ${profile.gender == 'M' ? 'Masculino' : 'Femenino'}'),
                        Text('IMC: ${profile.bmi.toStringAsFixed(2)} (${profile.bmiCategory})'),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (isSelected)
                          const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                          ),
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            _showEditProfileDialog(profile);
                          },
                        ),
                      ],
                    ),
                    onTap: () {
                      profileProvider.selectProfile(profile);
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddProfileDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}

double _parseHeight(String value) {
  final h = double.tryParse(value.replaceAll(',', '.')) ?? 0.0;
  if (h > 3.0) {
    // Si el usuario ingresa centímetros, convertir a metros
    return h / 100.0;
  }
  return h;
} 