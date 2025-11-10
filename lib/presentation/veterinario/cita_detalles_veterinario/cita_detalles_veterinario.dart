import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:vet_smart_ids/core/app_colors.dart';
import 'package:vet_smart_ids/presentation/veterinario/navbar/navbar_veterinario.dart';
import 'package:vet_smart_ids/providers/cita_provider.dart';

class Gesture
    extends
        StatefulWidget {
  const Gesture({
    Key? key,
  }) : super(
         key: key,
       );
  static const String name = "cita detalle veterinario";

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
  String _formatFechaHora(
    DateTime fecha,
  ) {
    final meses = [
      '',
      'Ene',
      'Feb',
      'Mar',
      'Abr',
      'May',
      'Jun',
      'Jul',
      'Ago',
      'Sep',
      'Oct',
      'Nov',
      'Dic',
    ];
    final dias = [
      '',
      'Lun',
      'Mar',
      'Mié',
      'Jue',
      'Vie',
      'Sáb',
      'Dom',
    ];

    final hour = fecha.hour;
    final minute = fecha.minute.toString().padLeft(
      2,
      '0',
    );
    final period =
        hour >=
            12
        ? 'PM'
        : 'AM';
    final hour12 =
        hour >
            12
        ? hour -
              12
        : (hour ==
                  0
              ? 12
              : hour);

    return '${dias[fecha.weekday]}, ${fecha.day} de ${meses[fecha.month]} de ${fecha.year} - $hour12:$minute $period';
  }

  Color _getEstadoColor(
    String estado,
  ) {
    switch (estado.toLowerCase()) {
      case 'pendiente':
        return Colors.orange;
      case 'completada':
      case 'realizada':
        return Colors.green;
      case 'cancelada':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Future<
    void
  >
  _eliminarCita(
    BuildContext context,
    int citaId,
  ) async {
    final confirmed =
        await showDialog<
          bool
        >(
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
                    onPressed: () =>
                        Navigator.of(
                          context,
                        ).pop(
                          false,
                        ),
                    child: const Text(
                      'Cancelar',
                    ),
                  ),
                  TextButton(
                    onPressed: () =>
                        Navigator.of(
                          context,
                        ).pop(
                          true,
                        ),
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

    if (confirmed ==
            true &&
        mounted) {
      final citaProvider = context
          .read<
            CitaProvider
          >();
      final success = await citaProvider.deleteCita(
        citaId,
      );

      if (!mounted) return;

      if (success) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(
          const SnackBar(
            content: Text(
              'Cita eliminada exitosamente',
            ),
            backgroundColor: Colors.green,
          ),
        );
        // Recargar citas y regresar
        await citaProvider.loadCitasDelDia();
        if (mounted) context.pop();
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(
          SnackBar(
            content: Text(
              citaProvider.errorMessage ??
                  'Error al eliminar la cita',
            ),
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
    final citaProvider = context
        .watch<
          CitaProvider
        >();
    final cita = citaProvider.citaSeleccionada;

    if (cita ==
        null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Detalle de Cita',
          ),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
            ),
            onPressed: () => context.pop(),
          ),
        ),
        body: const Center(
          child: Text(
            'No se encontró información de la cita',
          ),
        ),
      );
    }

    final isDark =
        Theme.of(
          context,
        ).brightness ==
        Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.textLight
          : AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: isDark
            ? AppColors.textLight.withValues(
                alpha: 0.8,
              )
            : AppColors.backgroundLight.withValues(
                alpha: 0.8,
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
            // Información de la mascota
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
                  // Foto y nombre de la mascota
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 32,
                        backgroundColor: AppColors.primary20,
                        backgroundImage:
                            cita.mascotaFotoUrl !=
                                    null &&
                                cita.mascotaFotoUrl!.isNotEmpty
                            ? NetworkImage(
                                cita.mascotaFotoUrl!,
                              )
                            : null,
                        child:
                            cita.mascotaFotoUrl ==
                                    null ||
                                cita.mascotaFotoUrl!.isEmpty
                            ? Icon(
                                Icons.pets,
                                color: AppColors.primary,
                                size: 32,
                              )
                            : null,
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              cita.mascotaNombre ??
                                  'Mascota',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: isDark
                                    ? AppColors.white
                                    : AppColors.textLight,
                              ),
                            ),
                            if (cita.usuarioNombre !=
                                    null &&
                                cita.usuarioNombre!.isNotEmpty)
                              Text(
                                'Dueño: ${cita.usuarioNombre}',
                                style: TextStyle(
                                  color: isDark
                                      ? AppColors.slate600Light.withValues(
                                          alpha: 0.7,
                                        )
                                      : AppColors.slate600Light,
                                  fontSize: 14,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 24,
                  ),

                  // Fecha y hora
                  _infoRow(
                    icon: Icons.calendar_month,
                    iconColor: AppColors.primary,
                    title: 'Fecha y Hora',
                    subtitle: _formatFechaHora(
                      cita.fechaHora,
                    ),
                    isDark: isDark,
                  ),
                  const SizedBox(
                    height: 16,
                  ),

                  // Motivo
                  _infoRow(
                    icon: Icons.medical_services,
                    iconColor: AppColors.primary,
                    title: 'Motivo de la consulta',
                    subtitle: cita.motivo,
                    isDark: isDark,
                  ),
                  const SizedBox(
                    height: 16,
                  ),

                  // Veterinario
                  _infoRow(
                    icon: Icons.person,
                    iconColor: AppColors.primary,
                    title: 'Veterinario Asignado',
                    subtitle:
                        cita.veterinarioNombre ??
                        'No asignado',
                    isDark: isDark,
                  ),
                ],
              ),
            ),

            const SizedBox(
              height: 24,
            ),

            // Descripción (si existe)
            if (cita.citaDescripcion !=
                    null &&
                cita.citaDescripcion!.isNotEmpty) ...[
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
                          Icons.notes,
                          color: AppColors.secondary,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(
                          'Descripción',
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
                      cita.citaDescripcion!,
                      style: TextStyle(
                        color: isDark
                            ? AppColors.slate600Light.withValues(
                                alpha: 0.7,
                              )
                            : AppColors.slate600Light,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 24,
              ),
            ],

            // Notas adicionales (si existen)
            if (cita.notas !=
                    null &&
                cita.notas!.isNotEmpty) ...[
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
                      cita.notas!,
                      style: TextStyle(
                        color: isDark
                            ? AppColors.slate600Light.withValues(
                                alpha: 0.7,
                              )
                            : AppColors.slate600Light,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 24,
              ),
            ],

            // Estado de la cita
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
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color:
                          _getEstadoColor(
                            cita.estado,
                          ).withValues(
                            alpha: 0.1,
                          ),
                      borderRadius: BorderRadius.circular(
                        12,
                      ),
                      border: Border.all(
                        color: _getEstadoColor(
                          cita.estado,
                        ),
                        width: 2,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.circle,
                          size: 12,
                          color: _getEstadoColor(
                            cita.estado,
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(
                          cita.estado,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: _getEstadoColor(
                              cita.estado,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Botones de acción
            Column(
              children: [
                // Botón Editar
                ElevatedButton.icon(
                  onPressed: () {
                    context.push(
                      '/gesture_editar',
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
                // Botón Eliminar
                ElevatedButton.icon(
                  onPressed: () => _eliminarCita(
                    context,
                    cita.citaId!,
                  ),
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
                    backgroundColor: AppColors.secondary.withValues(
                      alpha: 0.7,
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
            ),
          ],
        ),
      ),
      bottomNavigationBar: const VetNavbar(
        currentRoute: '/agenda_citas',
      ),
    );
  }

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
                      ? AppColors.slate600Light.withValues(
                          alpha: 0.7,
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
