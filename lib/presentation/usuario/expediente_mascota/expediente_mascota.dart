import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vet_smart_ids/core/app_colors.dart';
import 'package:vet_smart_ids/providers/mascota_provider.dart';
import 'package:vet_smart_ids/presentation/usuario/navbar/navbar_usuario.dart';
import 'package:vet_smart_ids/providers/cita_provider.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';

class ExpedienteMascotaScreen
    extends
        StatefulWidget {
  static const String name = 'ExpedienteMascotaScreen';
  const ExpedienteMascotaScreen({
    super.key,
  });

  @override
  State<
    ExpedienteMascotaScreen
  >
  createState() => _ExpedienteMascotaScreenState();
}

class _ExpedienteMascotaScreenState
    extends
        State<
          ExpedienteMascotaScreen
        > {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (
        _,
      ) {
        final provider = context
            .read<
              MascotaProvider
            >();
        if (provider.mascotaSeleccionada !=
            null) {
          provider.loadPacienteDetalle(
            provider.mascotaSeleccionada!.mascotaId!,
          );
        }
      },
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
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
            Icons.arrow_back_ios_new,
            size: 24,
          ),
          onPressed: () => context.pop(),
          color: AppColors.textLight,
        ),
        title: Text(
          'Expediente de la Mascota',
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
        actions: [],
      ),
      body:
          Consumer<
            MascotaProvider
          >(
            builder:
                (
                  context,
                  provider,
                  child,
                ) {
                  if (provider.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (provider.errorMessage !=
                      null) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 64,
                            color: Colors.red.shade300,
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Text(
                            'Error al cargar información del paciente',
                            style: Theme.of(
                              context,
                            ).textTheme.titleLarge,
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            provider.errorMessage!,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          ElevatedButton.icon(
                            onPressed: () {
                              if (provider.mascotaSeleccionada !=
                                  null) {
                                provider.loadPacienteDetalle(
                                  provider.mascotaSeleccionada!.mascotaId!,
                                );
                              }
                            },
                            icon: const Icon(
                              Icons.refresh,
                            ),
                            label: const Text(
                              'Reintentar',
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  final detalle = provider.pacienteDetalle;
                  if (detalle ==
                      null) {
                    return const Center(
                      child: Text(
                        'No hay información del paciente',
                      ),
                    );
                  }

                  return SingleChildScrollView(
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
                          _PatientInfoSection(
                            detalle: detalle,
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          _InfoCard(
                            title: 'Información del Dueño',
                            child: _OwnerInfo(
                              detalle: detalle,
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          // Botón para ver sólo las citas de esta mascota
                          ElevatedButton.icon(
                            onPressed: () async {
                              final citaProvider = context
                                  .read<
                                    CitaProvider
                                  >();
                              final mascotaId = detalle.mascota.mascotaId;
                              if (mascotaId !=
                                  null) {
                                // Cargar únicamente las citas de la mascota y navegar a la agenda
                                await citaProvider.loadCitasByMascota(
                                  mascotaId,
                                );
                                context.push(
                                  '/agenda_citas',
                                );
                              } else {
                                ScaffoldMessenger.of(
                                  context,
                                ).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'ID de mascota inválido',
                                    ),
                                  ),
                                );
                              }
                            },
                            icon: const Icon(
                              Icons.calendar_month,
                            ),
                            label: const Text(
                              'Ver citas de esta mascota',
                            ),
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(
                                double.infinity,
                                44,
                              ),
                              backgroundColor: AppColors.primary20,
                              foregroundColor: AppColors.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  12,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          _InfoCard(
                            title: 'Vacunas',
                            child: detalle.vacunas.isEmpty
                                ? _EmptyState(
                                    message: 'No tiene vacunas registradas',
                                  )
                                : _VaccineList(
                                    vacunas: detalle.vacunas,
                                  ),
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          _InfoCard(
                            title: 'Alergias',
                            child: detalle.alergias.isEmpty
                                ? _EmptyState(
                                    message: 'No tiene alergias registradas',
                                  )
                                : _AllergyList(
                                    alergias: detalle.alergias,
                                  ),
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          _InfoCard(
                            title: 'Próximas Citas',
                            child: detalle.proximasCitas.isEmpty
                                ? _EmptyState(
                                    message: 'No tiene próximas citas',
                                  )
                                : _AppointmentList(
                                    citas: detalle.proximasCitas,
                                    isUpcoming: true,
                                  ),
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          _InfoCard(
                            title: 'Citas Anteriores',
                            child: detalle.citasAnteriores.isEmpty
                                ? _EmptyState(
                                    message: 'No tiene citas anteriores',
                                  )
                                : _AppointmentList(
                                    citas: detalle.citasAnteriores,
                                    isUpcoming: false,
                                  ),
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          _InfoCard(
                            title: 'Historial Médico',
                            child: detalle.historialMedico.isEmpty
                                ? _EmptyState(
                                    message: 'No tiene historial médico',
                                  )
                                : _MedicalHistoryList(
                                    historiales: detalle.historialMedico,
                                  ),
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          _DownloadPdfButton(),
                        ],
                      ),
                    ),
                  );
                },
          ),
      bottomNavigationBar: const UserNavbar(
        currentRoute: '/ficha_paciente',
      ),
    );
  }
}

class _PatientInfoSection
    extends
        StatelessWidget {
  final dynamic detalle;
  const _PatientInfoSection({
    required this.detalle,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    final textTheme = Theme.of(
      context,
    ).textTheme;
    final mascota = detalle.mascota;

    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(
            48,
          ),
          child:
              mascota.fotoUrl !=
                      null &&
                  mascota.fotoUrl!.isNotEmpty
              ? Image.network(
                  mascota.fotoUrl!,
                  width: 96,
                  height: 96,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (
                        context,
                        error,
                        stackTrace,
                      ) => Container(
                        width: 96,
                        height: 96,
                        color: AppColors.primary20,
                        child: Icon(
                          Icons.pets,
                          color: AppColors.primary,
                          size: 48,
                        ),
                      ),
                )
              : Container(
                  width: 96,
                  height: 96,
                  color: AppColors.primary20,
                  child: Icon(
                    Icons.pets,
                    color: AppColors.primary,
                    size: 48,
                  ),
                ),
        ),
        const SizedBox(
          width: 16,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                mascota.nombre,
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: AppColors.textLight,
                ),
              ),
              Text(
                detalle.razaEdad,
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.black40,
                ),
              ),
              Text(
                mascota.especie,
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.slate500Light,
                ),
              ),
              Text(
                'ID: ${mascota.mascotaId}',
                style: textTheme.bodySmall?.copyWith(
                  color: AppColors.slate400Light,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _OwnerInfo
    extends
        StatelessWidget {
  final dynamic detalle;
  const _OwnerInfo({
    required this.detalle,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    final dueno = detalle.dueno;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _InfoRow(
          icon: Icons.person,
          label: 'Nombre',
          value: dueno.nombreCompleto,
        ),
        const SizedBox(
          height: 8,
        ),
        _InfoRow(
          icon: Icons.phone,
          label: 'Teléfono',
          value:
              dueno.telefono ??
              'No registrado',
        ),
        const SizedBox(
          height: 8,
        ),
        _InfoRow(
          icon: Icons.location_on,
          label: 'Dirección',
          value:
              dueno.direccion ??
              'No registrada',
        ),
        const SizedBox(
          height: 8,
        ),
        _InfoRow(
          icon: Icons.email,
          label: 'Email',
          value: dueno.email,
        ),
      ],
    );
  }
}

class _InfoRow
    extends
        StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 20,
          color: AppColors.primary,
        ),
        const SizedBox(
          width: 12,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style:
                    Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(
                      color: AppColors.slate400Light,
                      fontSize: 12,
                    ),
              ),
              Text(
                value,
                style:
                    Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textLight,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _InfoCard
    extends
        StatelessWidget {
  final String title;
  final Widget child;
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
        ).cardColor,
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
          child,
        ],
      ),
    );
  }
}

