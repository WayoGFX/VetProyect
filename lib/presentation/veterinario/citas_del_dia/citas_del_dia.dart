// Paquete principal de Flutter
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:vet_smart_ids/core/app_colors.dart';
import 'package:vet_smart_ids/presentation/veterinario/navbar/navbar_veterinario.dart';
import 'package:vet_smart_ids/providers/cita_provider.dart';
import 'package:vet_smart_ids/models/cita.dart';

// pantalla principal

// Pantalla de inicio que muestra citas y alertas diarias
class CitasDelDiaScreen extends StatefulWidget {
  // Identificador de la ruta
  static const String name = 'vistas_citas_del_dia_screen';

  const CitasDelDiaScreen({super.key});

  @override
  State<CitasDelDiaScreen> createState() => _CitasDelDiaScreenState();
}

// Clase que maneja el estado principal
class _CitasDelDiaScreenState extends State<CitasDelDiaScreen> {
  @override
  void initState() {
    super.initState();
    // Cargar las citas del día al iniciar la pantalla
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CitaProvider>().loadCitasDelDia();
    });
  }

  // Contar citas de hoy
  int _contarCitasHoy(List<Cita> citas) {
    final ahora = DateTime.now();
    final hoy = DateTime(ahora.year, ahora.month, ahora.day);

    return citas.where((c) {
      final fechaCita = DateTime(c.fechaHora.year, c.fechaHora.month, c.fechaHora.day);
      return fechaCita.isAtSameMomentAs(hoy);
    }).length;
  }

  // Formatear rango de la semana (Lun - Dom)
  String _formatRangoSemana() {
    final ahora = DateTime.now();
    final manana = ahora.add(const Duration(days: 1));

    // Encontrar el domingo de esta semana
    final diasHastaDomingo = DateTime.sunday - ahora.weekday;
    final finSemana = DateTime(ahora.year, ahora.month, ahora.day)
        .add(Duration(days: diasHastaDomingo >= 0 ? diasHastaDomingo : diasHastaDomingo + 7));

    final meses = ['', 'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'];

    return '${manana.day} ${meses[manana.month]} - ${finSemana.day} ${meses[finSemana.month]}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,

      // AppBar de la pantalla
      appBar: AppBar(
        backgroundColor: AppColors.backgroundLight.withOpacity(0.8),
        elevation: 0,
        title: Text(
          'VetSmart',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.notifications_none,
              color: AppColors.textLight,
            ),
            onPressed: () => context.pop(),
          ),
        ],
      ),

      // Contenido principal de la pantalla con scroll
      body: Consumer<CitaProvider>(
        builder: (context, citaProvider, child) {
          // Estado de carga
          if (citaProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // Estado de error
          if (citaProvider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red.shade300,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error al cargar las citas',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    citaProvider.errorMessage!,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.slate500Light),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => citaProvider.loadCitasDelDia(),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }

          final citasDelDia = citaProvider.citas;

          return RefreshIndicator(
            onRefresh: () => citaProvider.loadCitasDelDia(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Sección de Citas
                  const _SectionTitle(title: 'Próximas citas'),

                  // Mostrar citas o mensaje si no hay
                  if (citasDelDia.isEmpty)
                    Card(
                      elevation: 1,
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Center(
                          child: Column(
                            children: [
                              Icon(
                                Icons.event_available,
                                size: 48,
                                color: AppColors.slate500Light,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'No hay citas programadas para hoy',
                                style: TextStyle(
                                  color: AppColors.slate500Light,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  else
                    ...citasDelDia.map(
                      (cita) => _AppointmentCard(cita: cita),
                    ),

                  const SizedBox(height: 24),

                  // Sección de Estadística
                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          title: 'Para hoy',
                          value: _contarCitasHoy(citasDelDia).toString(),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _StatCard(
                          title: 'Esta semana',
                          value: citaProvider.citasProximasSemana.length.toString(),
                          subtitle: _formatRangoSemana(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  //Sección de Acceso Rápido con botones
                  const _SectionTitle(title: 'Acceso rápido'),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => context.push('/crear_cita'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: AppColors.textLight,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            textStyle: Theme.of(context).textTheme.titleMedium,
                          ),
                          child: const Text('Nueva cita'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => context.push('/nuevo_paciente'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary20,
                            foregroundColor: AppColors.textLight,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            textStyle: Theme.of(context).textTheme.titleMedium,
                          ),
                          child: const Text('Nuevo paciente'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: const VetNavbar(
        currentRoute: '/agenda_citas',
      ),
    );
  }
}

// ----------------------------------------------------
// widget que se reutilizan

// Widget para el título de cada sección
class _SectionTitle
    extends
        StatelessWidget {
  final String title;
  const _SectionTitle({
    required this.title,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 16.0,
      ),
      child: Text(
        title,
        style:
            Theme.of(
              context,
            ).textTheme.titleMedium!.copyWith(
              fontSize: 22,
            ),
      ),
    );
  }
}

// Tarjeta individual para una cita
class _AppointmentCard extends StatelessWidget {
  final Cita cita;

  const _AppointmentCard({required this.cita});

  String _formatFechaHora(DateTime fecha) {
    final ahora = DateTime.now();
    final hoy = DateTime(ahora.year, ahora.month, ahora.day);
    final fechaCita = DateTime(fecha.year, fecha.month, fecha.day);

    final hour = fecha.hour;
    final minute = fecha.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final hour12 = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    final horaStr = '$hour12:$minute $period';

    // Si es hoy, solo mostrar hora
    if (fechaCita.isAtSameMomentAs(hoy)) {
      return 'Hoy - $horaStr';
    }

    // Si es mañana
    final manana = hoy.add(const Duration(days: 1));
    if (fechaCita.isAtSameMomentAs(manana)) {
      return 'Mañana - $horaStr';
    }

    // Otros días: mostrar día/mes - hora
    final meses = ['', 'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'];
    return '${fecha.day} ${meses[fecha.month]} - $horaStr';
  }

  Color _getEstadoColor(String estado) {
    switch (estado.toLowerCase()) {
      case 'pendiente':
        return Colors.orange;
      case 'completada':
        return Colors.green;
      case 'cancelada':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Título: Nombre mascota - Motivo
    final titulo = cita.mascotaNombre != null
        ? '${cita.mascotaNombre} - ${cita.motivo}'
        : cita.motivo;

    return InkWell(
      onTap: () {
        // Seleccionar la cita y navegar (GET general ya incluye citaDescripcion y notas)
        context.read<CitaProvider>().selectCita(cita);
        context.push('/cita_detalles_veterinario');
      },
      borderRadius: BorderRadius.circular(12),
      child: Card(
        elevation: 1,
        margin: const EdgeInsets.only(bottom: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              // Imagen de la mascota (desde URL o placeholder)
              CircleAvatar(
                radius: 28,
                backgroundColor: AppColors.primary20,
                backgroundImage: cita.mascotaFotoUrl != null && cita.mascotaFotoUrl!.isNotEmpty
                    ? NetworkImage(cita.mascotaFotoUrl!)
                    : null,
                child: cita.mascotaFotoUrl == null || cita.mascotaFotoUrl!.isEmpty
                    ? Icon(
                        Icons.pets,
                        color: AppColors.primary,
                        size: 28,
                      )
                    : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nombre mascota - Motivo
                    Text(
                      titulo,
                      style: Theme.of(context).textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    // Fecha y hora
                    Text(
                      _formatFechaHora(cita.fechaHora),
                      style: TextStyle(
                        color: AppColors.slate500Light,
                        fontSize: 14,
                      ),
                    ),
                    if (cita.citaDescripcion != null &&
                        cita.citaDescripcion!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        cita.citaDescripcion!,
                        style: TextStyle(
                          color: AppColors.slate500Light,
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Badge de estado
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getEstadoColor(cita.estado).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _getEstadoColor(cita.estado),
                    width: 1,
                  ),
                ),
                child: Text(
                  cita.estado,
                  style: TextStyle(
                    color: _getEstadoColor(cita.estado),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Tarjeta de estadística como pacientes activos
class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;

  const _StatCard({
    required this.title,
    required this.value,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontSize: 16,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.displaySmall!.copyWith(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 4),
              Text(
                subtitle!,
                style: TextStyle(
                  color: AppColors.slate500Light,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
