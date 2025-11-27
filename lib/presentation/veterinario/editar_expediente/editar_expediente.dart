import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:vet_smart_ids/core/app_colors.dart';
import 'package:vet_smart_ids/models/vacuna.dart';
import 'package:vet_smart_ids/models/alergia.dart';
import 'package:vet_smart_ids/models/mascota_vacuna.dart';
import 'package:vet_smart_ids/models/mascota_alergia.dart';
import 'package:vet_smart_ids/models/historial_medico.dart';
import 'package:vet_smart_ids/services/api_service.dart';
import 'package:vet_smart_ids/providers/mascota_provider.dart';
import 'package:vet_smart_ids/presentation/veterinario/navbar/navbar_veterinario.dart';

class EditarExpedienteWidget extends StatefulWidget {
  static const String name = 'EditarExpedienteWidget';
  const EditarExpedienteWidget({super.key});

  @override
  State<EditarExpedienteWidget> createState() => _EditarExpedienteWidgetState();
}

class _EditarExpedienteWidgetState extends State<EditarExpedienteWidget> {
  final ApiService _apiService = ApiService();
  final _formKey = GlobalKey<FormState>();

  // Controladores de historial médico
  final TextEditingController _diagnosticoController = TextEditingController();
  final TextEditingController _tratamientoController = TextEditingController();
  final TextEditingController _notasController = TextEditingController();

  // Listas de la API
  List<Vacuna> _vacunasDisponibles = [];
  List<Alergia> _alergiasDisponibles = [];