class _EmptyState
    extends
        StatelessWidget {
  final String message;
  const _EmptyState({
    required this.message,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 16,
      ),
      child: Center(
        child: Text(
          message,
          style: TextStyle(
            color: AppColors.slate400Light,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

class _AllergyList
    extends
        StatelessWidget {
  final List<
    dynamic
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
                  Text(
                    alergia.alergia.nombre,
                    style:
                        Theme.of(
                          context,
                        ).textTheme.bodyLarge?.copyWith(
                          color: AppColors.textLight,
                        ),
                  ),
                  Flexible(
                    child: Text(
                      alergia.detalle,
                      style:
                          Theme.of(
                            context,
                          ).textTheme.bodySmall?.copyWith(
                            fontSize: 14,
                            color: AppColors.black40,
                          ),
                      textAlign: TextAlign.right,
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

class _VaccineList
    extends
        StatelessWidget {
  final List<
    dynamic
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
      children: vacunas
          .map(
            (
              vacuna,
            ) => Padding(
              padding: const EdgeInsets.only(
                bottom: 8.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        vacuna.vacuna.nombre,
                        style:
                            Theme.of(
                              context,
                            ).textTheme.bodyLarge?.copyWith(
                              color: AppColors.textLight,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      Text(
                        vacuna.fechaFormateada,
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
                  if (vacuna.lote.isNotEmpty)
                    Text(
                      'Lote: ${vacuna.lote}',
                      style:
                          Theme.of(
                            context,
                          ).textTheme.bodySmall?.copyWith(
                            fontSize: 12,
                            color: AppColors.slate400Light,
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

class _AppointmentList
    extends
        StatelessWidget {
  final List<
    dynamic
  >
  citas;
  final bool isUpcoming;
  const _AppointmentList({
    required this.citas,
    required this.isUpcoming,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Column(
      children: citas
          .map(
            (
              cita,
            ) => Padding(
              padding: EdgeInsets.only(
                bottom:
                    citas.last ==
                        cita
                    ? 0
                    : 12.0,
              ),
              child: _AppointmentItem(
                cita: cita,
                isUpcoming: isUpcoming,
              ),
            ),
          )
          .toList(),
    );
  }
}

class _AppointmentItem
    extends
        StatelessWidget {
  final dynamic cita;
  final bool isUpcoming;
  const _AppointmentItem({
    required this.cita,
    required this.isUpcoming,
  });

  String
  _formatFecha(
    DateTime fecha,
  ) =>
      DateFormat(
        'dd/MM/yyyy',
      ).format(
        fecha,
      );
  String
  _formatHora(
    DateTime fecha,
  ) =>
      DateFormat(
        'HH:mm',
      ).format(
        fecha,
      );

  @override
  Widget build(
    BuildContext context,
  ) {
    final textTheme = Theme.of(
      context,
    ).textTheme;
    final dateColor = isUpcoming
        ? AppColors.primary
        : AppColors.black60;

    return InkWell(
      onTap: () => context.push(
        '/cita_detalles_usuario',
        extra: cita,
      ),
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cita.motivo,
                    style: textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textLight,
                    ),
                  ),
                  Text(
                    cita.estado,
                    style: textTheme.bodySmall?.copyWith(
                      fontSize: 14,
                      color: AppColors.black40,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _formatFecha(
                    cita.fechaHora,
                  ),
                  style: textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: dateColor,
                  ),
                ),
                Text(
                  _formatHora(
                    cita.fechaHora,
                  ),
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

class _MedicalHistoryList
    extends
        StatelessWidget {
  final List<
    dynamic
  >
  historiales;
  const _MedicalHistoryList({
    required this.historiales,
  });

  String
  _formatFecha(
    DateTime fecha,
  ) =>
      DateFormat(
        'dd/MM/yyyy',
      ).format(
        fecha,
      );

  @override
  Widget build(
    BuildContext context,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: historiales
          .map(
            (
              historial,
            ) => Padding(
              padding: const EdgeInsets.only(
                bottom: 16.0,
              ),
              child: Container(
                padding: const EdgeInsets.all(
                  12,
                ),
                decoration: BoxDecoration(
                  color: AppColors.slate50Light,
                  borderRadius: BorderRadius.circular(
                    8,
                  ),
                  border: Border.all(
                    color: AppColors.slateBorder,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _formatFecha(
                        historial.fechaConsulta,
                      ),
                      style:
                          Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      'Diagnóstico:',
                      style:
                          Theme.of(
                            context,
                          ).textTheme.bodySmall?.copyWith(
                            color: AppColors.slate400Light,
                            fontSize: 12,
                          ),
                    ),
                    Text(
                      historial.diagnostico,
                      style:
                          Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textLight,
                          ),
                    ),
                    if (historial.tratamiento.isNotEmpty) ...[
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        'Tratamiento:',
                        style:
                            Theme.of(
                              context,
                            ).textTheme.bodySmall?.copyWith(
                              color: AppColors.slate400Light,
                              fontSize: 12,
                            ),
                      ),
                      Text(
                        historial.tratamiento,
                        style:
                            Theme.of(
                              context,
                            ).textTheme.bodyMedium?.copyWith(
                              color: AppColors.textLight,
                            ),
                      ),
                    ],
                    if (historial.notasAdicionales !=
                            null &&
                        historial.notasAdicionales!.isNotEmpty) ...[
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        'Notas adicionales:',
                        style:
                            Theme.of(
                              context,
                            ).textTheme.bodySmall?.copyWith(
                              color: AppColors.slate400Light,
                              fontSize: 12,
                            ),
                      ),
                      Text(
                        historial.notasAdicionales!,
                        style:
                            Theme.of(
                              context,
                            ).textTheme.bodyMedium?.copyWith(
                              color: AppColors.textLight,
                            ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _DownloadPdfButton
    extends
        StatelessWidget {
  @override
  Widget build(
    BuildContext context,
  ) {
    return ElevatedButton.icon(
      onPressed: () =>
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(
            const SnackBar(
              content: Text(
                'Función de descarga de PDF próximamente',
              ),
            ),
          ),
      icon: const Icon(
        Icons.download_rounded,
        size: 20,
      ),
      label: const Text(
        'Descargar PDF',
      ),
      style: ElevatedButton.styleFrom(
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
