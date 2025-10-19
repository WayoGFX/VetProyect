// Paquete principal de Flutter
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:vet_smart_ids/core/app_colors.dart';
import 'package:vet_smart_ids/presentation/veterinario/navbar/navbar_veterinario.dart';

// modelo

// Estructura de un objeto de la cita
class Appointment {
  final String title; // Título de la cita
  final String time; // Horario de la cita
  final String imageUrl; // URL de la imagen de la mascota

  const Appointment({
    required this.title,
    required this.time,
    required this.imageUrl,
  });
}

// Estructura de un objeto alerta
class Alert {
  final String title; // Título de la alerta
  final String subtitle; // Subtítulo o detalle
  final IconData icon; // El ícono que se mostrará

  const Alert({
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}

// Lista de citas para el día de hoy
const List<
  Appointment
>
todayAppointments = [
  Appointment(
    title: 'Consulta con Max',
    time: '10:00 AM - 11:00 AM',
    imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCN6s1dkIaubehDJu03IOaajrMoqwno5unj8ZrmOkzABGIFLr2uabW0ZWfZVRwnUvH98oOZK9-fg2musQiqANMO4CL1LDIOlUs5YtLCe5fVJcIvHe-lcPsiiEYVKcHzc2SSm5SPb279F0M_kecZX6LybFdqSOrTeotDB3XmWKeQxgPlQ6cQAfLGz6QubeLxwxz5DVXPXOUV5AgSMWd3PPHpf5WfGfFgIz3c97yflXwme6Sxo0G3bytUatnG5Ng0PZQ2FY1egOjeJMc',
  ),
  Appointment(
    title: 'Vacunación de Bella',
    time: '11:30 AM - 12:30 PM',
    imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuAjACQXRyFw45wkWRHW2H9ll8flneHJkf41kOaI0F8YSVlXtrVi-8sURw7aTMKWs6IAxg9eqODVKi2PuNS_tBGDktwj7_T-qfYPt0lnHWNeq_0la6bsnGsaoin6431RuLdDS-OJlNGwWNIDx40goz8WUql7ia7aQ6OohDhUOLxn6DlM7D7PWk0N58elGApmRphgo1SeSS8eZGHccSR42OhfTbf0HhAUWAegS1rqL2ugxy6JRnF-uF7m7IK5Pqs8dxrlHNMTjitWtNs',
  ),
];

// Lista de alertas y recordatorios
const List<
  Alert
>
alerts = [
  Alert(
    title: 'Recordatorio de vacuna para Max',
    subtitle: 'Próxima vacuna: 15 de julio',
    icon: Icons.vaccines,
  ),
  Alert(
    title: 'Recordatorio de cita para Bella',
    subtitle: 'Próxima cita: 20 de julio',
    icon: Icons.calendar_today,
  ),
];

// pantalla principal

// Pantalla de inicio que muestra citas y alertas diarias
class CitasDelDiaScreen
    extends
        StatefulWidget {
  // Identificador de la ruta
  static const String name = 'vistas_citas_del_dia_screen';

  const CitasDelDiaScreen({
    super.key,
  });

  @override
  State<
    CitasDelDiaScreen
  >
  createState() => _CitasDelDiaScreenState();
}

// Clase que maneja el estado principal
class _CitasDelDiaScreenState
    extends
        State<
          CitasDelDiaScreen
        > {
  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,

      // AppBar de la pantalla
      appBar: AppBar(
        backgroundColor: AppColors.backgroundLight.withOpacity(
          0.8,
        ),
        elevation: 0,
        title: Text(
          'VetSmart',
          style: Theme.of(
            context,
          ).textTheme.titleLarge,
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(
          16.0,
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sección de Citas
            const _SectionTitle(
              title: 'Citas de hoy',
            ),

            // Mapea y muestra las tarjetas de citas
            ...todayAppointments.map(
              (
                app,
              ) => _AppointmentCard(
                appointment: app,
              ),
            ),
            const SizedBox(
              height: 24,
            ),

            // Sección de Alertas
            const _SectionTitle(
              title: 'Alertas',
            ),

            // Mapea y muestra las tarjetas de alertas
            ...alerts.map(
              (
                alert,
              ) => _AlertCard(
                alert: alert,
              ),
            ),
            const SizedBox(
              height: 24,
            ),

            // Sección de Estadística
            Row(
              children: const [
                Expanded(
                  child: _StatCard(
                    title: 'Pacientes Activos',
                    value: '32',
                  ),
                ),
                SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: _StatCard(
                    title: 'Próximas Citas',
                    value: '5',
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 24,
            ),

            //Sección de Acceso Rápido con botones
            const _SectionTitle(
              title: 'Acceso rápido',
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => context.push(
                      '/crear_cita',
                    ), // Navega a la ruta de nueva cita
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.textLight,
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                      ),
                      textStyle: Theme.of(
                        context,
                      ).textTheme.titleMedium,
                    ),
                    child: const Text(
                      'Nueva cita',
                    ),
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => context.push(
                      '/nuevo_paciente',
                    ), // Navega a la ruta de nuevo paciente
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary20,
                      foregroundColor: AppColors.textLight,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                      ),
                      textStyle: Theme.of(
                        context,
                      ).textTheme.titleMedium,
                    ),
                    child: const Text(
                      'Nuevo paciente',
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
            bottomNavigationBar: const VetNavbar(
        // Le pasamos la ruta estática para que el navbar resalte el ícono "Inicio".
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
class _AppointmentCard
    extends
        StatelessWidget {
  final Appointment appointment;
  const _AppointmentCard({
    required this.appointment,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    // MODIFICACIÓN: Envolvemos el Card con InkWell
    return InkWell(
      // Añadimos el evento onTap para la navegación
      onTap: () {
        // Navegamos a la ruta 'gesture' (nombre de tu pantalla de detalle)
        context.push('/cita_detalles_veterinario');
      },
      // Hacemos que el efecto ripple tenga los mismos bordes que la tarjeta
      borderRadius: BorderRadius.circular(
        12,
      ),
      child: Card(
        elevation: 1,
        margin: const EdgeInsets.only(
          bottom: 8,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            12,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(
            12.0,
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundImage: NetworkImage(
                  appointment.imageUrl,
                ),
              ),
              const SizedBox(
                width: 16,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    appointment.title,
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium,
                  ),
                  Text(
                    appointment.time,
                    style: TextStyle(
                      color: AppColors.slate500Light,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Tarjeta individual para una alerta
class _AlertCard
    extends
        StatelessWidget {
  final Alert alert;
  const _AlertCard({
    required this.alert,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(
        bottom: 8,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          12,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(
          12.0,
        ),
        child: Row(
          children: [
            // Contenedor del ícono con color de fondo
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.primary20,
                borderRadius: BorderRadius.circular(
                  8,
                ),
              ),
              child: Icon(
                alert.icon,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  alert.title,
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium,
                ),
                Text(
                  alert.subtitle,
                  style: TextStyle(
                    color: AppColors.slate500Light,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Tarjeta de estadística como pacientes activos
class _StatCard
    extends
        StatelessWidget {
  final String title;
  final String value;
  const _StatCard({
    required this.title,
    required this.value,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          12,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(
          16.0,
        ),
        child: Column(
          children: [
            Text(
              title,
              style:
                  Theme.of(
                    context,
                  ).textTheme.titleMedium!.copyWith(
                    fontSize: 16,
                  ),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              value,
              style:
                  Theme.of(
                    context,
                  ).textTheme.displaySmall!.copyWith(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
