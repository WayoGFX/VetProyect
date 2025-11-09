import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vet_smart_ids/core/app_colors.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});
  static const String name = 'role_selection';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primary.withOpacity(0.1),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo o icono principal
                Icon(
                  Icons.pets,
                  size: 80,
                  color: AppColors.primary,
                ),
                const SizedBox(height: 20),

                // Título principal
                const Text(
                  'VetSmart IDS',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textLight,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),

                // Subtítulo
                const Text(
                  '¿Cómo deseas acceder?',
                  style: TextStyle(
                    fontSize: 18,
                    color: AppColors.slate500Light,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 60),

                // Tarjeta Veterinario
                _RoleCard(
                  title: 'Soy Veterinario',
                  subtitle: 'Gestiona tu clínica y pacientes',
                  icon: Icons.medical_services,
                  gradient: LinearGradient(
                    colors: [
                      Colors.blue.shade400,
                      Colors.blue.shade600,
                    ],
                  ),
                  onTap: () => context.push('/login_vet'),
                ),

                const SizedBox(height: 20),

                // Tarjeta Usuario (Dueño de mascota)
                _RoleCard(
                  title: 'Soy Dueño de Mascota',
                  subtitle: 'Cuida a tus compañeros peludos',
                  icon: Icons.pets,
                  gradient: LinearGradient(
                    colors: [
                      Colors.green.shade400,
                      Colors.green.shade600,
                    ],
                  ),
                  onTap: () => context.push('/login_usuario'),
                ),

                const Spacer(),

                // Footer opcional
                TextButton.icon(
                  onPressed: () {
                    // Aquí podrías ir a una pantalla "Acerca de" o ayuda
                  },
                  icon: const Icon(Icons.info_outline, size: 18),
                  label: const Text('¿Necesitas ayuda?'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.slate500Light,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Gradient gradient;
  final VoidCallback onTap;

  const _RoleCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Ink(
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 35, horizontal: 25),
          child: Row(
            children: [
              // Icono
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  icon,
                  size: 40,
                  color: Colors.white,
                ),
              ),

              const SizedBox(width: 20),

              // Textos
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),

              // Flecha
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.white.withOpacity(0.8),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
