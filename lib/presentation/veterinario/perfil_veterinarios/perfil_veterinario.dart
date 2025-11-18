import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:vet_smart_ids/core/app_colors.dart';
import 'package:vet_smart_ids/models/veterinario.dart';
import 'package:vet_smart_ids/presentation/veterinario/navbar/navbar_veterinario.dart';
import 'package:vet_smart_ids/providers/veterinario_provider.dart';

// Pantalla principal para editar el perfil del usuario.
// Es StatefulWidget para gestionar los TextEditingController.
class PerfilVeterinarioScreen
    extends
        StatefulWidget {
  static const String name = 'perfil_veterinario_screen';

  const PerfilVeterinarioScreen({
    super.key,
  });

  @override
  State<
    PerfilVeterinarioScreen
  >
  createState() => _PerfilUsuarioScreenState();
}

class _PerfilUsuarioScreenState
    extends
        State<
          PerfilVeterinarioScreen
        > {
  // Controladores para la gestión de texto de los campos de entrada
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  late final TextEditingController _addressController;
  bool _isSaving = false;

  // Inicializa los controladores con datos del veterinario logeado
  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _phoneController = TextEditingController();
    _emailController = TextEditingController();
    _addressController = TextEditingController();
    
    // Cargar datos del veterinario logeado en el siguiente frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final veterinarioProvider = context.read<VeterinarioProvider>();
      final veterinario = veterinarioProvider.veterinarioActual;
      
      if (veterinario != null) {
        _nameController.text = veterinario.nombreCompleto;
        _phoneController.text = veterinario.telefono;
        _emailController.text = veterinario.email;
        _addressController.text = veterinario.especialidad;
      }
    });
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

  /// Guardar cambios del perfil en la API
  Future<void> _guardarCambios() async {
    final veterinarioProvider = context.read<VeterinarioProvider>();
    final veterinarioActual = veterinarioProvider.veterinarioActual;
    
    if (veterinarioActual == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error: No hay veterinario logeado')),
      );
      return;
    }

    // Validar que los campos no estén vacíos
    if (_nameController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _addressController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error: Todos los campos son requeridos')),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      // Crear veterinario actualizado con los nuevos datos
      final veterinarioActualizado = Veterinario(
        veterinarioId: veterinarioActual.veterinarioId,
        nombreCompleto: _nameController.text,
        email: _emailController.text,
        passwordHash: veterinarioActual.passwordHash,
        telefono: _phoneController.text,
        especialidad: _addressController.text,
        fotoUrl: veterinarioActual.fotoUrl,
      );

      // Realizar la actualización en la API
      final resultado = await veterinarioProvider.updateVeterinario(
        veterinarioActual.veterinarioId!,
        veterinarioActualizado,
      );

      if (mounted) {
        setState(() => _isSaving = false);
        
        if (resultado) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Cambios guardados exitosamente'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error al guardar: ${veterinarioProvider.errorMessage}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Consumer<VeterinarioProvider>(
      builder: (context, veterinarioProvider, _) {
        final veterinario = veterinarioProvider.veterinarioActual;
        
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new,
              ),
              onPressed: () => context.pop(),
            ),
            title: const Text(
              'Perfil de Veterinario',
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
                    CircleAvatar(
                      radius: 56,
                      backgroundImage: veterinario?.fotoUrl != null
                          ? NetworkImage(veterinario!.fotoUrl!)
                          : const NetworkImage(
                              'https://lh3.googleusercontent.com/aida-public/AB6AXuAy0Ha1zDbjCEt5BqmubRoX995XzAROhGJoNU87jSnzfP0yKm6otfPa8ejTNbRdQ9g2K0L_UykBNB_1dIBk868gzF2yTuFeqLp6qFtzi6WrdK4itesUYXCUaUfisGzPBIw2z5H-oAoLmVaMLcXNJgZj5Gt9LE-bCyM8RjkzMpQPKsMq4PeEk3FOUhnlejB7SQsdLz2Wq8MLU7zlSggWkiuFqGe0pvv7sQ-H7XK5DZk31Hq3mAc_myii6j17gf7FyfR5mJ2MOFtsQ9o',
                            ),
                      backgroundColor: AppColors.slate50Light,
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
                        // Campo Especialidad
                        _UserInfoTextField(
                          label: 'Especialidad',
                          icon: Icons.medical_services,
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
                  onPressed: _isSaving ? null : _guardarCambios,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        12.0,
                      ),
                    ),
                  ),
                  child: _isSaving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Guardar Cambios',
                        ),
                ),
              ),
            ),
          ],
          // navbar
          bottomNavigationBar: const VetNavbar(
            // Le pasamos la ruta estática para que el navbar resalte el ícono "Inicio".
            currentRoute: '/perfil_veterinarios',
          ),
        );
      },
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
