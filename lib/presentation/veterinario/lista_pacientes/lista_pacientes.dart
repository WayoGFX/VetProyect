import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:vet_smart_ids/core/app_colors.dart';
import 'package:vet_smart_ids/models/mascota.dart';
import 'package:vet_smart_ids/presentation/veterinario/navbar/navbar_veterinario.dart';
import 'package:vet_smart_ids/providers/mascota_provider.dart';

class PacientesWidget
    extends
        StatefulWidget {
  static const String name = 'PacientesWidget';
  const PacientesWidget({
    super.key,
  });

  @override
  State<
    PacientesWidget
  >
  createState() => _PacientesWidgetState();
}

class _PacientesWidgetState
    extends
        State<
          PacientesWidget
        > {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String? _especieSeleccionada;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (
        _,
      ) {
        context
            .read<
              MascotaProvider
            >()
            .loadMascotas();
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<
    Mascota
  >
  _filtrarMascotas(
    List<
      Mascota
    >
    mascotas,
  ) {
    return mascotas.where(
      (
        mascota,
      ) {
        final matchSearch =
            _searchQuery.isEmpty ||
            mascota.nombre.toLowerCase().contains(
              _searchQuery.toLowerCase(),
            ) ||
            (mascota.mascotaId?.toString().contains(
                  _searchQuery,
                ) ??
                false);

        final matchEspecie =
            _especieSeleccionada ==
                null ||
            _especieSeleccionada ==
                'Todas' ||
            mascota.especie.toLowerCase() ==
                _especieSeleccionada!.toLowerCase();

        return matchSearch &&
            matchEspecie;
      },
    ).toList();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Pacientes',
          style: Theme.of(
            context,
          ).textTheme.titleLarge,
        ),
        centerTitle: true,
      ),
      body:
          Consumer<
            MascotaProvider
          >(
            builder:
                (
                  context,
                  mascotaProvider,
                  child,
                ) {
                  if (mascotaProvider.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (mascotaProvider.errorMessage !=
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
                            'Error al cargar pacientes',
                            style: Theme.of(
                              context,
                            ).textTheme.titleLarge,
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            mascotaProvider.errorMessage!,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          ElevatedButton.icon(
                            onPressed: () => mascotaProvider.loadMascotas(),
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

                  final mascotasFiltradas = _filtrarMascotas(
                    mascotaProvider.mascotas,
                  );

                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: TextField(
                          controller: _searchController,
                          onChanged:
                              (
                                value,
                              ) => setState(
                                () => _searchQuery = value,
                              ),
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.search,
                            ),
                            hintText: 'Buscar por nombre o código',
                            filled: true,
                            fillColor: Theme.of(
                              context,
                            ).colorScheme.surface,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                12,
                              ),
                              borderSide: BorderSide(
                                color: AppColors.slateBorder,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 8,
                        ),
                        child: Row(
                          children: [
                            _buildFilterChip(
                              'Todas',
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            _buildFilterChip(
                              'Canino',
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            _buildFilterChip(
                              'Felino',
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            _buildFilterChip(
                              'Ave',
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            _buildFilterChip(
                              'Acuático',
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            _buildFilterChip(
                              'Roedor',
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Row(
                          children: [
                            Text(
                              '${mascotasFiltradas.length} ${mascotasFiltradas.length == 1 ? 'paciente' : 'pacientes'}',
                              style: TextStyle(
                                color: AppColors.slate600Light,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: mascotasFiltradas.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.pets_outlined,
                                      size: 64,
                                      color: AppColors.slate400Light,
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    Text(
                                      _searchQuery.isNotEmpty ||
                                              _especieSeleccionada !=
                                                  null
                                          ? 'No se encontraron pacientes'
                                          : 'No hay pacientes registrados',
                                      style: TextStyle(
                                        color: AppColors.slate500Light,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : RefreshIndicator(
                                onRefresh: () => mascotaProvider.loadMascotas(),
                                child: ListView.builder(
                                  itemCount: mascotasFiltradas.length,
                                  itemBuilder:
                                      (
                                        context,
                                        index,
                                      ) {
                                        return _PacienteCard(
                                          mascota: mascotasFiltradas[index],
                                        );
                                      },
                                ),
                              ),
                      ),
                    ],
                  );
                },
          ),
      bottomNavigationBar: const VetNavbar(
        currentRoute: '/lista_pacientes',
      ),
    );
  }

  Widget _buildFilterChip(
    String label,
  ) {
    final isSelected =
        _especieSeleccionada ==
            label ||
        (label ==
                'Todas' &&
            _especieSeleccionada ==
                null);
    return FilterChip(
      label: Text(
        label,
      ),
      selected: isSelected,
      onSelected:
          (
            selected,
          ) {
            setState(
              () {
                _especieSeleccionada = selected
                    ? (label ==
                              'Todas'
                          ? null
                          : label)
                    : null;
              },
            );
          },
      backgroundColor: AppColors.primary20,
      selectedColor: AppColors.primary,
      labelStyle: TextStyle(
        color: isSelected
            ? Colors.white
            : AppColors.textLight,
        fontWeight: isSelected
            ? FontWeight.bold
            : FontWeight.normal,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          50,
        ),
      ),
    );
  }
}

class _PacienteCard
    extends
        StatelessWidget {
  final Mascota mascota;
  const _PacienteCard({
    required this.mascota,
  });

  String _calcularEdad(
    DateTime fechaNacimiento,
  ) {
    final ahora = DateTime.now();
    final diferencia = ahora.difference(
      fechaNacimiento,
    );
    final anos =
        (diferencia.inDays /
                365)
            .floor();
    final meses =
        ((diferencia.inDays %
                    365) /
                30)
            .floor();
    if (anos >
        0) {
      return '$anos ${anos == 1 ? 'año' : 'años'}';
    } else if (meses >
        0) {
      return '$meses ${meses == 1 ? 'mes' : 'meses'}';
    } else {
      final dias = diferencia.inDays;
      return '$dias ${dias == 1 ? 'día' : 'días'}';
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final edad = _calcularEdad(
      mascota.fechaNacimiento,
    );
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 6,
      ),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          12,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        leading: CircleAvatar(
          radius: 28,
          backgroundColor: AppColors.primary20,
          backgroundImage:
              mascota.fotoUrl !=
                      null &&
                  mascota.fotoUrl!.isNotEmpty
              ? NetworkImage(
                  mascota.fotoUrl!,
                )
              : null,
          child:
              mascota.fotoUrl ==
                      null ||
                  mascota.fotoUrl!.isEmpty
              ? Icon(
                  Icons.pets,
                  color: AppColors.primary,
                  size: 28,
                )
              : null,
        ),
        title: Text(
          mascota.nombre,
          style:
              Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 4,
            ),
            Text(
              '${mascota.especie} • ${mascota.raza}',
              style: TextStyle(
                color: AppColors.slate500Light,
                fontSize: 14,
              ),
            ),
            const SizedBox(
              height: 2,
            ),
            Text(
              'Edad: $edad • ID: ${mascota.mascotaId}',
              style: TextStyle(
                color: AppColors.slate400Light,
                fontSize: 12,
              ),
            ),
          ],
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: AppColors.slate400Light,
        ),
        onTap: () {
          context
              .read<
                MascotaProvider
              >()
              .selectMascota(
                mascota,
              );
          context.push(
            '/ficha_paciente_veterinario',
          );
        },
      ),
    );
  }
}
