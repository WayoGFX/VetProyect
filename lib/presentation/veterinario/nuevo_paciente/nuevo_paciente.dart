import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vet_smart_ids/core/app_colors.dart';
import 'package:vet_smart_ids/core/app_theme.dart';

/// Modelo para una entrada en el historial clínico
class HistoryEntry {
  String title;
  bool done;
  HistoryEntry({
    required this.title,
    this.done = false,
  });
}

/// Widget raíz que aplica el tema global
class NuevoPacienteApp
    extends
        StatelessWidget {
  const NuevoPacienteApp({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return MaterialApp(
      title: 'Vet_smart_ids - Nuevo Paciente',
      debugShowCheckedModeBanner: false,
      theme: lightTheme, // Aplica el tema global
      themeMode: ThemeMode.system,
      home: const NuevoPacienteWidget(),
    );
  }
}

/// Contenedor principal de la pantalla de Nuevo Paciente
class NuevoPacienteWidget
    extends
        StatefulWidget {
  static const String name = 'NuevoPacienteWidget'; // Ruta de navegación

  const NuevoPacienteWidget({
    super.key,
  });

  @override
  State<
    NuevoPacienteWidget
  >
  createState() => _NuevoPacienteWidgetState();
}

class _NuevoPacienteWidgetState
    extends
        State<
          NuevoPacienteWidget
        > {
  // Controladores de los campos del formulario
  final TextEditingController nombreAnimalController = TextEditingController();
  final TextEditingController propietarioController = TextEditingController();
  final TextEditingController contactoController = TextEditingController();
  final TextEditingController direccionController = TextEditingController();

  // Variables de estado para los selectores
  String? especieSeleccionada;
  String? razaSeleccionada;

  // Lista simulada del historial médico
  final List<
    HistoryEntry
  >
  historial = [
    HistoryEntry(
      title: 'Chequeo General',
      done: true,
    ),
    HistoryEntry(
      title: 'Vacunación',
      done: false,
    ),
  ];

  @override
  void dispose() {
    // Libera los recursos de los controladores
    nombreAnimalController.dispose();
    propietarioController.dispose();
    contactoController.dispose();
    direccionController.dispose();
    super.dispose();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final textTheme = Theme.of(
      context,
    ).textTheme;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
          ),
          onPressed: () => context.go(
            '/citas_del_dia',
          ), // Vuelve al menu principal// Vuelve a la pantalla anterior
        ),
        title: Text(
          'Nuevo Paciente',
          style: textTheme.titleLarge,
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(
          16,
        ),
        child: Column(
          children: [
            // Área para cargar la foto de la mascota
            Column(
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppColors.black05, // Fondo del avatar
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.pets,
                    size: 50,
                    color: AppColors.black40,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                ElevatedButton.icon(
                  onPressed: () {}, // Lógica para seleccionar/tomar foto
                  icon: const Icon(
                    Icons.add_a_photo,
                  ),
                  label: const Text(
                    'Agregar Foto',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: 24,
            ),

            // Formulario de datos del paciente
            _buildTextField(
              controller: nombreAnimalController,
              label: 'Nombre del animal',
              hint: 'Ej. Rocky',
            ),
            const SizedBox(
              height: 16,
            ),

            // Dropdown de selección de especie
            _buildDropdown(
              label: 'Especie',
              value: especieSeleccionada,
              items: const [
                DropdownMenuItem(
                  value: 'dog',
                  child: Text(
                    'Perro',
                  ),
                ),
                DropdownMenuItem(
                  value: 'cat',
                  child: Text(
                    'Gato',
                  ),
                ),
                DropdownMenuItem(
                  value: 'bird',
                  child: Text(
                    'Ave',
                  ),
                ),
              ],
              onChanged:
                  (
                    value,
                  ) => setState(
                    () => especieSeleccionada = value,
                  ),
            ),
            const SizedBox(
              height: 16,
            ),

            // Dropdown de selección de raza
            _buildDropdown(
              label: 'Raza',
              value: razaSeleccionada,
              items: const [
                DropdownMenuItem(
                  value: 'labrador',
                  child: Text(
                    'Labrador',
                  ),
                ),
                DropdownMenuItem(
                  value: 'siamese',
                  child: Text(
                    'Siamés',
                  ),
                ),
                DropdownMenuItem(
                  value: 'canary',
                  child: Text(
                    'Canario',
                  ),
                ),
              ],
              onChanged:
                  (
                    value,
                  ) => setState(
                    () => razaSeleccionada = value,
                  ),
            ),
            const SizedBox(
              height: 16,
            ),

            // Datos del propietario
            _buildTextField(
              controller: propietarioController,
              label: 'Nombre del propietario',
              hint: 'Ej. Juan Pérez',
            ),
            const SizedBox(
              height: 16,
            ),

            _buildTextField(
              controller: contactoController,
              label: 'Contacto',
              hint: 'Ej. 555-1234',
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(
              height: 16,
            ),

            _buildTextField(
              controller: direccionController,
              label: 'Dirección',
              hint: 'Ej. Calle Falsa 123',
            ),
            const SizedBox(
              height: 24,
            ),

            // Encabezado para la lista del historial
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Historial del Paciente',
                style: textTheme.titleMedium,
              ),
            ),
            const SizedBox(
              height: 12,
            ),

            // Lista del historial con scroll deshabilitado
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: historial.length,
              separatorBuilder:
                  (
                    _,
                    __,
                  ) => const SizedBox(
                    height: 8,
                  ),
              itemBuilder:
                  (
                    context,
                    index,
                  ) {
                    final entry = historial[index];
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.black05, // Fondo de la entrada
                        borderRadius: BorderRadius.circular(
                          8,
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              entry.title,
                              style: textTheme.bodyMedium!.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              right: 8,
                            ),
                            child: Text(
                              entry.done
                                  ? 'Realizado'
                                  : 'Pendiente', // Muestra el estado
                              style: TextStyle(
                                fontSize: 13,
                                color: entry.done
                                    ? Colors.green.shade700
                                    : AppColors.slate600Light,
                              ),
                            ),
                          ),
                          Switch(
                            value: entry.done,
                            activeColor: AppColors.primary,
                            onChanged:
                                (
                                  value,
                                ) {
                                  setState(
                                    () {
                                      entry.done = value; // Actualiza el estado del historial
                                    },
                                  );
                                },
                          ),
                        ],
                      ),
                    );
                  },
            ),

            const SizedBox(
              height: 32,
            ),

            // Botón de acción principal
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Lógica para guardar el nuevo paciente
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.white,
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                  ),
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: const Text(
                  'Guardar Registro',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Crea un campo de texto con estilo consistente
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        filled: true,
        fillColor: AppColors.black05, // Usa el color de fondo definido
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            8,
          ),
          borderSide: BorderSide.none, // Borde sin línea visible
        ),
      ),
    );
  }

  /// Crea un selector (Dropdown) con estilo consistente
  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<
      DropdownMenuItem<
        String
      >
    >
    items,
    required void Function(
      String?,
    )
    onChanged,
  }) {
    return DropdownButtonFormField<
      String
    >(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: AppColors.black05,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            8,
          ),
          borderSide: BorderSide.none,
        ),
      ),
      items: items,
      onChanged: onChanged, // Actualiza el estado al cambiar
    );
  }
}
