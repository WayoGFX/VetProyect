import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:vet_smart_ids/core/app_colors.dart';
import 'package:vet_smart_ids/presentation/usuario/navbar/navbar_usuario.dart';
import 'package:vet_smart_ids/providers/mascota_provider.dart';

/// Pantalla del perfil de mascota del usuario
/// Muestra toda la información de la mascota seleccionada
class PerfilMascotaScreen extends StatefulWidget {
  /// Nombre estático para la gestión de rutas
  static const String name = 'perfil_mascota_screen';

  const PerfilMascotaScreen({
    super.key,
  });

  @override
  State<PerfilMascotaScreen> createState() => _PerfilMascotaScreenState();
}

class _PerfilMascotaScreenState extends State<PerfilMascotaScreen> {
  @override
  void initState() {
    super.initState();
    // Cargar la información completa de la mascota después de que se construya el widget
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<MascotaProvider>();
      if (provider.mascotaSeleccionada != null) {
        provider.loadPacienteDetalle(provider.mascotaSeleccionada!.mascotaId!);
      }
    });
  }

  String _calcularEdad(DateTime fechaNacimiento) {
    final ahora = DateTime.now();
    final diferencia = ahora.difference(fechaNacimiento);
    final anos = (diferencia.inDays / 365).floor();
    final meses = ((diferencia.inDays % 365) / 30).floor();
    if (anos > 0) {
      return '$anos ${anos == 1 ? 'año' : 'años'}';
    } else if (meses > 0) {
      return '$meses ${meses == 1 ? 'mes' : 'meses'}';
    } else {
      final dias = diferencia.inDays;
      return '$dias ${dias == 1 ? 'día' : 'días'}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => context.pop(),
        ),
        title: const Text('Perfil de la Mascota'),
        centerTitle: true,
      ),
      body: Consumer<MascotaProvider>(
        builder: (context, mascotaProvider, child) {
          // Mostrar indicador de carga
          if (mascotaProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // Mostrar error si ocurre
          if (mascotaProvider.errorMessage != null) {
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
                    'Error al cargar información de la mascota',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    mascotaProvider.errorMessage!,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      if (mascotaProvider.mascotaSeleccionada != null) {
                        mascotaProvider.loadPacienteDetalle(
                          mascotaProvider.mascotaSeleccionada!.mascotaId!,
                        );
                      }
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }

          final mascota = mascotaProvider.mascotaSeleccionada;
          if (mascota == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.pets_outlined,
                    size: 64,
                    color: AppColors.slate400Light,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Selecciona una mascota',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
            );
          }

          final edad = _calcularEdad(mascota.fechaNacimiento);

          return SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 100),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Sección superior: Foto y nombre
                  Center(
                    child: Column(
                      children: [
                        // Imagen de perfil redondeada
                        CircleAvatar(
                          radius: 64,
                          backgroundColor: AppColors.primary20,
                          backgroundImage: mascota.fotoUrl != null &&
                                  mascota.fotoUrl!.isNotEmpty
                              ? NetworkImage(mascota.fotoUrl!)
                              : null,
                          child: mascota.fotoUrl == null ||
                                  mascota.fotoUrl!.isEmpty
                              ? Icon(
                                  Icons.pets,
                                  size: 64,
                                  color: AppColors.primary,
                                )
                              : null,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          mascota.nombre,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontSize: 24,
                              ),
                        ),
                        Text(
                          mascota.raza,
                          style: TextStyle(
                            color: AppColors.slate500Light,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary20,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Edad: $edad',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Tarjeta con información general
                  _InfoCard(
                    title: 'Información General',
                    child: Column(
                      children: [
                        _InfoRow(
                          label: 'Especie',
                          value: mascota.especie,
                        ),
                        _InfoRow(
                          label: 'Raza',
                          value: mascota.raza,
                        ),
                        _InfoRow(
                          label: 'Fecha de Nacimiento',
                          value: DateFormat('dd/MM/yyyy')
                              .format(mascota.fechaNacimiento),
                        ),
                        _InfoRow(
                          label: 'ID Mascota',
                          value: mascota.mascotaId?.toString() ?? 'N/A',
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Tarjeta de observaciones
                  if (mascota.observaciones != null &&
                      mascota.observaciones!.isNotEmpty)
                    _InfoCard(
                      title: 'Observaciones',
                      child: Text(
                        mascota.observaciones!,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.slate500Light,
                            ),
                      ),
                    ),

                  if (mascota.observaciones != null &&
                      mascota.observaciones!.isNotEmpty)
                    const SizedBox(height: 24),

                  // Botones: historial médico y abrir expediente
                  Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // Aquí puedes navegar a la pantalla de historial completo
                            // context.push('/historial_medico_completo');
                          },
                          icon: const Icon(Icons.receipt_long),
                          label: const Text('Ver Historial Médico Completo'),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: AppColors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            // Navegar al expediente de la mascota
                            context.push('/expediente_mascota');
                          },
                          icon: const Icon(Icons.folder_shared_outlined),
                          label: const Text('Abrir Expediente'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          );
        },
      ),
      // Navbar
      bottomNavigationBar: const UserNavbar(
        currentRoute: '/perfil_mascota',
      ),
    );
  }
}

// Widgets Reutilizables

/// Tarjeta de contenedor para secciones de información
class _InfoCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _InfoCard({
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.primary20,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

/// Fila para mostrar una etiqueta y un valor
class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: AppColors.primary20,
              width: 1.0,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: AppColors.slate500Light,
                ),
              ),
              Expanded(
                child: Text(
                  value,
                  textAlign: TextAlign.right,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
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
