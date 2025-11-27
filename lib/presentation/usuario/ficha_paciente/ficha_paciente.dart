// lib/screens/patient_profile_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:vet_smart_ids/core/app_colors.dart';
import 'package:vet_smart_ids/models/historial_medico.dart';
import 'package:vet_smart_ids/providers/usuario_provider.dart';
import 'package:vet_smart_ids/providers/mascota_provider.dart';
import 'package:vet_smart_ids/providers/historial_medico_provider.dart';

// Importa los modelos de datos (Paciente, Vacuna, Alergia, Cita)
import 'package:vet_smart_ids/presentation/usuario/ficha_paciente/ficha_paciente_model.dart';
import 'package:vet_smart_ids/presentation/usuario/navbar/navbar_usuario.dart';

class PatientProfileScreen
    extends
        StatefulWidget {
  static const String name = 'PatientProfileScreen';
  final Paciente? patient; // Opcional ahora — si viene, usar mock; si no, cargar real

  const PatientProfileScreen({
    super.key,
    this.patient,
  });

  @override
  State<PatientProfileScreen> createState() => _PatientProfileScreenState();
}

class _PatientProfileScreenState extends State<PatientProfileScreen> {
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      _loadData();
    }
  }

  Future<void> _loadData() async {
    final usuarioProvider = context.read<UsuarioProvider>();
    final mascotaProvider = context.read<MascotaProvider>();
    final histProvider = context.read<HistorialMedicoProvider>();

    if (usuarioProvider.isLoggedIn && usuarioProvider.usuarioActual != null) {
      final uid = usuarioProvider.usuarioActual!.usuarioId;
      if (uid != null) {
        // Cargar mascotas del usuario
        final mascotas = await mascotaProvider.loadMascotasWithDetailsForUsuario(uid);

        // Si tiene mascotas, cargar historiales para esas mascotas
        if (mascotas.isNotEmpty) {
          final mascotaIds = mascotas.where((m) => m.mascotaId != null).map((m) => m.mascotaId!).toList();
          await histProvider.loadHistorialesByMascotas(mascotaIds);
        } else {
          await histProvider.loadHistorialesByMascotas([]);
        }
      }
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final usuarioProvider = context.watch<UsuarioProvider>();
    final mascotaProvider = context.watch<MascotaProvider>();
    final histProvider = context.watch<HistorialMedicoProvider>();

    // Fallback a mock si se pasa patient (compatible con ruta antigua)
    if (widget.patient != null) {
      return _buildMockUI(context);
    }

    if (!usuarioProvider.isLoggedIn) {
      return Scaffold(
        appBar: AppBar(title: const Text('Historial Médico')),
        body: const Center(child: Text('Inicia sesión para ver el historial')),
      );
    }

    if (histProvider.isLoading || mascotaProvider.isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Historial Médico')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final mascotas = mascotaProvider.mascotas;
    final uid = usuarioProvider.usuarioActual!.usuarioId;
    final userHistoriales = histProvider.historiales.where((h) => h.usuarioId == uid).toList();

    // Agrupar historiales por mascotaId
    final Map<int, List<HistorialMedico>> grouped = {};
    for (var h in userHistoriales) {
      grouped.putIfAbsent(h.mascotaId, () => []).add(h);
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.8),
        elevation: 0,
        toolbarHeight: 56,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 24),
          onPressed: () => context.pop(),
          color: AppColors.textLight,
        ),
        title: Text(
          'Historial Médico',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textLight,
              ),
        ),
        centerTitle: true,
        actions: const [SizedBox(width: 48)],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 120),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: grouped.isEmpty
              ? Center(
                  child: Text(
                    'No hay historiales médicos para tus mascotas.',
                    style: TextStyle(color: isDark ? AppColors.white : AppColors.textLight),
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: grouped.entries.map((entry) {
                    final mascotaId = entry.key;
                    final historiales = entry.value;

                    final lista = mascotas.where((m) => (m.mascotaId ?? -1) == mascotaId).toList();
                    final mascota = lista.isNotEmpty ? lista.first : null;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Cabecera con foto y nombre de mascota
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(28),
                              child: mascota != null && mascota.fotoUrl != null && mascota.fotoUrl!.isNotEmpty
                                  ? Image.network(
                                      mascota.fotoUrl!,
                                      width: 56,
                                      height: 56,
                                      fit: BoxFit.cover,
                                      errorBuilder: (c, e, st) {
                                        return Container(
                                          width: 56,
                                          height: 56,
                                          color: AppColors.primary20,
                                          child: const Icon(Icons.pets, color: AppColors.primary),
                                        );
                                      },
                                    )
                                  : Container(
                                      width: 56,
                                      height: 56,
                                      color: AppColors.primary20,
                                      child: const Icon(Icons.pets, color: AppColors.primary),
                                    ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                mascota != null ? mascota.nombre : 'Mascota #$mascotaId',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? AppColors.white : AppColors.textLight,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // Lista de historiales de esta mascota
                        ...historiales.map((h) => _HistorialCard(hist: h, isDark: isDark)),
                        const SizedBox(height: 24),
                      ],
                    );
                  }).toList(),
                ),
        ),
      ),
      bottomNavigationBar: const UserNavbar(currentRoute: '/ficha_paciente'),
    );
  }

  /// Mantener UI mock para compatibilidad
  Widget _buildMockUI(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.8),
        elevation: 0,
        toolbarHeight: 56,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 24),
          onPressed: () => context.pop(),
          color: AppColors.textLight,
        ),
        title: Text(
          'Ficha del Paciente',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textLight,
              ),
        ),
        centerTitle: true,
        actions: const [SizedBox(width: 48)],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 120),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _PatientInfoSection(patient: widget.patient!),
              const SizedBox(height: 24),
              Column(
                children: [
                  _InfoCard(title: 'Vacunas', child: _VaccineList(vacunas: widget.patient!.vacunas)),
                  const SizedBox(height: 24),
                  _InfoCard(title: 'Alergias', child: _AllergyList(alergias: widget.patient!.alergias)),
                  const SizedBox(height: 24),
                  _InfoCard(title: 'Próximas Citas', child: _AppointmentList(citas: widget.patient!.proximasCitas)),
                  const SizedBox(height: 24),
                  _InfoCard(title: 'Citas Anteriores', child: _AppointmentList(citas: widget.patient!.citasAnteriores)),
                  const SizedBox(height: 24),
                  _DownloadPdfButton(),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const UserNavbar(currentRoute: '/ficha_paciente'),
    );
  }
}

