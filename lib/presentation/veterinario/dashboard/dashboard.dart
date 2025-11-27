import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:vet_smart_ids/core/app_colors.dart';
import 'package:vet_smart_ids/presentation/veterinario/navbar/navbar_veterinario.dart';
import 'package:vet_smart_ids/providers/cita_provider.dart';
import 'package:vet_smart_ids/providers/mascota_provider.dart';
import 'package:vet_smart_ids/providers/estadisticas_provider.dart';
import 'package:vet_smart_ids/providers/alertas_provider.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});
  static const String name = "dashboard";

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  void initState() {
    super.initState();
    // Usar addPostFrameCallback para cargar datos después del build
    // Esto evita el error "setState() called during build"
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadDashboardData();
    });
  }

  Future<void> _loadDashboardData() async {
    final citaProvider = context.read<CitaProvider>();
    final mascotaProvider = context.read<MascotaProvider>();
    final estadisticasProvider = context.read<EstadisticasProvider>();
    final alertasProvider = context.read<AlertasProvider>();
    
    await Future.wait([
      citaProvider.loadCitas(),
      mascotaProvider.loadMascotas(),
      estadisticasProvider.loadEstadisticas(),
      alertasProvider.loadAlertas(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    // Determina si el tema actual es oscuro
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      // Establece el color de fondo según el tema
      backgroundColor:
          isDark ? AppColors.black : AppColors.backgroundLight,
      appBar: AppBar(
        // Color de fondo del AppBar con ligera opacidad para efecto de scroll
        backgroundColor: isDark
            ? AppColors.black.withOpacity(0.8)
            : AppColors.backgroundLight.withOpacity(0.8),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
          ),
          onPressed: () => context.pop(),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.notifications_none,
              color: isDark ? AppColors.white : AppColors.textLight,
            ),
            onPressed: () => context.pop(),
          ),
        ],
      ),
      body: const DashboardContent(),
      bottomNavigationBar: const VetNavbar(
        // Le pasamos la ruta estática para que el navbar resalte el ícono "Inicio".
        currentRoute: '/dashboard',
      ),
    );
  }
}

class DashboardContent extends StatelessWidget {
  const DashboardContent({super.key});

