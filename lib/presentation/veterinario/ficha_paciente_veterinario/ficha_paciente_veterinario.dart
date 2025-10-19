// lib/screens/patient_profile_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vet_smart_ids/core/app_colors.dart';

// Importa los modelos de datos (Paciente, Vacuna, Alergia, Cita)
import 'package:vet_smart_ids/presentation/usuario/ficha_paciente/ficha_paciente_model.dart';
import 'package:vet_smart_ids/presentation/veterinario/navbar/navbar_veterinario.dart';

class VetPatientProfileScreen
    extends
        StatelessWidget {
  static const String name = 'VetPatientProfileScreen';
  final Paciente patient; // Objeto del paciente recibido como final porque espera datos

  const VetPatientProfileScreen({
    super.key,
    required this.patient,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      // Appbar
      appBar: AppBar(
        backgroundColor:
            Theme.of(
              context,
            ).scaffoldBackgroundColor.withOpacity(
              0.8,
            ),
        elevation: 0,
        toolbarHeight: 56,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            size: 24,
          ),
          onPressed: () => context.pop(),
          color: AppColors.textLight,
        ),
        // Título de la pantalla
        title: Text(
          'Ficha del Paciente - vet',
          style:
              Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textLight,
              ),
        ),
        centerTitle: true,
        actions: const [
          SizedBox(
            width: 48,
          ),
        ],
      ),

      // Contenido principal
      body: SingleChildScrollView(
        // Padding inferior
        padding: const EdgeInsets.only(
          bottom: 120,
        ),
        child: Padding(
          padding: const EdgeInsets.all(
            16.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Información general del paciente foto, nombre, raza
              _PatientInfoSection(
                patient: patient,
              ),

              const SizedBox(
                height: 24,
              ),
              // Secciones de historial, en columna
              Column(
                children: [
                  // Tarjeta de Vacunas
                  _InfoCard(
                    title: 'Vacunas',
                    child: _VaccineList(
                      vacunas: patient.vacunas,
                    ),
                  ),

                  const SizedBox(
                    height: 24,
                  ),

                  // Tarjeta de Alergias
                  _InfoCard(
                    title: 'Alergias',
                    child: _AllergyList(
                      alergias: patient.alergias,
                    ),
                  ),

                  const SizedBox(
                    height: 24,
                  ),

                  // Tarjeta de Próximas Citas
                  _InfoCard(
                    title: 'Próximas Citas',
                    child: _AppointmentList(
                      citas: patient.proximasCitas,
                    ),
                  ),

                  const SizedBox(
                    height: 24,
                  ),

                  // Tarjeta de Citas Anteriores
                  _InfoCard(
                    title: 'Citas Anteriores',
                    child: _AppointmentList(
                      citas: patient.citasAnteriores,
                    ),
                  ),

                  const SizedBox(
                    height: 24,
                  ),

                  // Botón para descargar el PDF del historial
                  _DownloadPdfButton(),
                ],
              ),
            ],
          ),
        ),
      ),

      // navbar
      bottomNavigationBar: const VetNavbar(
        // Le pasamos la ruta estática para que el navbar resalte el ícono
        currentRoute: '/lista_pacientes',
      ),
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
          '/cita_detalles_veterinario', // Navega a la ruta de detalle de cita
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
        context.push(
          '/pantalla_error', // Navega a la ruta de error
        );
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