// ---------------------------------
// otros componentes

// Widget para la sección de información básica
class _PatientInfoSection
    extends
        StatelessWidget {
  final Paciente patient;
  const _PatientInfoSection({
    required this.patient,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    final textTheme = Theme.of(
      context,
    ).textTheme;
    return Row(
      children: [
        // Contenedor para la foto de perfil
        ClipRRect(
          borderRadius: BorderRadius.circular(
            48,
          ),
          child: Image.network(
            patient.fotoUrl,
            width: 96,
            height: 96,
            fit: BoxFit.cover,
            // Widget de respaldo si la imagen falla al cargar
            errorBuilder:
                (
                  context,
                  error,
                  stackTrace,
                ) => Container(
                  width: 96,
                  height: 96,
                  color: AppColors.primary,
                  child: const Icon(
                    Icons.pets,
                    color: AppColors.white,
                  ),
                ),
          ),
        ),
        const SizedBox(
          width: 16,
        ),
        // Columna con nombre y detalles
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nombre del paciente
            Text(
              patient.nombre,
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: AppColors.textLight,
              ),
            ),
            // Raza y Edad
            Text(
              patient.razaEdad,
              style: textTheme.bodyMedium?.copyWith(
                color: AppColors.black40,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// Tarjeta contenedora para secciones como Vacunas o Citas
class _InfoCard
    extends
        StatelessWidget {
  final String title;
  final Widget child; // Contenido
  const _InfoCard({
    required this.title,
    required this.child,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Container(
      padding: const EdgeInsets.all(
        16.0,
      ),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).cardColor, // Color de fondo de la tarjeta
        borderRadius: BorderRadius.circular(
          8.0,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(
              0.05,
            ),
            blurRadius: 4,
            offset: const Offset(
              0,
              2,
            ),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título de la sección
          Text(
            title,
            style:
                Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: AppColors.textLight,
                ),
          ),
          const SizedBox(
            height: 12,
          ),
          child, // Renderiza el contenido (lista de alergias, vacunas, etc)
        ],
      ),
    );
  }
}

// Lista de Alergias del paciente
class _AllergyList
    extends
        StatelessWidget {
  final List<
    Alergia
  >
  alergias;
  const _AllergyList({
    required this.alergias,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      // Mapea la lista de datos de alergias
      children: alergias
          .map(
            (
              alergia,
            ) => Padding(
              padding: const EdgeInsets.only(
                bottom: 8.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Nombre de la alergia
                  Text(
                    alergia.nombre,
                    style:
                        Theme.of(
                          context,
                        ).textTheme.bodyLarge?.copyWith(
                          color: AppColors.textLight,
                        ),
                  ),
                  // Detalle de la alergia
                  Text(
                    alergia.detalle.isNotEmpty
                        ? alergia.detalle
                        : 'Desconocida',
                    style:
                        Theme.of(
                          context,
                        ).textTheme.bodySmall?.copyWith(
                          fontSize: 14,
                          color: AppColors.black40,
                        ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}

// Lista de Vacunas aplicadas al paciente
class _VaccineList
    extends
        StatelessWidget {
  final List<
    Vacuna
  >
  vacunas;
  const _VaccineList({
    required this.vacunas,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      // Mapea la lista de datos de vacunas a widgets
      children: vacunas
          .map(
            (
              vacuna,
            ) => Padding(
              padding: const EdgeInsets.only(
                bottom: 8.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Nombre de la vacuna
                  Text(
                    vacuna.nombre,
                    style:
                        Theme.of(
                          context,
                        ).textTheme.bodyLarge?.copyWith(
                          color: AppColors.textLight,
                        ),
                  ),
                  // Fecha de aplicación
                  Text(
                    vacuna.fecha,
                    style:
                        Theme.of(
                          context,
                        ).textTheme.bodySmall?.copyWith(
                          fontSize: 14,
                          color: AppColors.black40,
                        ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}

// Lista general de Citas
class _AppointmentList
    extends
        StatelessWidget {
  final List<
    Cita
  >
  citas;
  const _AppointmentList({
    required this.citas,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Column(
      // Mapea la lista de citas al widget _AppointmentItem
      children: citas
          .map(
            (
              cita,
            ) => Padding(
              // Agrega padding inferior, excepto al último elemento
              padding: EdgeInsets.only(
                bottom:
                    citas.last ==
                        cita
                    ? 0
                    : 12.0,
              ),
              child: _AppointmentItem(
                cita: cita,
              ),
            ),
          )
          .toList(),
    );
  }
}

// Elemento individual de Cita
class _AppointmentItem
    extends
        StatelessWidget {
  final Cita cita;
  const _AppointmentItem({
    required this.cita,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    final textTheme = Theme.of(
      context,
    ).textTheme;

    // Determina el color de la fecha: Primario para futuras, gris para anteriores
    final dateColor = cita.isUpcoming
        ? AppColors.primary
        : AppColors.black60;

    return InkWell(
      // Widget que hace que el elemento sea interactivo al tocar
      onTap: () {
        context.push(
          '/cita_detalles_usuario', // Navega a la ruta de detalle de cita
          extra: cita,
        );
      },
      borderRadius: BorderRadius.circular(
        8.0,
      ),
      child: Container(
        padding: const EdgeInsets.all(
          16.0,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.black.withOpacity(
              0.1,
            ),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(
            8.0,
          ),
          color: Colors.transparent,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Motivo y Doctor
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Motivo de la cita
                Text(
                  cita.motivo,
                  style: textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textLight,
                  ),
                ),
                // Nombre del doctor
                Text(
                  cita.doctor,
                  style: textTheme.bodySmall?.copyWith(
                    fontSize: 14,
                    color: AppColors.black40,
                  ),
                ),
              ],
            ),

            // Fecha y Detalle de Tiempo
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Fecha de la cita
                Text(
                  cita.fecha,
                  style: textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: dateColor,
                  ),
                ),
                // Hora o estado
                Text(
                  cita.detalleTiempo,
                  style: textTheme.bodySmall?.copyWith(
                    fontSize: 14,
                    color: AppColors.black40,
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

// Botón para descargar el historial médico completo en PDF
class _DownloadPdfButton
    extends
        StatelessWidget {
  @override
  Widget build(
    BuildContext context,
  ) {
    return ElevatedButton.icon(
      onPressed: () {
        // tiene que generar la carga pero eso después
      },
      icon: const Icon(
        Icons.download_rounded,
        size: 20,
      ),
      label: const Text(
        'Descargar PDF',
      ),
      style: ElevatedButton.styleFrom(
        // Tamaño completo y altura fija
        minimumSize: const Size(
          double.infinity,
          48,
        ),
        backgroundColor: AppColors.primary20,
        foregroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            12.0,
          ),
        ),
        textStyle:
            Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
        elevation: 0,
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
        ),
      ),
    );
  }
}

/// Widget para mostrar una tarjeta de historial médico
class _HistorialCard extends StatelessWidget {
  final HistorialMedico hist;
  final bool isDark;

  const _HistorialCard({
    required this.hist,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Fecha
            Text(
              _formatDate(hist.fechaConsulta),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: isDark ? AppColors.white : AppColors.textLight,
              ),
            ),
            const SizedBox(height: 8),
            // Diagnóstico
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Diagnóstico: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.slate600Light : AppColors.slate600Light,
                    ),
                  ),
                  TextSpan(
                    text: hist.diagnostico,
                    style: TextStyle(
                      color: isDark ? AppColors.slate600Light.withOpacity(0.8) : AppColors.slate600Light,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            // Tratamiento
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Tratamiento: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.slate600Light : AppColors.slate600Light,
                    ),
                  ),
                  TextSpan(
                    text: hist.tratamiento,
                    style: TextStyle(
                      color: isDark ? AppColors.slate600Light.withOpacity(0.8) : AppColors.slate600Light,
                    ),
                  ),
                ],
              ),
            ),
            if (hist.notasAdicionales != null && hist.notasAdicionales!.isNotEmpty) ...[
              const SizedBox(height: 6),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Notas: ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.slate600Light : AppColors.slate600Light,
                      ),
                    ),
                    TextSpan(
                      text: hist.notasAdicionales,
                      style: TextStyle(
                        color: isDark ? AppColors.slate600Light.withOpacity(0.8) : AppColors.slate600Light,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}