import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vet_smart_ids/core/app_theme.dart';
import 'package:vet_smart_ids/core/app_colors.dart';
import 'package:vet_smart_ids/presentation/veterinario/navbar/navbar_veterinario.dart';

/// Widget raíz de la aplicación que establece el tema
class PacientesApp
    extends
        StatelessWidget {
  const PacientesApp({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return MaterialApp(
      title: 'Vet_smart_ids - Pacientes',
      debugShowCheckedModeBanner: false,
      theme: lightTheme, // Aplica el tema claro
      themeMode: ThemeMode.system, // Usa la configuración del sistema
      home: const PacientesWidget(),
    );
  }
}

/// Contenedor principal de la pantalla de Pacientes
class PacientesWidget
    extends
        StatefulWidget {
  static const String name = 'PacientesWidget'; // Ruta de navegación

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
  @override
  Widget build(
    BuildContext context,
  ) {
    return const ListaPacientes();
  }
}

/// Muestra la lista y la UI de gestión de pacientes
class ListaPacientes
    extends
        StatelessWidget {
  const ListaPacientes({
    super.key,
  });

  // Datos simulados de pacientes
  final List<
    Map<
      String,
      String
    >
  >
  pacientes = const [
    {
      'name': 'Max',
      'nombre': 'max',
      'image': 'https://lh3.googleusercontent.com/aida-public/AB6AXuBaKPuzBW06LGsePkAIow9d6jqVGF05fJtdQPg5AQ7WwQddDO9oXc3m2ZubuFbTNboAfEZyTmbLinJ5shiY8QV49_L4VP_eDtuFlX9ybixL0AW4G43WloDCOQmkBz4qp8qHCosHwpPxk-gzq0w_1T8SQJBsibLj8iyQi1j_k5iLzqJQC3qXVAvRHEyYeR_0qLa0dXTWDnTlgB3AKA0t0lur54nNrX5_Ni4-BDL1O-XCVoQ4uUwzvF-qiT3yTuCAGrompkVgIYYLb3E',
    },
    {
      'name': 'Bella',
      'nombre': 'Bella',
      'image': 'https://lh3.googleusercontent.com/aida-public/AB6AXuA8kpFucsItJZdHfv7zgrVsARMX0oKJa8420CMlpmzbjjzQxOOH_27l3LgbFEeHTSSXhbxnwSMCLiE0Bq2OFclV-5j6cNr-k7OM6TzSHqXHXNaye2BNCK_HijC4Hh_aPYlDgT__tu0SkBdc_7E91eVY7xnFC6hnw67_r2awR-zkLnv5_TcEuFMgc0tJxvINOyWQbyez1mKJdLp7lGr4C7L1xFLGVaihd9GgRcxIFdpo9eCFUAlkk0FF_IiXXZLcGeaiynid1cBxJKM',
    },
    {
      'name': 'Rocky',
      'nombre': 'Rocky',
      'image': 'https://lh3.googleusercontent.com/aida-public/AB6AXuCpMJZ7Ny8d3cb4QjbNr9i_QI84vmsU2HXiWB9hr-9lrKtO2Hxuvmq0ODuRx7VTscQ-v6l_4rxQbZ9apBSiypKKZG_ySmTl8REZ7CfLtrwmXauOVBp7I5rfySgf-TIkHJCRqEchOtIOJ0YXr3zU0ZT8ogIs4tiK48NEw0r1G2CulrKBmKMKAyoCJZ7FMuuBjFbhL4ibW-YrpEmEHapgZStcqqbKXIBheDz8TYvy9OrtfrubKQuOrwDAgxhhraVh6m_YPUKO-FN-3QY',
    },
    {
      'name': 'Luna',
      'nombre': 'Luna',
      'image': 'https://lh3.googleusercontent.com/aida-public/AB6AXuD3SQTQKBLpb_hbb8aClUjOYL31-8PfnsGfh01oEW3IJWS0ZZi0ArDSICM7ENO1-oFXrP82eqohaq5yMQm1sxY5kSYXeQA6QzsVJvkgWV9byKhcO1-h65pMPfMU-gVGqWHjU43FQHqXWoLxfMpi3SS8Z0D-3V7f0MQVg0isv-6b0oDdkdFrSTe63TAfITerXSJTGZHiktl3AHQYu_wdct87oAawh4_l6x1FZBgA8ErEkr3cfyHMiTwO38ZOaQ0VG-3jcKBQABJAiT0',
    },
  ];

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
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

      body: Column(
        children: [
          // Campo de texto para la búsqueda
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            child: TextField(
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

          // Chips de filtro horizontal
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 8,
            ),
            child: Row(
              children: [
                _buildFilterChip(
                  context,
                  'Especie',
                ),
                const SizedBox(
                  width: 8,
                ),
                _buildFilterChip(
                  context,
                  'Edad',
                ),
                const SizedBox(
                  width: 8,
                ),
                _buildFilterChip(
                  context,
                  'Estado de salud',
                ),
              ],
            ),
          ),

          // Despliega la lista de pacientes con ListView
          Expanded(
            child: ListView.builder(
              itemCount: pacientes.length,
              itemBuilder:
                  (
                    context,
                    index,
                  ) {
                    final patient = pacientes[index];
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                          patient['image']!,
                        ),
                        radius: 28,
                      ),
                      title: Text(
                        patient['name']!,
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium,
                      ),
                      subtitle: Text(
                        'name: ${patient['name']}',
                        style: TextStyle(
                          color: AppColors.slate500Light,
                        ),
                      ),
                      trailing: const Icon(
                        Icons.chevron_right,
                      ),
                      onTap: () {
                        context.push(
                          '/ficha_paciente_veterinario',
                        );
                      },
                    );
                  },
            ),
          ),
        ],
      ),
      bottomNavigationBar: const VetNavbar(
        // Le pasamos la ruta estática para que el navbar resalte el ícono "Inicio".
        currentRoute: '/lista_pacientes',
      ),
    );
  }

  // Crea un chip interactivo para filtros
  Widget _buildFilterChip(
    BuildContext context,
    String label,
  ) {
    return FilterChip(
      label: Text(
        label,
        style: Theme.of(
          context,
        ).textTheme.bodyMedium,
      ),
      onSelected:
          (
            value,
          ) {}, // Maneja la selección del filtro
      backgroundColor: AppColors.primary20,
      selectedColor: AppColors.primary.withOpacity(
        0.4,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          50,
        ),
      ),
      selected: false,
    );
  }
}
