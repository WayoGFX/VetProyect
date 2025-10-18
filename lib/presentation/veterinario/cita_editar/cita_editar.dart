import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vet_smart_ids/core/app_colors.dart';

class GestureEditar
    extends
        StatefulWidget {
  const GestureEditar({
    Key? key,
  }) : super(
         key: key,
       );
  static const String name = "gesture_editar"; // Ruta de navegación

  @override
  State<
    GestureEditar
  >
  createState() => _EditarCitaPageState();
}

class _EditarCitaPageState
    extends
        State<
          GestureEditar
        > {
  // Controladores inicializados con datos de ejemplo
  final TextEditingController dateController = TextEditingController(
    text: "Lunes, 20 de Mayo de 2024",
  );
  final TextEditingController timeController = TextEditingController(
    text: "10:30 AM",
  );
  final TextEditingController reasonController = TextEditingController(
    text: "Chequeo anual y vacunación",
  );
  final TextEditingController notesController = TextEditingController(
    text: "Max ha estado un poco decaído últimamente y ha perdido el apetito. Traer muestra de heces para análisis. Recordar revisar la cadera izquierda, mostró sensibilidad al tacto.",
  );

  String selectedVet = "Dr. Carlos Rodriguez";
  // Lista de veterinarios disponibles para el dropdown
  final List<
    String
  >
  vets = [
    "Dr. Carlos Rodriguez",
    "Dra. Ana Martinez",
    "Dr. Juan Perez",
  ];

  int currentIndex = 2; // Índice de la pestaña 'Citas' en el BottomNavigationBar

  @override
  Widget build(
    BuildContext context,
  ) {
    final isDark =
        Theme.of(
          context,
        ).brightness ==
        Brightness.dark;

    return Scaffold(
      // Determina el color de fondo según el tema
      backgroundColor: isDark
          ? AppColors.textLight
          : AppColors.backgroundLight,
      appBar: AppBar(
        // AppBar con transparencia
        backgroundColor:
            (isDark
                    ? AppColors.textLight
                    : AppColors.backgroundLight)
                .withOpacity(
                  0.8,
                ),
        elevation: 0,
        title: const Text(
          "Editar Cita",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: isDark
                ? AppColors.white
                : AppColors.black,
          ),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(
          16,
        ),
        child: Column(
          children: [
            Container(
              // Contenedor principal del formulario con sombra
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.textLight
                    : AppColors.cardLight,
                borderRadius: BorderRadius.circular(
                  24,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isDark
                        ? Colors.black26
                        : AppColors.black05, // Uso de black05 para sombra clara
                    blurRadius: 10,
                  ),
                ],
              ),
              padding: const EdgeInsets.all(
                24,
              ),
              child: Column(
                children: [
                  // Muestra la información de la mascota
                  Row(
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(
                            0.2,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                            9999,
                          ),
                          child: Image.network(
                            'https://lh3.googleusercontent.com/aida-public/AB6AXuBQWtZBWDo8FaFdszSnQZ1A1sz5LOz27ekmfaJiFeaWWld8DosqR5HWTG7CvKd4SHkqf6U8NupB41JAewX6eU_jCFIazCf65dfH6DDo9EFPSgG4aSRkGE6qgRgS4qKcvGe4w42QS3VflJqm3AULCJRs5FVofXS6N36V9uAPOCyLWv946ROYgj1GFZEHkMsBsbeL5Gozo_sJZhsDSa06_dctXmhwnswjjg_m_XDaBbditOqYMxpXn7OTjIZYLjFSAPo5K45EkcVGrjk',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Max",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: isDark
                                  ? AppColors.white
                                  : AppColors.textLight,
                            ),
                          ),
                          Text(
                            "Golden Retriever",
                            style: TextStyle(
                              color: isDark
                                  ? AppColors.slate600Light.withOpacity(
                                      0.7,
                                    )
                                  : AppColors.slate600Light,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 24,
                  ),

                  // Campos del formulario para editar la cita
                  _buildInputField(
                    context,
                    controller: dateController,
                    label: "Fecha",
                    icon: Icons.calendar_month,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  _buildInputField(
                    context,
                    controller: timeController,
                    label: "Hora",
                    icon: Icons.schedule,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  _buildTextArea(
                    context,
                    controller: reasonController,
                    label: "Motivo de la consulta",
                    icon: Icons.medical_services,
                    rows: 2,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  _buildDropdown(
                    context,
                    label: "Veterinario Asignado",
                    icon: Icons.person,
                    value: selectedVet,
                    options: vets,
                    onChanged:
                        (
                          value,
                        ) {
                          setState(
                            () {
                              selectedVet = value!; // Actualiza el veterinario seleccionado
                            },
                          );
                        },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  _buildTextArea(
                    context,
                    controller: notesController,
                    label: "Notas Adicionales",
                    icon: Icons.description,
                    rows: 4,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            // Botón para guardar las modificaciones
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Lógica para guardar la cita y posibles validaciones
                  debugPrint(
                    "Editando cita...",
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      16,
                    ),
                  ),
                ),
                child: const Text(
                  "Guardar Cambios",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 80,
            ), // Espacio para que el nav bar no cubra contenido
          ],
        ),
      ),
      // Componente de navegación inferior
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: isDark
            ? AppColors.textLight
            : AppColors.backgroundLight,
        currentIndex: currentIndex,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: isDark
            ? AppColors.slate600Light.withOpacity(
                0.7,
              )
            : AppColors.slate600Light,
        type: BottomNavigationBarType.fixed,
        onTap:
            (
              index,
            ) {
              setState(
                () {
                  currentIndex = index;
                  // Manejo de la navegación según el índice
                },
              );
            },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.pets,
            ),
            label: 'Pacientes',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.calendar_month,
            ),
            label: 'Citas',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.notifications,
            ),
            label: 'Recordatorios',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
            ),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }

  // Widget para campos de texto de una sola línea
  Widget _buildInputField(
    BuildContext context, {
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    final isDark =
        Theme.of(
          context,
        ).brightness ==
        Brightness.dark;
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Icon(
          icon,
          color: isDark
              ? AppColors.white
              : AppColors.slate600Light,
        ),
        labelText: label,
        labelStyle: TextStyle(
          color: isDark
              ? AppColors.white
              : AppColors.slate600Light,
          fontWeight: FontWeight.w500,
        ),
        filled: true,
        fillColor: isDark
            ? AppColors.textLight
            : AppColors.backgroundLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            12,
          ),
          borderSide: BorderSide(
            color: AppColors.slateBorder,
          ),
        ),
      ),
    );
  }

  // Widget para áreas de texto multi-línea
  Widget _buildTextArea(
    BuildContext context, {
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required int rows,
  }) {
    final isDark =
        Theme.of(
          context,
        ).brightness ==
        Brightness.dark;
    return TextField(
      controller: controller,
      maxLines: rows,
      decoration: InputDecoration(
        // Ajuste de padding para el ícono en textareas
        prefixIcon: Padding(
          padding: const EdgeInsets.only(
            top: 12,
          ),
          child: Icon(
            icon,
            color: isDark
                ? AppColors.white
                : AppColors.slate600Light,
          ),
        ),
        labelText: label,
        labelStyle: TextStyle(
          color: isDark
              ? AppColors.white
              : AppColors.slate600Light,
          fontWeight: FontWeight.w500,
        ),
        filled: true,
        fillColor: isDark
            ? AppColors.textLight
            : AppColors.backgroundLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            12,
          ),
          borderSide: BorderSide(
            color: AppColors.slateBorder,
          ),
        ),
      ),
    );
  }

  // Widget para el campo de selección (Dropdown)
  Widget _buildDropdown(
    BuildContext context, {
    required String label,
    required IconData icon,
    required String value,
    required List<
      String
    >
    options,
    required ValueChanged<
      String?
    >
    onChanged,
  }) {
    final isDark =
        Theme.of(
          context,
        ).brightness ==
        Brightness.dark;
    return InputDecorator(
      decoration: InputDecoration(
        prefixIcon: Icon(
          icon,
          color: isDark
              ? AppColors.white
              : AppColors.slate600Light,
        ),
        labelText: label,
        labelStyle: TextStyle(
          color: isDark
              ? AppColors.white
              : AppColors.slate600Light,
          fontWeight: FontWeight.w500,
        ),
        filled: true,
        fillColor: isDark
            ? AppColors.textLight
            : AppColors.backgroundLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            12,
          ),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child:
            DropdownButton<
              String
            >(
              value: value,
              isExpanded: true,
              onChanged: onChanged,
              // Mapea la lista de opciones a DropdownMenuItem
              items: options
                  .map(
                    (
                      opt,
                    ) => DropdownMenuItem(
                      value: opt,
                      child: Text(
                        opt,
                      ),
                    ),
                  )
                  .toList(),
            ),
      ),
    );
  }
}
