import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vet_smart_ids/core/app_colors.dart';
import 'package:vet_smart_ids/presentation/veterinario/navbar/navbar_veterinario.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});
  static const String name = "dashboard";

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
    // Datos de citas de ejemplo
    final appointments = [
      {
        'name': 'Consulta con Max',
        'time': '10:00 AM',
        'image': 'https://lh3.googleusercontent.com/aida-public/AB6AXuB9H6mOziDfNaZvp0eLHO2Bcm6KUwYfAOgWHMjmZJGYSKm9Ueky_xZ9EHMRuxgUOKx1ebc5byorgG8LiUz-KHLudClD9loN_k7_pSpP5oBUUg8bxbmtW3YjPnSksEp-BbMxMgRrdkP5hUpkIDPiWr9MawSEO2hQfyrw8pO8DHyFi7W8vNn2BQb2nECfIT5c19dw64R6j7veRcewzu1GYtKoFOn9GmdVFSf-yM5GuahNqz3SKerjPh4leg3aZ96KeHoWV_dQIofKVVU'

      },
      {
        'name': 'Revisión de Luna',
        'time': '11:30 AM',
        'image': 'https://lh3.googleusercontent.com/aida-public/AB6AXuCUSg0E-bPQ0d3FUYA9YZvHTGWyFfs-9UXxsSdbd-8YZFruAH0-q9Lk9n7qRY0lyMfPwY_HhZEWYUHUNlWwOweNd8Kut_U778skZlX9EY6Q887Yt1RUFAm5gOs_55EL6Z_8BBfCKwuFSdpzQ7hmygivSGZfggvPTW0AI-7bKL__su6qKt7Qsb7fW8LJH4AuokYuOW2uVLB5NImJa_xqG0bhkNPpa_b7EzYx0tpxHX50iDz_3WqiNhmXDtc53uNairwdZc_giQ_crEg'
      },
      {
        'name': 'Vacunación de Coco',
        'time': '2:00 PM',
        'image': 'https://lh3.googleusercontent.com/aida-public/AB6AXuAXsT2h8A8siDaKZydCVNO5vPixdii4QYA4G6hYhUvr6MOS8QuPcxOeXwO2OcEjLp2SuRke88j9vTt2WZGcvScfStn5W94HAlnLewxywwLVXGik0NwOF6hK3uZ0R5J7y8buSMrOUpOy-cfedYf331XxYghjRhPqdFo_plE2H6-yQFOsSQHbEJ4KTODflgQABEe4uRmrBAxxJrlmlVwlroZmxKCWVy0s_qhVI_J08pe217uZTLHJWN9QtReE2BqzadRNWv0wlXB2IUk'
      },
    ];

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
        SizedBox(
          height: 205,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: appointments.length,
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final item = appointments[index];
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
                        child: Image.network(
                          item['image']!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item['name']!,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Flexible(
                      child: Text(
                        item['time']!,
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
  }
}

class DashboardStats extends StatelessWidget {
  const DashboardStats({super.key});

  @override
  Widget build(BuildContext context) {
    // Datos de ejemplo para la gráfica de animales
    final Map<String, double> stats = {
      'Perros': 0.6,
      'Gatos': 0.4,
      'Aves': 0.2,
      'Roedores': 0.15,
      'Otros': 0.1,
    };

    // Colores de las barras de la gráfica
    final Map<String, Color> colors = {
      'Perros': const Color(0xFFFFDDC1),
      'Gatos': const Color(0xFFC1FFD7),
      'Aves': const Color(0xFFD1C1FF),
      'Roedores': const Color(0xFFFFC1E3),
      'Otros': const Color(0xFFC1EFFF),
    };

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
              Row(
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
                children: const [
                  DiseaseLegend(color: Color(0xFFFFDDC1), label: 'Problemas de Piel (35%)'),
                  DiseaseLegend(color: Color(0xFFC1FFD7), label: 'Problemas Digestivos (25%)'),
                  DiseaseLegend(color: Color(0xFFD1C1FF), label: 'Alergias (20%)'),
                ],
              )
            ],
          ),
        ),
      ],
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
    // Lista de alertas de ejemplo
    final List<Map<String, Object>> alerts = [
      {
        'title': 'Vacunación de Toby',
        'subtitle': 'Próxima semana',
        'icon': Icons.vaccines,
      },
      {
        'title': 'Revisión de salud de Bella',
        'subtitle': 'En 2 semanas',
        'icon': Icons.favorite,
      },
    ];

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
        Column(
          children: alerts.map((alert) {
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                // Icono de la alerta
                leading: CircleAvatar(
                  backgroundColor: AppColors.primary.withOpacity(0.2),
                  child: Icon(
                    alert['icon'] as IconData,
                    color: AppColors.primary,
                  ),
                ),
                title: Text(alert['title'] as String),
                subtitle: Text(alert['subtitle'] as String),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class ActivePatientsSection extends StatelessWidget {
  const ActivePatientsSection({super.key});

  @override
  Widget build(BuildContext context) {
    // Lista de pacientes activos de ejemplo
    final patients = [
      {
        'name': 'Max',
        'type': 'Canino',
        'image': 'https://lh3.googleusercontent.com/aida-public/AB6AXuDF3xfQsQ7M4RaeNdtVsT-kfRz6qhoe598QLA5LPJ4ya0RQDxKIAMORGwU0MVtRJOBZjBBMjoElsE2ygsmQzHAizIQlreNEJCNkzolbaXXB7rfUGYX5HZvNRImGohdk3a4mFdd3oPsBCL_sjpERtJTG376PqUMgAVHS5UmVnsqmZY7W43IJbEq9OvGOWmKAHX7-CUy2DCpCWWCPtWUVfCeVUm8XSi20HOd6OsXXk1tluwy40UanH5z5oCGv5GvT87G2TlkzbdlbPNg'
      },
      {
        'name': 'Luna',
        'type': 'Felino',
        'image': 'https://lh3.googleusercontent.com/aida-public/AB6AXuCDokGIzXlqqWByawyoAYIQPkh0LtVNNjRPifd8BvcnO1E_5ebF8kYjAgl2id2bE1wCzq84kz9FevNFHSRmh1MXAQI2bgS7ptdKfcvQdlTpHxhga4vYUbl8ky8jQXTR3AlPOtaeo1gDmQV5JKi7DXt-wFb9Qt2BGi0mdpwaxdmMU5QKI84IMymWNfzC4nzjK4XdtDxat1suLp3GsZUelAS1ISAXTJF0FsQJ3n9p64AE-K_MjjCcYMHdGERDaUdqjnCMwvNtsWWfI-I'
      },
      {
        'name': 'Coco',
        'type': 'Lagomorfo',
        'image': 'https://lh3.googleusercontent.com/aida-public/AB6AXuBU4JWH0CgLT40xonaxQeI_JlM2wSvrIFVtsAAvT0Vv0iZ_-MiWZMZEHKebtoONuKkaBXHZmLppUjVRpZSF_QtDi4Spi1SkqE8NfjXCsSnIsEjbOo4O5ZyUzS9Rnxh4yZPGB6zbb14yCkPr-5kkIwN6sBC7AXggIj3uqV9eNZ6StkTmNBKLeaqSmBvb_a_IrO-rkcZ_DsgPoJU7Hv4Vaka7pqaEP6hTXA6IEHh96dWaCYZBWSc-jAty9dqm_clqu9IIxm_M3708Qyc'
      },
    ];

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
        Column(
          children: patients.map((p) {
            return ListTile(
              contentPadding: EdgeInsets.zero,
              // Avatar con la imagen del paciente
              leading: CircleAvatar(
                radius: 28,
                backgroundImage: NetworkImage(p['image']!),
              ),
              title: Text(p['name']!),
              subtitle: Text(p['type']!),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class QuickAccessSection extends StatelessWidget {
  const QuickAccessSection({super.key});

  @override
  Widget build(BuildContext context) {
    // Etiquetas para los botones de acceso rápido
    final items = ['Pacientes', 'Citas', 'Recordatorios', 'Perfil'];

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
          // Deshabilita el scroll dentro del GridView
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 3.5,
          children: items.map((label) {
            return ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.textLight,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                // Lógica de navegación o acción del botón
                debugPrint("Botón de acceso rápido presionado: $label");
              },
              child: Text(
                label,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}