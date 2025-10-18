import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vet_smart_ids/core/app_colors.dart';
import 'package:vet_smart_ids/presentation/usuario/navbar/navbar_usuario.dart'; // Paleta de colores de la aplicación

class GestureUser
    extends
        StatefulWidget {
  const GestureUser({
    Key? key,
  }) : super(
         key: key,
       );
  static const String name = "cita detalle usuario";

  @override
  State<
    GestureUser
  >
  createState() => _AppointmentDetailPageState();
}

class _AppointmentDetailPageState
    extends
        State<
          GestureUser
        > {
  @override
  Widget build(
    BuildContext context,
  ) {
    final isDark =
        Theme.of(
          context,
        ).brightness ==
        Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.textLight
          : AppColors.backgroundLight, // Define el color de fondo
      appBar: AppBar(
        backgroundColor: isDark
            ? AppColors.textLight.withOpacity(
                0.8,
              )
            : AppColors.backgroundLight.withOpacity(
                0.8,
              ),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: isDark
                ? AppColors.white
                : AppColors.black,
          ),
          onPressed: () {
            context.pop();
          },
        ),
        title: Text(
          'Resumen de la Cita',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDark
                ? AppColors.white
                : AppColors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(
          16,
        ),
        child: ListView(
          children: [
            // Contenedor principal con información de la cita
            Container(
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.textLight
                    : AppColors.cardLight,
                borderRadius: BorderRadius.circular(
                  24,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isDark
                        ? Colors.black26
                        : AppColors.black05, // Sombra para elevación
                    blurRadius: 10,
                  ),
                ],
              ),
              padding: const EdgeInsets.all(
                24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Fila de información de la mascota: foto, nombre y raza
                  Row(
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: AppColors.primary20,
                          borderRadius: BorderRadius.circular(
                            9999,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                            9999,
                          ),
                          child: Image.network(
                            'https://lh3.googleusercontent.com/aida-public/AB6AXuBQWtZBWDo8FaFdszSnQZ1A1sz5LOz27ekmfaJiFeaWWld8DosqR5HWTG7CvKd4SHkqf6U8NupB41JAewX6eU_jCFIazCf65dfH6DDo9EFPSgG4aSRkGE6qgRgS4qKcvGe4w42QS3VflJqm3AULCJRs5FVofXS6N36V9uAPOCyLWv946ROYgj1GFZEHkMsBsbeL5Gozo_sJZhsDSa06_dctXmhwnswjjg_m_XDaBbditOqYMxpXn7OTjIZYLjFSAPo5K45EkcVGrjk',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Max',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: isDark
                                  ? AppColors.white
                                  : AppColors.textLight,
                            ),
                          ),
                          Text(
                            'Golden Retriever',
                            style: TextStyle(
                              color: isDark
                                  ? AppColors.slate600Light.withOpacity(
                                      0.7,
                                    )
                                  : AppColors.slate600Light,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 24,
                  ),

                  // Fila: Fecha y hora de la cita
                  _infoRow(
                    icon: Icons.calendar_month,
                    iconColor: AppColors.primary,
                    title: 'Fecha y Hora',
                    subtitle: 'Lunes, 20 de Mayo de 2024 - 10:30 AM',
                    isDark: isDark,
                  ),
                  const SizedBox(
                    height: 16,
                  ),

                  // Fila: Motivo de la consulta
                  _infoRow(
                    icon: Icons.medical_services,
                    iconColor: AppColors.primary,
                    title: 'Motivo de la consulta',
                    subtitle: 'Chequeo anual y vacunación',
                    isDark: isDark,
                  ),
                  const SizedBox(
                    height: 16,
                  ),

                  // Fila: Veterinario asignado
                  _infoRow(
                    icon: Icons.person,
                    iconColor: AppColors.primary,
                    title: 'Veterinario Asignado',
                    subtitle: 'Dr. Carlos Rodriguez',
                    isDark: isDark,
                  ),
                ],
              ),
            ),

            const SizedBox(
              height: 24,
            ),

            // Contenedor para el estado de la cita - Ahora fijo a 'Cita realizada'
            Container(
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.textLight
                    : AppColors.cardLight,
                borderRadius: BorderRadius.circular(
                  24,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isDark
                        ? Colors.black26
                        : AppColors.black05,
                    blurRadius: 10,
                  ),
                ],
              ),
              padding: const EdgeInsets.all(
                24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.check_circle, // Icono de completado
                        color: AppColors.primary,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(
                        'Cita realizada', // Título modificado
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: isDark
                              ? AppColors.white
                              : AppColors.textLight,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  // Resumen de la cita realizada
                  Text(
                    'El chequeo anual y la vacunación fueron completados satisfactoriamente.',
                    style: TextStyle(
                      color: isDark
                          ? AppColors.slate600Light.withOpacity(
                              0.7,
                            )
                          : AppColors.slate600Light,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(
              height: 24,
            ),

            // Contenedor para Notas adicionales (Sin cambios)
            Container(
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.textLight
                    : AppColors.cardLight,
                borderRadius: BorderRadius.circular(
                  24,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isDark
                        ? Colors.black26
                        : AppColors.black05,
                    blurRadius: 10,
                  ),
                ],
              ),
              padding: const EdgeInsets.all(
                24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.description,
                        color: AppColors.secondary,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(
                        'Notas Adicionales',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: isDark
                              ? AppColors.white
                              : AppColors.textLight,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Text(
                    'Max ha estado un poco decaído últimamente y ha perdido el apetito. Traer muestra de heces para análisis. Recordar revisar la cadera izquierda, mostró sensibilidad al tacto',
                    style: TextStyle(
                      color: isDark
                          ? AppColors.slate600Light.withOpacity(
                              0.7,
                            )
                          : AppColors.slate600Light,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(
              height: 32,
            ),

            const SizedBox(
              height: 80,
            ),
          ],
        ),
      ),

      // navbar
      bottomNavigationBar: const UserNavbar(
        // Le pasamos la ruta estática para que el navbar resalte el ícono "Inicio".
        currentRoute: '/ficha_paciente',
      ),
    );
  }

  // Widget reutilizable para mostrar un ícono con título y subtítulo
  Widget _infoRow({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required bool isDark,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: iconColor,
          size: 24,
        ),
        const SizedBox(
          width: 16,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isDark
                      ? AppColors.white
                      : AppColors.textLight,
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                subtitle,
                style: TextStyle(
                  color: isDark
                      ? AppColors.slate600Light.withOpacity(
                          0.7,
                        )
                      : AppColors.slate600Light,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
