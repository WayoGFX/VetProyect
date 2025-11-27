import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vet_smart_ids/core/app_colors.dart';
import 'package:vet_smart_ids/models/cita.dart';
import 'package:vet_smart_ids/presentation/usuario/navbar/navbar_usuario.dart'; // Paleta de colores de la aplicación

class GestureUser
    extends
        StatefulWidget {
  final Cita cita;

  const GestureUser({
    super.key,
    required this.cita,
  });
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

    final formattedDate = _formatFechaEspanol(widget.cita.fechaHora);
    
    final statusColor = widget.cita.estado == 'Completada' || widget.cita.estado == 'Realizada'
        ? AppColors.primary
        : AppColors.secondary;
    
    final statusText = widget.cita.estado == 'Completada' ? 'Cita realizada' : widget.cita.estado;

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
                          child: widget.cita.mascotaFotoUrl != null && widget.cita.mascotaFotoUrl!.isNotEmpty
                              ? Image.network(
                                  widget.cita.mascotaFotoUrl!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(
                                      Icons.pets,
                                      color: AppColors.primary,
                                      size: 32,
                                    );
                                  },
                                )
                              : Icon(
                                  Icons.pets,
                                  color: AppColors.primary,
                                  size: 32,
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
                            widget.cita.mascotaNombre ?? 'Mascota',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: isDark
                                  ? AppColors.white
                                  : AppColors.textLight,
                            ),
                          ),
                          Text(
                            'Cita agendada',
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
                    subtitle: formattedDate,
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
                    subtitle: widget.cita.motivo,
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
                    subtitle: widget.cita.veterinarioNombre ?? 'No asignado',
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
                        widget.cita.estado == 'Completada' || widget.cita.estado == 'Realizada'
                            ? Icons.check_circle
                            : Icons.schedule,
                        color: statusColor,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(
                        statusText,
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
                    widget.cita.citaDescripcion ?? 'Sin descripción adicional.',
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

            // Contenedor para Notas adicionales
            if (widget.cita.notas != null && widget.cita.notas!.isNotEmpty)
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
                      widget.cita.notas!,
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

  String _formatFechaEspanol(DateTime fecha) {
    const diasSemana = [
      'Lunes',
      'Martes',
      'Miércoles',
      'Jueves',
      'Viernes',
      'Sábado',
      'Domingo'
    ];
    
    const meses = [
      'Enero',
      'Febrero',
      'Marzo',
      'Abril',
      'Mayo',
      'Junio',
      'Julio',
      'Agosto',
      'Septiembre',
      'Octubre',
      'Noviembre',
      'Diciembre'
    ];
    
    final diaSemana = diasSemana[fecha.weekday - 1];
    final mes = meses[fecha.month - 1];
    final hour = fecha.hour;
    final minute = fecha.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final hour12 = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    
    return '$diaSemana, ${fecha.day} de $mes de ${fecha.year} - $hour12:$minute $period';
  }
}

