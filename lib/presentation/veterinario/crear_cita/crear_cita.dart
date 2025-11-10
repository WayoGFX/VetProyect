import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:vet_smart_ids/presentation/veterinario/navbar/navbar_veterinario.dart';
import 'package:vet_smart_ids/providers/mascota_provider.dart';
import 'package:vet_smart_ids/providers/veterinario_provider.dart';
import 'package:vet_smart_ids/providers/cita_provider.dart';
import 'package:vet_smart_ids/models/cita.dart';
import 'package:vet_smart_ids/models/mascota.dart';
import 'package:vet_smart_ids/models/veterinario.dart';
import '../../../core/app_colors.dart';

class CrearCitaWidget extends StatefulWidget {
  static const String name = 'CrearCita';

  const CrearCitaWidget({super.key});

  @override
  State<CrearCitaWidget> createState() => _CrearCitaWidgetState();
}

class _CrearCitaWidgetState extends State<CrearCitaWidget> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _motivoController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _notasController = TextEditingController();

  DateTime? _fechaSeleccionada;
  TimeOfDay? _horaSeleccionada;
  Mascota? _mascotaSeleccionada;
  Veterinario? _veterinarioSeleccionado;
  String _estadoSeleccionado = 'Pendiente';

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Cargar mascotas y veterinarios al iniciar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MascotaProvider>().loadMascotas();
      context.read<VeterinarioProvider>().loadVeterinarios();
    });
  }

  @override
  void dispose() {
    _motivoController.dispose();
    _descripcionController.dispose();
    _notasController.dispose();
    super.dispose();
  }

  Future<void> _seleccionarFecha() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _fechaSeleccionada ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _fechaSeleccionada = picked;
      });
    }
  }

  Future<void> _seleccionarHora() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _horaSeleccionada ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _horaSeleccionada = picked;
      });
    }
  }

  String _formatFecha(DateTime? fecha) {
    if (fecha == null) return 'Seleccionar fecha';
    final meses = ['', 'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'];
    final dias = ['', 'Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];
    return '${dias[fecha.weekday]}, ${fecha.day} de ${meses[fecha.month]} de ${fecha.year}';
  }

  String _formatHora(TimeOfDay? hora) {
    if (hora == null) return 'Seleccionar hora';
    final hour = hora.hourOfPeriod == 0 ? 12 : hora.hourOfPeriod;
    final minute = hora.minute.toString().padLeft(2, '0');
    final period = hora.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  Future<void> _crearCita() async {
    if (_formKey.currentState!.validate()) {
      if (_mascotaSeleccionada == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor selecciona una mascota')),
        );
        return;
      }
      if (_veterinarioSeleccionado == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor selecciona un veterinario')),
        );
        return;
      }
      if (_fechaSeleccionada == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor selecciona una fecha')),
        );
        return;
      }
      if (_horaSeleccionada == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor selecciona una hora')),
        );
        return;
      }

      setState(() => _isLoading = true);

      // Combinar fecha y hora
      final fechaHora = DateTime(
        _fechaSeleccionada!.year,
        _fechaSeleccionada!.month,
        _fechaSeleccionada!.day,
        _horaSeleccionada!.hour,
        _horaSeleccionada!.minute,
      );

      final nuevaCita = Cita(
        mascotaId: _mascotaSeleccionada!.mascotaId,
        usuarioId: _mascotaSeleccionada!.usuarioId,
        veterinarioId: _veterinarioSeleccionado!.veterinarioId,
        fechaHora: fechaHora,
        motivo: _motivoController.text.trim(),
        citaDescripcion: _descripcionController.text.trim().isEmpty
            ? null
            : _descripcionController.text.trim(),
        notas: _notasController.text.trim().isEmpty
            ? null
            : _notasController.text.trim(),
        estado: _estadoSeleccionado,
      );

      final citaProvider = context.read<CitaProvider>();
      final success = await citaProvider.createCita(nuevaCita);

      setState(() => _isLoading = false);

      if (!mounted) return;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cita creada exitosamente'),
            backgroundColor: Colors.green,
          ),
        );
        context.pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(citaProvider.errorMessage ?? 'Error al crear la cita'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final mascotaProvider = context.watch<MascotaProvider>();
    final veterinarioProvider = context.watch<VeterinarioProvider>();

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
          icon: const Icon(Icons.arrow_back_ios_new),
          color: AppColors.textLight,
          onPressed: () => context.pop(),
        ),
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: mascotaProvider.isLoading || veterinarioProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Dropdown: Mascota
                    Text(
                      'Seleccionar Mascota',
                      style: textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    InputDecorator(
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.pets),
                        filled: true,
                        fillColor: AppColors.black05,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<Mascota>(
                          value: _mascotaSeleccionada,
                          isExpanded: true,
                          hint: const Text('Selecciona una mascota'),
                          items: mascotaProvider.mascotas.map((mascota) {
                            return DropdownMenuItem(
                              value: mascota,
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 16,
                                    backgroundColor: AppColors.primary20,
                                    child: Icon(
                                      Icons.pets,
                                      size: 16,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          mascota.nombre,
                                          style: const TextStyle(fontWeight: FontWeight.w600),
                                        ),
                                        Text(
                                          '${mascota.especie} - ${mascota.raza}',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: AppColors.slate500Light,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _mascotaSeleccionada = value;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Dropdown: Veterinario
                    Text(
                      'Veterinario Asignado',
                      style: textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    InputDecorator(
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.person),
                        filled: true,
                        fillColor: AppColors.black05,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<Veterinario>(
                          value: _veterinarioSeleccionado,
                          isExpanded: true,
                          hint: const Text('Selecciona un veterinario'),
                          items: veterinarioProvider.veterinarios.map((vet) {
                            return DropdownMenuItem(
                              value: vet,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    vet.nombreCompleto,
                                    style: const TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                  if (vet.especialidad != null && vet.especialidad.isNotEmpty)
                                    Text(
                                      vet.especialidad,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: AppColors.slate500Light,
                                      ),
                                    ),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _veterinarioSeleccionado = value;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Campo: Fecha
                    InkWell(
                      onTap: _seleccionarFecha,
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Fecha',
                          prefixIcon: const Icon(Icons.calendar_month),
                          filled: true,
                          fillColor: AppColors.black05,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          errorText: _fechaSeleccionada == null && _formKey.currentState?.validate() == false
                              ? 'Selecciona una fecha'
                              : null,
                        ),
                        child: Text(
                          _formatFecha(_fechaSeleccionada),
                          style: TextStyle(
                            fontSize: 16,
                            color: _fechaSeleccionada == null
                                ? AppColors.slate500Light
                                : AppColors.textLight,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Campo: Hora
                    InkWell(
                      onTap: _seleccionarHora,
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Hora',
                          prefixIcon: const Icon(Icons.schedule),
                          filled: true,
                          fillColor: AppColors.black05,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          errorText: _horaSeleccionada == null && _formKey.currentState?.validate() == false
                              ? 'Selecciona una hora'
                              : null,
                        ),
                        child: Text(
                          _formatHora(_horaSeleccionada),
                          style: TextStyle(
                            fontSize: 16,
                            color: _horaSeleccionada == null
                                ? AppColors.slate500Light
                                : AppColors.textLight,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Campo: Motivo
                    TextFormField(
                      controller: _motivoController,
                      decoration: InputDecoration(
                        labelText: 'Motivo de la consulta',
                        prefixIcon: const Icon(Icons.medical_services),
                        filled: true,
                        fillColor: AppColors.black05,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Ingresa el motivo de la consulta';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Campo: Descripción
                    TextFormField(
                      controller: _descripcionController,
                      maxLines: 2,
                      decoration: InputDecoration(
                        labelText: 'Descripción (opcional)',
                        prefixIcon: const Icon(Icons.notes),
                        alignLabelWithHint: true,
                        filled: true,
                        fillColor: AppColors.black05,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Campo: Notas Adicionales
                    TextFormField(
                      controller: _notasController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: 'Notas Adicionales (opcional)',
                        prefixIcon: const Icon(Icons.description),
                        alignLabelWithHint: true,
                        filled: true,
                        fillColor: AppColors.black05,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Botón Crear Cita
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _crearCita,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.textLight,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          textStyle: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text('Crear cita'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: const VetNavbar(
        currentRoute: '/agenda_citas',
      ),
    );
  }
}

