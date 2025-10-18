import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vet_smart_ids/presentation/veterinario/cita_editar/cita_editar.dart';
import 'package:vet_smart_ids/core/app_colors.dart'; // Paleta de colores de la aplicación

class Gesture
    extends
        StatefulWidget {
  const Gesture({
    Key? key,
  }) : super(
         key: key,
       );
  static const String name = "gesture";

  @override
  State<
    Gesture
  >
  createState() => _AppointmentDetailPageState();
}

class _AppointmentDetailPageState
    extends
        State<
          Gesture
        > {
  bool isDone = false; // Estado para el switch de "Cita Realizada"

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
          onPressed: () => context.pop(),
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

            // Contenedor para el estado de la cita con switch personalizado
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
                        Icons.task_alt,
                        color: AppColors.primary,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(
                        'Estado de Cita',
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'Marcar como realizado o pendiente',
                          style: TextStyle(
                            color: isDark
                                ? AppColors.slate600Light
                                : AppColors.slate600Light,
                          ),
                        ),
                      ),
                      _customSwitch(), // Switch para cambiar el estado
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(
              height: 24,
            ),

            // Contenedor para Notas adicionales
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

            // Sección de botones de acción
            Column(
              children: [
                // Botón para editar la cita
                ElevatedButton.icon(
                  onPressed: () {
                    debugPrint(
                      "Presiono boton editar",
                    );
                    // Navegar a la pantalla de editar cita
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (
                              context,
                            ) => const GestureEditar(),
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.edit,
                    color: AppColors.textLight,
                  ),
                  label: Text(
                    'Editar Cita',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textLight,
                      fontSize: 16,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    minimumSize: const Size(
                      double.infinity,
                      48,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        24,
                      ),
                    ),
                    elevation: 2,
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                // Botón para eliminar la cita
                ElevatedButton.icon(
                  onPressed: () {
                    // Muestra un diálogo de confirmación para eliminar
                    showDialog(
                      context: context,
                      builder:
                          (
                            context,
                          ) => AlertDialog(
                            title: const Text(
                              'Eliminar Cita',
                            ),
                            content: const Text(
                              '¿Estás seguro de que quieres eliminar esta cita?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  debugPrint(
                                    "Presiono boton eliminar",
                                  );
                                  Navigator.of(
                                    context,
                                  ).pop(); // Cierra el diálogo
                                },
                                child: const Text(
                                  'Cancelar',
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(
                                    context,
                                  ).pop();
                                  // Lógica para eliminar la cita
                                  ScaffoldMessenger.of(
                                    context,
                                  ).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Cita eliminada',
                                      ),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Eliminar',
                                  style: TextStyle(
                                    color: AppColors.dangerText,
                                  ),
                                ),
                              ),
                            ],
                          ),
                    );
                  },
                  icon: Icon(
                    Icons.delete,
                    color: AppColors.dangerText,
                  ),
                  label: Text(
                    'Eliminar Cita',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.dangerText,
                      fontSize: 16,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondary.withOpacity(
                      0.7,
                    ),
                    minimumSize: const Size(
                      double.infinity,
                      48,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        24,
                      ),
                    ),
                    elevation: 0,
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: 80,
            ), // espacio adicional
          ],
        ),
      ),

      // Barra de navegación inferior
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: isDark
            ? AppColors.textLight
            : AppColors.backgroundLight,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: isDark
            ? AppColors.slate600Light
            : AppColors.slate600Light,
        currentIndex: 2, // Posiciona en "Citas"
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.pets,
            ),
            label: 'Pacientes',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.calendar_month,
            ),
            label: 'Citas',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.notifications,
            ),
            label: 'Recordatorios',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
            ),
            label: 'Perfil',
          ),
        ],
        onTap:
            (
              index,
            ) {
              // Navegación principal
              switch (index) {
                case 0:
                  Navigator.pushNamed(
                    context,
                    '/home',
                  );
                  break;
                case 1:
                  Navigator.pushNamed(
                    context,
                    '/pacientes',
                  );
                  break;
                case 2:
                  // Ya estamos en "Citas"
                  break;
                case 3:
                  Navigator.pushNamed(
                    context,
                    '/recordatorios',
                  );
                  break;
                case 4:
                  Navigator.pushNamed(
                    context,
                    '/perfil',
                  );
                  break;
              }
            },
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

  // Switch personalizado para alternar el estado de la cita
  Widget _customSwitch() {
    return GestureDetector(
      onTap: () {
        setState(
          () {
            isDone = !isDone; // Invierte el estado
          },
        );
      },
      child: AnimatedContainer(
        duration: const Duration(
          milliseconds: 300,
        ),
        width: 130,
        height: 40,
        decoration: BoxDecoration(
          color: isDone
              ? AppColors.primary
              : AppColors.secondary, // Color según el estado
          borderRadius: BorderRadius.circular(
            40,
          ),
        ),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(
                milliseconds: 300,
              ),
              curve: Curves.easeInOut,
              left: isDone
                  ? 58
                  : 4, // Posición del selector
              top: 4,
              bottom: 4,
              child: Container(
                width: 65,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(
                    32,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  isDone
                      ? 'Realizado'
                      : 'Pendiente', // Texto según el estado
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: isDone
                        ? const Color(
                            0xFF3B82F6,
                          )
                        : const Color(
                            0xFFD9534F,
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
