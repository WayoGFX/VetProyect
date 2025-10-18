import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/app_colors.dart';

class CrearCitaWidget
    extends
        StatefulWidget {
  static const String name = 'CrearCita';

  const CrearCitaWidget({
    super.key,
  });

  @override
  State<
    CrearCitaWidget
  >
  createState() => _CrearCitaWidgetState();
}

class _CrearCitaWidgetState
    extends
        State<
          CrearCitaWidget
        > {
  final TextEditingController _fechaController = TextEditingController(
    text: 'Lunes, 20 de Mayo de 2024',
  );
  final TextEditingController _horaController = TextEditingController(
    text: '10:30 AM',
  );
  final TextEditingController _motivoController = TextEditingController(
    text: 'Chequeo anual y vacunación',
  );
  final TextEditingController _notasController = TextEditingController(
    text:
        'Max ha estado un poco decaído últimamente y ha perdido el apetito. '
        'Traer muestra de heces para análisis. Recordar revisar la cadera izquierda.',
  );

  String _veterinarioSeleccionado = 'Dr. Carlos Rodriguez';

  @override
  Widget build(
    BuildContext context,
  ) {
    final textTheme = Theme.of(
      context,
    ).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Crear Cita',
          style: GoogleFonts.epilogue(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textLight,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
          ),
          color: AppColors.textLight,
          onPressed: () => context.go(
            '/citas_del_dia',
          ), // Vuelve al menu principal
        ),
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(
          16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Información del paciente
            Row(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: AppColors.primary20,
                    shape: BoxShape.circle,
                  ),
                  child: ClipOval(
                    child: Image.network(
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuBQWtZBWDo8FaFdszSnQZ1A1sz5LOz27ekmfaJiFeaWWld8DosqR5HWTG7CvKd4SHkqf6U8NupB41JAewX6eU_jCFIazCf65dfH6DDo9EFPSgG4aSRkGE6qgRgS4qKcvGe4w42QS3VflJqm3AULCJRs5FVofXS6N36V9uAPOCyLWv946ROYgj1GFZEHkMsBsbeL5Gozo_sJZhsDSa06_dctXmhwnswjjg_m_XDaBbditOqYMxpXn7OTjIZYLjFSAPo5K45EkcVGrjk',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Max',
                      style: textTheme.titleLarge,
                    ),
                    Text(
                      'Golden Retriever',
                      style: textTheme.bodyMedium?.copyWith(
                        color: AppColors.slate500Light,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 24,
            ),

            // Campo: Fecha
            TextField(
              controller: _fechaController,
              decoration: InputDecoration(
                labelText: 'Fecha',
                prefixIcon: const Icon(
                  Icons.calendar_month,
                ),
                filled: true,
                fillColor: AppColors.black05,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    8,
                  ),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),

            // Campo: Hora
            TextField(
              controller: _horaController,
              decoration: InputDecoration(
                labelText: 'Hora',
                prefixIcon: const Icon(
                  Icons.schedule,
                ),
                filled: true,
                fillColor: AppColors.black05,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    8,
                  ),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),

            // Campo: Motivo
            TextField(
              controller: _motivoController,
              decoration: InputDecoration(
                labelText: 'Motivo de la consulta',
                prefixIcon: const Icon(
                  Icons.medical_services,
                ),
                filled: true,
                fillColor: AppColors.black05,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    8,
                  ),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),

            // Dropdown: Veterinario
            InputDecorator(
              decoration: InputDecoration(
                labelText: 'Veterinario Asignado',
                prefixIcon: const Icon(
                  Icons.person,
                ),
                filled: true,
                fillColor: AppColors.black05,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    8,
                  ),
                  borderSide: BorderSide.none,
                ),
              ),
              child: DropdownButtonHideUnderline(
                child:
                    DropdownButton<
                      String
                    >(
                      value: _veterinarioSeleccionado,
                      isExpanded: true,
                      items: const [
                        DropdownMenuItem(
                          value: 'Dr. Carlos Rodriguez',
                          child: Text(
                            'Dr. Carlos Rodriguez',
                          ),
                        ),
                        DropdownMenuItem(
                          value: 'Dra. Ana Martinez',
                          child: Text(
                            'Dra. Ana Martinez',
                          ),
                        ),
                        DropdownMenuItem(
                          value: 'Dr. Juan Perez',
                          child: Text(
                            'Dr. Juan Perez',
                          ),
                        ),
                      ],
                      onChanged:
                          (
                            value,
                          ) {
                            setState(
                              () {
                                _veterinarioSeleccionado = value!;
                              },
                            );
                          },
                    ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),

            // Campo: Notas Adicionales
            TextField(
              controller: _notasController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: 'Notas Adicionales',
                prefixIcon: const Icon(
                  Icons.description,
                ),
                alignLabelWithHint: true,
                filled: true,
                fillColor: AppColors.black05,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    8,
                  ),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(
              height: 24,
            ),

            // Botón Guardar Cambios
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Cambios guardados',
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.textLight,
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                  ),
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: const Text(
                  'Crear cita ',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