  @override
  Widget build(BuildContext context) {
    // Permite que el contenido se desplace
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          TodayAppointments(),
          SizedBox(height: 24),
          DashboardStats(),
          SizedBox(height: 24),
          AlertsSection(),
          SizedBox(height: 24),
          ActivePatientsSection(),
          SizedBox(height: 24),
          QuickAccessSection(),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}

class TodayAppointments extends StatelessWidget {
  const TodayAppointments({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CitaProvider>(
      builder: (context, citaProvider, _) {
        // Filtrar citas de hoy
        final ahora = DateTime.now();
        final hoy = DateTime(ahora.year, ahora.month, ahora.day);
        final manana = hoy.add(const Duration(days: 1));

        final citasHoy = citaProvider.citas.where((cita) {
          return cita.fechaHora.isAfter(hoy) && cita.fechaHora.isBefore(manana);
        }).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Citas de Hoy',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            // Lista horizontal de citas
            if (citasHoy.isEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Text(
                    'No hay citas para hoy',
                    style: TextStyle(
                      color: AppColors.slate500Light,
                    ),
                  ),
                ),
              )
            else
              SizedBox(
                height: 205,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: citasHoy.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 16),
                  itemBuilder: (context, index) {
                    final cita = citasHoy[index];
                    return Container(
                      width: 160,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Imagen del paciente
                          AspectRatio(
                            aspectRatio: 1,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: cita.mascotaFotoUrl != null &&
                                      cita.mascotaFotoUrl!.isNotEmpty
                                  ? Image.network(
                                      cita.mascotaFotoUrl!,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Container(
                                          color: AppColors.slate50Light,
                                          child: const Icon(Icons.pets),
                                        );
                                      },
                                    )
                                  : Container(
                                      color: AppColors.slate50Light,
                                      child: const Icon(Icons.pets),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            cita.mascotaNombre ?? 'Mascota',
                            style:
                                const TextStyle(fontWeight: FontWeight.w600),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Flexible(
                            child: Text(
                              '${cita.fechaHora.hour.toString().padLeft(2, '0')}:${cita.fechaHora.minute.toString().padLeft(2, '0')}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.slate500Light,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
          ],
        );
      },
    );
  }
}

class DashboardStats extends StatelessWidget {
  const DashboardStats({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<EstadisticasProvider>(
      builder: (context, estadisticasProvider, _) {
        final stats = estadisticasProvider.tiposAnimales;
        final colors = estadisticasProvider.tiposAnimalesColors;
        final enfermedades = estadisticasProvider.enfermedadesComunes;
        final enfermedadesColores = estadisticasProvider.enfermedadesColores;
        final isLoading = estadisticasProvider.isLoading;

        if (isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Estadísticas',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              // Contenedor principal de estadísticas con fondo de tarjeta
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Encabezado de la sección de tipos de animales
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('Tipos de Animales',
                          style: TextStyle(fontWeight: FontWeight.w600)),
                      Text('Últimos 30 días',
                          style: TextStyle(
                            color: AppColors.slate500Light,
                            fontSize: 12,
                          )),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Gráfica de barras de tipos de animales
                  stats.isEmpty
                      ? const Center(
                          child: Text('No hay datos de mascotas'),
                        )
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: stats.entries.map((entry) {
                            return Expanded(
                              child: Column(
                                children: [
                                  // Barra de la gráfica
                                  Container(
                                    height: 120 * entry.value,
                                    width: 20,
                                    decoration: BoxDecoration(
                                      color: colors[entry.key],
                                      borderRadius: const BorderRadius.vertical(
                                          top: Radius.circular(8)),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  // Etiqueta de la barra
                                  Text(
                                    entry.key,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: AppColors.slate500Light,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 4),
                                  // Porcentaje
                                  Text(
                                    '${(entry.value * 100).toStringAsFixed(0)}%',
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.slate500Light,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                  const SizedBox(height: 24),
                  // Sección de enfermedades comunes
                  const Text('Enfermedades Comunes',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: enfermedades.entries.map((entry) {
                      final color = enfermedadesColores[entry.key] ?? const Color(0xFFC1EFFF);
                      final porcentaje = (entry.value * 100).toStringAsFixed(0);
                      return DiseaseLegend(
                        color: color,
                        label: '${entry.key} ($porcentaje%)',
                      );
                    }).toList(),
                  )
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class DiseaseLegend extends StatelessWidget {
  final Color color;
  final String label;

  const DiseaseLegend({
    super.key,
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    // Leyenda de una enfermedad
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          // Icono de color circular
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          // Nombre de la enfermedad y porcentaje
          Text(
            label,
            style: const TextStyle(fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class AlertsSection extends StatelessWidget {
  const AlertsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AlertasProvider>(
      builder: (context, alertasProvider, _) {
        final alertas = alertasProvider.alertas;
        final isLoading = alertasProvider.isLoading;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Alertas',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            // Muestra las alertas en Cards
            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else if (alertas.isEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Text(
                    'No hay alertas próximas',
                    style: TextStyle(
                      color: AppColors.slate500Light,
                    ),
                  ),
                ),
              )
            else
              Column(
                children: alertas.map((alerta) {
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      // Icono de la alerta
                      leading: CircleAvatar(
                        backgroundColor: alerta.color.withOpacity(0.2),
                        child: Icon(
                          alerta.icono,
                          color: alerta.color,
                        ),
                      ),
                      title: Text(alerta.titulo),
                      subtitle: Text(alerta.subtitulo),
                    ),
                  );
                }).toList(),
              ),
          ],
        );
      },
    );
  }
}

class ActivePatientsSection extends StatelessWidget {
  const ActivePatientsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MascotaProvider>(
      builder: (context, mascotaProvider, _) {
        final mascotas = mascotaProvider.mascotas;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pacientes Activos',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            // Muestra los pacientes en una lista
            if (mascotas.isEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Text(
                    'No hay pacientes registrados',
                    style: TextStyle(
                      color: AppColors.slate500Light,
                    ),
                  ),
                ),
              )
            else
              Column(
                children: mascotas.take(5).map((mascota) {
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    // Avatar con la imagen del paciente
                    leading: CircleAvatar(
                      radius: 28,
                      backgroundColor: AppColors.slate50Light,
                      backgroundImage: mascota.fotoUrl != null &&
                              mascota.fotoUrl!.isNotEmpty
                          ? NetworkImage(mascota.fotoUrl!)
                          : null,
                      child: mascota.fotoUrl == null || mascota.fotoUrl!.isEmpty
                          ? const Icon(Icons.pets)
                          : null,
                    ),
                    title: Text(mascota.nombre),
                    subtitle: Text(mascota.especie),
                  );
                }).toList(),
              ),
          ],
        );
      },
    );
  }
}

class QuickAccessSection extends StatelessWidget {
  const QuickAccessSection({super.key});

  @override
  Widget build(BuildContext context) {
    // Elementos de acceso rápido con navegación
    final items = [
      {
        'label': 'Pacientes',
        'icon': Icons.pets,
        'route': '/lista_pacientes',
      },
      {
        'label': 'Citas',
        'icon': Icons.calendar_today,
        'route': '/agenda_citas_veterinario',
      },
      {
        'label': 'Expedientes',
        'icon': Icons.folder_special,
        'route': '/ficha_paciente_veterinario',
      },
      {
        'label': 'Perfil',
        'icon': Icons.person,
        'route': '/perfil_veterinarios',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Acceso Rápido',
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        // Grid de botones de acceso rápido
        GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 3.5,
          children: items.map((item) {
            return ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.textLight,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: Icon(item['icon'] as IconData, size: 18),
              label: Text(
                item['label'] as String,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                context.push(item['route'] as String);
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}