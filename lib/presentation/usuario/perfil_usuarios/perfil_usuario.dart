import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vet_smart_ids/core/app_colors.dart';
import 'package:vet_smart_ids/presentation/usuario/navbar/navbar_usuario.dart';

// Pantalla principal para editar el perfil del usuario.
// Es StatefulWidget para gestionar los TextEditingController.
class PerfilUsuarioScreen
    extends
        StatefulWidget {
  static const String name = 'perfil_usuario_screen';

  const PerfilUsuarioScreen({
    super.key,
  });

  @override
  State<
    PerfilUsuarioScreen
  >
  createState() => _PerfilUsuarioScreenState();
}

class _PerfilUsuarioScreenState
    extends
        State<
          PerfilUsuarioScreen
        > {
  // Controladores para la gestión de texto de los campos de entrada
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  late final TextEditingController _addressController;

  // Inicializa los controladores con datos mock
  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: 'Ana García',
    );
    _phoneController = TextEditingController(
      text: '+34 612 345 678',
    );
    _emailController = TextEditingController(
      text: 'ana.garcia@email.com',
    );
    _addressController = TextEditingController(
      text: 'Calle de la Alegría, 123, Madrid',
    );
  }

  // Elimina los controladores para liberar memoria cuando el widget se destruye
  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
          ),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Perfil de Usuario',
        ),
        centerTitle: true,
      ),
      // Permite el desplazamiento de todo el contenido
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(
          16.0,
        ),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            // Stack para superponer el avatar y el botón de la cámara
            Stack(
              children: [
                const CircleAvatar(
                  radius: 56,
                  backgroundImage: NetworkImage(
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuAy0Ha1zDbjCEt5BqmubRoX995XzAROhGJoNU87jSnzfP0yKm6otfPa8ejTNbRdQ9g2K0L_UykBNB_1dIBk868gzF2yTuFeqLp6qFtzi6WrdK4itesUYXCUaUfisGzPBIw2z5H-oAoLmVaMLcXNJgZj5Gt9LE-bCyM8RjkzMpQPKsMq4PeEk3FOUhnlejB7SQsdLz2Wq8MLU7zlSggWkiuFqGe0pvv7sQ-H7XK5DZk31Hq3mAc_myii6j17gf7FyfR5mJ2MOFtsQ9o',
                  ),
                ),
                // Botón de cámara posicionado en la esquina inferior derecha
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.black05,
                          spreadRadius: 1,
                          blurRadius: 3,
                        ),
                      ],
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(
                        8.0,
                      ),
                      child: Icon(
                        Icons.photo_camera,
                        color: AppColors.textLight,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 24,
            ),
            // Tarjeta que contiene los campos de formulario
            Card(
              elevation: 2,
              shadowColor: AppColors.black05,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  16.0,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(
                  24.0,
                ),
                child: Column(
                  children: [
                    // Campo Nombre
                    _UserInfoTextField(
                      label: 'Nombre',
                      icon: Icons.person,
                      controller: _nameController,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    // Campo Teléfono
                    _UserInfoTextField(
                      label: 'Teléfono',
                      icon: Icons.phone,
                      controller: _phoneController,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    // Campo Correo Electrónico
                    _UserInfoTextField(
                      label: 'Correo Electrónico',
                      icon: Icons.email,
                      controller: _emailController,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    // Campo Dirección
                    _UserInfoTextField(
                      label: 'Dirección',
                      icon: Icons.home,
                      controller: _addressController,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      // Botón de guardar cambios fijo en la parte inferior
      persistentFooterButtons: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 8.0,
          ),
          child: SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                // Lógica para guardar los datos | ahorita es solo visual
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    12.0,
                  ),
                ),
              ),
              child: const Text(
                'Guardar Cambios',
              ),
            ),
          ),
        ),
      ],
      // navbar
      bottomNavigationBar: const UserNavbar(
        // Le pasamos la ruta estática para que el navbar resalte el ícono "Inicio".
        currentRoute: '/perfil_usuario',
      ),
    );
  }
}

// Widget reutilizable para un campo de texto con etiqueta e ícono
class _UserInfoTextField
    extends
        StatelessWidget {
  final String label;
  final IconData icon;
  final TextEditingController controller;

  const _UserInfoTextField({
    required this.label,
    required this.icon,
    required this.controller,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style:
              Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: AppColors.slate600Light,
              ),
        ),
        const SizedBox(
          height: 8,
        ),
        TextFormField(
          controller: controller, // Vincula el controlador
          style: Theme.of(
            context,
          ).textTheme.bodyMedium,
          decoration: InputDecoration(
            prefixIcon: Icon(
              icon,
              color: AppColors.slate500Light,
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 12.0,
              horizontal: 16.0,
            ),
            filled: true,
            fillColor:
                Theme.of(
                  context,
                ).scaffoldBackgroundColor.withBlue(
                  250,
                ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                8.0,
              ),
              borderSide: BorderSide.none, // Sin borde por defecto
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                8.0,
              ),
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 2.0,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