  // Selecciones
  Set<int> _vacunasSeleccionadas = {};
  Map<int, String> _lotesVacunas = {}; // vacunaId -> lote
  Map<int, DateTime> _fechasVacunas = {}; // vacunaId -> fecha
  Set<int> _alergiasSeleccionadas = {};
  Map<int, String> _notasAlergias = {}; // alergiaId -> notas

  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    setState(() => _isLoading = true);
    try {
      final provider = context.read<MascotaProvider>();
      final mascota = provider.mascotaSeleccionada;

      // Cargar listas de vacunas y alergias disponibles
      final vacunas = await _apiService.getVacunas();
      final alergias = await _apiService.getAlergias();

      // Cargar datos existentes del paciente si hay mascota seleccionada
      if (mascota != null && mascota.mascotaId != null) {
        await provider.loadPacienteDetalle(mascota.mascotaId!);
        final detalle = provider.pacienteDetalle;

        if (detalle != null) {
          // Prellenar vacunas ya aplicadas
          for (var vacunaAplicada in detalle.vacunas) {
            final vacunaId = vacunaAplicada.vacuna.vacunaId;
            if (vacunaId != null) {
              _vacunasSeleccionadas.add(vacunaId);
              _lotesVacunas[vacunaId] = vacunaAplicada.lote;
              _fechasVacunas[vacunaId] = vacunaAplicada.fechaAplicacion;
            }
          }

          // Prellenar alergias ya asociadas
          for (var alergiaDetalle in detalle.alergias) {
            final alergiaId = alergiaDetalle.alergia.alergiaId;
            if (alergiaId != null) {
              _alergiasSeleccionadas.add(alergiaId);
              if (alergiaDetalle.notas != null) {
                _notasAlergias[alergiaId] = alergiaDetalle.notas!;
              }
            }
          }

          // Prellenar último historial médico (si existe)
          if (detalle.historialMedico.isNotEmpty) {
            final ultimoHistorial = detalle.historialMedico.first;
            _diagnosticoController.text = ultimoHistorial.diagnostico;
            _tratamientoController.text = ultimoHistorial.tratamiento;
            if (ultimoHistorial.notasAdicionales != null) {
              _notasController.text = ultimoHistorial.notasAdicionales!;
            }
          }
        }
      }

      setState(() {
        _vacunasDisponibles = vacunas;
        _alergiasDisponibles = alergias;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cargar datos: $e')),
        );
      }
    }
  }

  Future<void> _guardarCambios() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<MascotaProvider>();
    final mascota = provider.mascotaSeleccionada;

    if (mascota == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No hay paciente seleccionado')),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      // Obtener relaciones existentes
      final todasVacunas = await _apiService.getMascotasVacunas();
      final todasAlergias = await _apiService.getMascotasAlergias();

      final vacunasExistentes = todasVacunas
          .where((mv) => mv.mascotaId == mascota.mascotaId)
          .toList();
      final alergiasExistentes = todasAlergias
          .where((ma) => ma.mascotaId == mascota.mascotaId)
          .toList();

      // 1. Procesar vacunas
      for (final vacunaId in _vacunasSeleccionadas) {
        // Buscar si ya existe esta asociación
        final existente = vacunasExistentes.firstWhere(
          (mv) => mv.vacunaId == vacunaId,
          orElse: () => MascotaVacuna(
            mascotaId: -1,
            vacunaId: -1,
            fechaAplicacion: DateTime.now(),
            lote: '',
          ),
        );

        if (existente.mascotaVacunaId != null) {
          // Actualizar si ya existe - NO incluir el ID en el objeto
          final mascotaVacuna = MascotaVacuna(
            mascotaId: mascota.mascotaId!,
            vacunaId: vacunaId,
            fechaAplicacion: _fechasVacunas[vacunaId] ?? DateTime.now(),
            lote: _lotesVacunas[vacunaId] ?? '',
          );
          await _apiService.updateMascotaVacuna(
            existente.mascotaVacunaId!,
            mascotaVacuna,
          );
        } else {
          // Crear nueva si no existe
          final mascotaVacuna = MascotaVacuna(
            mascotaId: mascota.mascotaId!,
            vacunaId: vacunaId,
            fechaAplicacion: _fechasVacunas[vacunaId] ?? DateTime.now(),
            lote: _lotesVacunas[vacunaId] ?? '',
          );
          await _apiService.createMascotaVacuna(mascotaVacuna);
        }
      }

      // 2. Procesar alergias
      for (final alergiaId in _alergiasSeleccionadas) {
        // Buscar si ya existe esta asociación
        final existente = alergiasExistentes.firstWhere(
          (ma) => ma.alergiaId == alergiaId,
          orElse: () => MascotaAlergia(
            mascotaId: -1,
            alergiaId: -1,
          ),
        );

        if (existente.mascotaAlergiaId != null) {
          // Actualizar si ya existe - NO incluir el ID en el objeto
          final mascotaAlergia = MascotaAlergia(
            mascotaId: mascota.mascotaId!,
            alergiaId: alergiaId,
            notas: _notasAlergias[alergiaId],
          );
          await _apiService.updateMascotaAlergia(
            existente.mascotaAlergiaId!,
            mascotaAlergia,
          );
        } else {
          // Crear nueva si no existe
          final mascotaAlergia = MascotaAlergia(
            mascotaId: mascota.mascotaId!,
            alergiaId: alergiaId,
            notas: _notasAlergias[alergiaId],
          );
          await _apiService.createMascotaAlergia(mascotaAlergia);
        }
      }

      // 3. Crear nuevo historial médico solo si hay cambios
      if (_diagnosticoController.text.isNotEmpty) {
        final detalle = provider.pacienteDetalle;
        bool debeCrearNuevo = true;

        // Verificar si es el mismo que el último historial
        if (detalle != null && detalle.historialMedico.isNotEmpty) {
          final ultimo = detalle.historialMedico.first;
          if (ultimo.diagnostico == _diagnosticoController.text.trim() &&
              ultimo.tratamiento == (_tratamientoController.text.isEmpty
                  ? 'Sin tratamiento especificado'
                  : _tratamientoController.text.trim()) &&
              (ultimo.notasAdicionales ?? '') ==
                  (_notasController.text.isEmpty ? '' : _notasController.text.trim())) {
            debeCrearNuevo = false; // No hay cambios, no crear duplicado
          }
        }

        if (debeCrearNuevo) {
          final historial = HistorialMedico(
            mascotaId: mascota.mascotaId!,
            veterinarioId: 1, // TODO: Obtener del usuario logueado
            usuarioId: mascota.usuarioId,
            diagnostico: _diagnosticoController.text.trim(),
            tratamiento: _tratamientoController.text.isEmpty
                ? 'Sin tratamiento especificado'
                : _tratamientoController.text.trim(),
            notasAdicionales: _notasController.text.isEmpty ? null : _notasController.text.trim(),
            fechaConsulta: DateTime.now(),
          );
          await _apiService.createHistorialMedico(historial);
        }
      }

      // 4. Recargar detalles del paciente
      await provider.loadPacienteDetalle(mascota.mascotaId!);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Expediente actualizado exitosamente')),
      );

      context.pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  void dispose() {
    _diagnosticoController.dispose();
    _tratamientoController.dispose();
    _notasController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MascotaProvider>();
    final mascota = provider.mascotaSeleccionada;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => context.pop(),
        ),
        title: const Text('Editar Expediente'),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : mascota == null
              ? const Center(child: Text('No hay paciente seleccionado'))
              : Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Información del paciente
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.primary20,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.pets,
                                  size: 30,
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      mascota.nombre,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '${mascota.especie} - ${mascota.raza}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: AppColors.slate600Light,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // SECCIÓN: Vacunas
                        _buildSectionTitle('Agregar Vacunas'),
                        _buildVacunasSection(),

                        const SizedBox(height: 24),

                        // SECCIÓN: Alergias
                        _buildSectionTitle('Agregar Alergias'),
                        _buildAlergiasSection(),

                        const SizedBox(height: 24),

                        // SECCIÓN: Nuevo Historial Médico
                        _buildSectionTitle('Agregar Historial Médico'),
                        _buildTextField(
                          controller: _diagnosticoController,
                          label: 'Diagnóstico *',
                          maxLines: 3,
                          validator: (v) => v?.isEmpty ?? true ? 'Campo requerido' : null,
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: _tratamientoController,
                          label: 'Tratamiento',
                          maxLines: 3,
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: _notasController,
                          label: 'Notas adicionales',
                          maxLines: 2,
                        ),

                        const SizedBox(height: 32),

                        // Botón Guardar
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isSaving ? null : _guardarCambios,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: _isSaving
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                                    'Guardar Cambios',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),

                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
      bottomNavigationBar: const VetNavbar(currentRoute: '/lista_pacientes'),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.textLight,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: AppColors.slate50Light,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.slateBorder),
        ),
      ),
      validator: validator,
      maxLines: maxLines,
    );
  }

  Widget _buildVacunasSection() {
    if (_vacunasDisponibles.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: Text('No hay vacunas registradas en el sistema')),
      );
    }

    return Column(
      children: _vacunasDisponibles.map((vacuna) {
        final isSelected = _vacunasSeleccionadas.contains(vacuna.vacunaId);
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: Column(
            children: [
              CheckboxListTile(
                value: isSelected,
                onChanged: (value) {
                  setState(() {
                    if (value == true) {
                      _vacunasSeleccionadas.add(vacuna.vacunaId!);
                      _fechasVacunas[vacuna.vacunaId!] = DateTime.now();
                    } else {
                      _vacunasSeleccionadas.remove(vacuna.vacunaId);
                      _lotesVacunas.remove(vacuna.vacunaId);
                      _fechasVacunas.remove(vacuna.vacunaId);
                    }
                  });
                },
                title: Text(
                  vacuna.nombre,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  vacuna.descripcion,
                  style: TextStyle(fontSize: 12, color: AppColors.slate500Light),
                ),
                activeColor: AppColors.primary,
              ),
              if (isSelected)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: Column(
                    children: [
                      TextField(
                        controller: TextEditingController(
                          text: _lotesVacunas[vacuna.vacunaId] ?? '',
                        ),
                        decoration: InputDecoration(
                          labelText: 'Lote',
                          isDense: true,
                          filled: true,
                          fillColor: AppColors.slate50Light,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onChanged: (value) => _lotesVacunas[vacuna.vacunaId!] = value,
                      ),
                      const SizedBox(height: 8),
                      InkWell(
                        onTap: () async {
                          final fecha = await showDatePicker(
                            context: context,
                            initialDate: _fechasVacunas[vacuna.vacunaId] ?? DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime.now(),
                          );
                          if (fecha != null) {
                            setState(() => _fechasVacunas[vacuna.vacunaId!] = fecha);
                          }
                        },
                        child: InputDecorator(
                          decoration: InputDecoration(
                            labelText: 'Fecha de aplicación',
                            isDense: true,
                            filled: true,
                            fillColor: AppColors.slate50Light,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            suffixIcon: const Icon(Icons.calendar_today, size: 18),
                          ),
                          child: Text(
                            '${_fechasVacunas[vacuna.vacunaId]!.day.toString().padLeft(2, '0')}/${_fechasVacunas[vacuna.vacunaId]!.month.toString().padLeft(2, '0')}/${_fechasVacunas[vacuna.vacunaId]!.year}',
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAlergiasSection() {
    if (_alergiasDisponibles.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: Text('No hay alergias registradas en el sistema')),
      );
    }

    return Column(
      children: _alergiasDisponibles.map((alergia) {
        final isSelected = _alergiasSeleccionadas.contains(alergia.alergiaId);
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: Column(
            children: [
              CheckboxListTile(
                value: isSelected,
                onChanged: (value) {
                  setState(() {
                    if (value == true) {
                      _alergiasSeleccionadas.add(alergia.alergiaId!);
                    } else {
                      _alergiasSeleccionadas.remove(alergia.alergiaId);
                      _notasAlergias.remove(alergia.alergiaId);
                    }
                  });
                },
                title: Text(
                  alergia.nombre,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  'Tipo: ${alergia.tipo}',
                  style: TextStyle(fontSize: 12, color: AppColors.slate500Light),
                ),
                activeColor: AppColors.primary,
              ),
              if (isSelected)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: TextField(
                    controller: TextEditingController(
                      text: _notasAlergias[alergia.alergiaId] ?? '',
                    ),
                    decoration: InputDecoration(
                      labelText: 'Notas adicionales',
                      isDense: true,
                      filled: true,
                      fillColor: AppColors.slate50Light,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    maxLines: 2,
                    onChanged: (value) => _notasAlergias[alergia.alergiaId!] = value,
                  ),
                ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
