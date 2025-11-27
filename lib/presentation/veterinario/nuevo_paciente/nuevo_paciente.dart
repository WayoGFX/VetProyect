import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:vet_smart_ids/core/app_colors.dart';
import 'package:vet_smart_ids/models/usuario.dart';
import 'package:vet_smart_ids/models/vacuna.dart';
import 'package:vet_smart_ids/models/alergia.dart';
import 'package:vet_smart_ids/models/mascota.dart';
import 'package:vet_smart_ids/services/api_service.dart';
import 'package:vet_smart_ids/providers/mascota_provider.dart';
import 'package:vet_smart_ids/presentation/veterinario/navbar/navbar_veterinario.dart';

class NuevoPacienteWidget
    extends
        StatefulWidget {
  static const String name = 'NuevoPacienteWidget';
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
  final ApiService _apiService = ApiService();
  final _formKey =
      GlobalKey<
        FormState
      >();

  // Controladores de campos de mascota
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _especieController = TextEditingController();
  final TextEditingController _razaController = TextEditingController();
  final TextEditingController _pesoController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();

  // Controladores de historial médico inicial
  final TextEditingController _diagnosticoController = TextEditingController();
  final TextEditingController _tratamientoController = TextEditingController();
  final TextEditingController _notasController = TextEditingController();

  // Estado
  DateTime? _fechaNacimiento;
  String? _sexo;
  Usuario? _propietarioSeleccionado;

  // Listas de la API
  List<
    Usuario
  >
  _usuarios = [];
  List<
    Vacuna
  >
  _vacunasDisponibles = [];
  List<
    Alergia
  >
  _alergiasDisponibles = [];

  // Selecciones
  Set<
    int
  >
  _vacunasSeleccionadas = {};
  Map<
    int,
    String
  >
  _lotesVacunas = {}; // vacunaId -> lote
  Map<
    int,
    DateTime
  >
  _fechasVacunas = {}; // vacunaId -> fecha
  Set<
    int
  >
  _alergiasSeleccionadas = {};
  Map<
    int,
    String
  >
  _notasAlergias = {}; // alergiaId -> notas

  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<
    void
  >
  _cargarDatos() async {
    setState(
      () => _isLoading = true,
    );
    try {
      final usuarios = await _apiService.getUsuarios();
      final vacunas = await _apiService.getVacunas();
      final alergias = await _apiService.getAlergias();

      setState(
        () {
          _usuarios = usuarios;
          _vacunasDisponibles = vacunas;
          _alergiasDisponibles = alergias;
          _isLoading = false;
        },
      );
    } catch (
      e
    ) {
      setState(
        () => _isLoading = false,
      );
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(
          SnackBar(
            content: Text(
              'Error al cargar datos: $e',
            ),
          ),
        );
      }
    }
  }

  Future<
    void
  >
  _seleccionarFecha() async {
    final fecha = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(
        2000,
      ),
      lastDate: DateTime.now(),
    );

    if (fecha !=
        null) {
      setState(
        () => _fechaNacimiento = fecha,
      );
    }
  }

  Future<
    void
  >
  _guardarPaciente() async {
    if (!_formKey.currentState!.validate()) return;

    if (_propietarioSeleccionado ==
        null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        const SnackBar(
          content: Text(
            'Debe seleccionar un propietario',
          ),
        ),
      );
      return;
    }

    if (_fechaNacimiento ==
        null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        const SnackBar(
          content: Text(
            'Debe seleccionar la fecha de nacimiento',
          ),
        ),
      );
      return;
    }

    setState(
      () => _isSaving = true,
    );

    try {
      // 1. Crear observaciones con la información adicional
      final observacionesList =
          <
            String
          >[];
      if (_sexo !=
          null) {
        observacionesList.add(
          'Sexo: $_sexo',
        );
      }
      if (_pesoController.text.isNotEmpty) {
        observacionesList.add(
          'Peso: ${_pesoController.text} kg',
        );
      }
      if (_colorController.text.isNotEmpty) {
        observacionesList.add(
          'Color: ${_colorController.text}',
        );
      }

      final observaciones = observacionesList.isEmpty
          ? null
          : observacionesList.join(
              ' | ',
            );

      // 2. Crear mascota
      final nuevaMascota = Mascota(
        nombre: _nombreController.text.trim(),
        especie: _especieController.text.trim(),
        raza: _razaController.text.trim(),
        fechaNacimiento: _fechaNacimiento!,
        fotoUrl: null,
        observaciones: observaciones,
        usuarioId: _propietarioSeleccionado!.usuarioId!,
      );

      print(
        'Intentando crear mascota: ${nuevaMascota.toJson()}',
      );

      final mascotaCreada = await _apiService.createMascota(
        nuevaMascota,
      );

      print(
        'Mascota creada exitosamente con ID: ${mascotaCreada.mascotaId}',
      );

      // 3. Recargar lista de mascotas
      await context
          .read<
            MascotaProvider
          >()
          .loadMascotas();

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        const SnackBar(
          content: Text(
            'Paciente registrado exitosamente',
          ),
        ),
      );

      context.pop();
    } catch (
      e
    ) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(
          SnackBar(
            content: Text(
              'Error al guardar: $e',
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(
          () => _isSaving = false,
        );
      }
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _especieController.dispose();
    _razaController.dispose();
    _pesoController.dispose();
    _colorController.dispose();
    _diagnosticoController.dispose();
    _tratamientoController.dispose();
    _notasController.dispose();
    super.dispose();
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
        title: const Text(
          'Nuevo Paciente',
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(
                  16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Foto de la mascota (por implementar)
                    Center(
                      child: Column(
                        children: [
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              color: AppColors.primary20,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.pets,
                              size: 50,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            'Foto del paciente',
                            style: TextStyle(
                              color: AppColors.slate500Light,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(
                      height: 24,
                    ),

                    // SECCIÓN: Datos del Propietario
                    _buildSectionTitle(
                      'Propietario',
                    ),
                    _buildPropietarioSelector(),

                    const SizedBox(
                      height: 24,
                    ),

                    // SECCIÓN: Datos de la Mascota
                    _buildSectionTitle(
                      'Datos de la Mascota',
                    ),
                    _buildTextField(
                      controller: _nombreController,
                      label: 'Nombre *',
                      validator:
                          (
                            v,
                          ) =>
                              v?.isEmpty ??
                                  true
                              ? 'Campo requerido'
                              : null,
                    ),
                    const SizedBox(
                      height: 16,
                    ),

                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            controller: _especieController,
                            label: 'Especie *',
                            validator:
                                (
                                  v,
                                ) =>
                                    v?.isEmpty ??
                                        true
                                    ? 'Campo requerido'
                                    : null,
                          ),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        Expanded(
                          child: _buildTextField(
                            controller: _razaController,
                            label: 'Raza *',
                            validator:
                                (
                                  v,
                                ) =>
                                    v?.isEmpty ??
                                        true
                                    ? 'Campo requerido'
                                    : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),

                    InkWell(
                      onTap: _seleccionarFecha,
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Fecha de Nacimiento *',
                          filled: true,
                          fillColor: AppColors.slate50Light,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              8,
                            ),
                            borderSide: BorderSide(
                              color: AppColors.slateBorder,
                            ),
                          ),
                          suffixIcon: const Icon(
                            Icons.calendar_today,
                          ),
                        ),
                        child: Text(
                          _fechaNacimiento !=
                                  null
                              ? '${_fechaNacimiento!.day.toString().padLeft(2, '0')}/${_fechaNacimiento!.month.toString().padLeft(2, '0')}/${_fechaNacimiento!.year}'
                              : 'Seleccionar fecha',
                          style: TextStyle(
                            color:
                                _fechaNacimiento !=
                                    null
                                ? AppColors.textLight
                                : AppColors.slate400Light,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),

                    DropdownButtonFormField<
                      String
                    >(
                      value: _sexo,
                      decoration: InputDecoration(
                        labelText: 'Sexo *',
                        filled: true,
                        fillColor: AppColors.slate50Light,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            8,
                          ),
                          borderSide: BorderSide(
                            color: AppColors.slateBorder,
                          ),
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'Macho',
                          child: Text(
                            'Macho',
                          ),
                        ),
                        DropdownMenuItem(
                          value: 'Hembra',
                          child: Text(
                            'Hembra',
                          ),
                        ),
                        DropdownMenuItem(
                          value: 'Desconocido',
                          child: Text(
                            'Desconocido',
                          ),
                        ),
                      ],
                      onChanged:
                          (
                            value,
                          ) => setState(
                            () => _sexo = value,
                          ),
                      validator:
                          (
                            v,
                          ) =>
                              v ==
                                  null
                              ? 'Campo requerido'
                              : null,
                    ),
                    const SizedBox(
                      height: 16,
                    ),

                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            controller: _pesoController,
                            label: 'Peso (kg)',
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        Expanded(
                          child: _buildTextField(
                            controller: _colorController,
                            label: 'Color',
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 24,
                    ),

                    // SECCIÓN: Vacunas
                    _buildSectionTitle(
                      'Vacunas Aplicadas',
                    ),
                    _buildVacunasSection(),

                    const SizedBox(
                      height: 24,
                    ),

                    // SECCIÓN: Alergias
                    _buildSectionTitle(
                      'Alergias',
                    ),
                    _buildAlergiasSection(),

                    const SizedBox(
                      height: 24,
                    ),

                    // SECCIÓN: Historial Médico Inicial
                    _buildSectionTitle(
                      'Historial Médico Inicial (Opcional)',
                    ),
                    _buildTextField(
                      controller: _diagnosticoController,
                      label: 'Diagnóstico',
                      maxLines: 3,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    _buildTextField(
                      controller: _tratamientoController,
                      label: 'Tratamiento',
                      maxLines: 3,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    _buildTextField(
                      controller: _notasController,
                      label: 'Notas adicionales',
                      maxLines: 2,
                    ),

                    const SizedBox(
                      height: 32,
                    ),

                    // Botón Guardar
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isSaving
                            ? null
                            : _guardarPaciente,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              12,
                            ),
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
                                'Guardar Paciente',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(
                      height: 100,
                    ),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: const VetNavbar(
        currentRoute: '/lista_pacientes',
      ),
    );
  }

  Widget _buildSectionTitle(
    String title,
  ) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 12,
      ),
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
    String? Function(
      String?,
    )?
    validator,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: AppColors.slate50Light,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            8,
          ),
          borderSide: BorderSide(
            color: AppColors.slateBorder,
          ),
        ),
      ),
      validator: validator,
      keyboardType: keyboardType,
      maxLines: maxLines,
    );
  }

  Widget _buildPropietarioSelector() {
    return Column(
      children: [
        DropdownButtonFormField<
          Usuario
        >(
          value: _propietarioSeleccionado,
          decoration: InputDecoration(
            labelText: 'Seleccionar Propietario *',
            filled: true,
            fillColor: AppColors.slate50Light,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                8,
              ),
              borderSide: BorderSide(
                color: AppColors.slateBorder,
              ),
            ),
          ),
          items: _usuarios.map(
            (
              usuario,
            ) {
              return DropdownMenuItem(
                value: usuario,
                child: Text(
                  usuario.nombreCompleto,
                ),
              );
            },
          ).toList(),
          onChanged:
              (
                value,
              ) => setState(
                () => _propietarioSeleccionado = value,
              ),
          validator:
              (
                v,
              ) =>
                  v ==
                      null
                  ? 'Debe seleccionar un propietario'
                  : null,
        ),
        if (_propietarioSeleccionado !=
            null) ...[
          const SizedBox(
            height: 12,
          ),
          Container(
            padding: const EdgeInsets.all(
              12,
            ),
            decoration: BoxDecoration(
              color: AppColors.primary20,
              borderRadius: BorderRadius.circular(
                8,
              ),
              border: Border.all(
                color: AppColors.primary.withOpacity(
                  0.3,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.person,
                      size: 16,
                      color: AppColors.primary,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: Text(
                        _propietarioSeleccionado!.nombreCompleto,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 4,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.email,
                      size: 14,
                      color: AppColors.slate500Light,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Text(
                      _propietarioSeleccionado!.email,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.slate600Light,
                      ),
                    ),
                  ],
                ),
                ...[
                  const SizedBox(
                    height: 4,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.phone,
                        size: 14,
                        color: AppColors.slate500Light,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(
                        _propietarioSeleccionado!.telefono,
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.slate600Light,
                        ),
                      ),
                    ],
                  ),
                ],
                ...[
                  const SizedBox(
                    height: 4,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 14,
                        color: AppColors.slate500Light,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: Text(
                          _propietarioSeleccionado!.direccion,
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.slate600Light,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildVacunasSection() {
    if (_vacunasDisponibles.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(
          16,
        ),
        child: Center(
          child: Text(
            'No hay vacunas registradas en el sistema',
          ),
        ),
      );
    }

    return Column(
      children: _vacunasDisponibles.map(
        (
          vacuna,
        ) {
          final isSelected = _vacunasSeleccionadas.contains(
            vacuna.vacunaId,
          );
          return Card(
            margin: const EdgeInsets.only(
              bottom: 8,
            ),
            child: Column(
              children: [
                CheckboxListTile(
                  value: isSelected,
                  onChanged:
                      (
                        value,
                      ) {
                        setState(
                          () {
                            if (value ==
                                true) {
                              _vacunasSeleccionadas.add(
                                vacuna.vacunaId!,
                              );
                              _fechasVacunas[vacuna.vacunaId!] = DateTime.now();
                            } else {
                              _vacunasSeleccionadas.remove(
                                vacuna.vacunaId,
                              );
                              _lotesVacunas.remove(
                                vacuna.vacunaId,
                              );
                              _fechasVacunas.remove(
                                vacuna.vacunaId,
                              );
                            }
                          },
                        );
                      },
                  title: Text(
                    vacuna.nombre,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    vacuna.descripcion,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.slate500Light,
                    ),
                  ),
                  activeColor: AppColors.primary,
                ),
                if (isSelected)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      16,
                      0,
                      16,
                      12,
                    ),
                    child: Column(
                      children: [
                        TextField(
                          decoration: InputDecoration(
                            labelText: 'Lote',
                            isDense: true,
                            filled: true,
                            fillColor: AppColors.slate50Light,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                8,
                              ),
                            ),
                          ),
                          onChanged:
                              (
                                value,
                              ) => _lotesVacunas[vacuna.vacunaId!] = value,
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        InkWell(
                          onTap: () async {
                            final fecha = await showDatePicker(
                              context: context,
                              initialDate:
                                  _fechasVacunas[vacuna.vacunaId] ??
                                  DateTime.now(),
                              firstDate: DateTime(
                                2000,
                              ),
                              lastDate: DateTime.now(),
                            );
                            if (fecha !=
                                null) {
                              setState(
                                () => _fechasVacunas[vacuna.vacunaId!] = fecha,
                              );
                            }
                          },
                          child: InputDecorator(
                            decoration: InputDecoration(
                              labelText: 'Fecha de aplicación',
                              isDense: true,
                              filled: true,
                              fillColor: AppColors.slate50Light,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  8,
                                ),
                              ),
                              suffixIcon: const Icon(
                                Icons.calendar_today,
                                size: 18,
                              ),
                            ),
                            child: Text(
                              '${_fechasVacunas[vacuna.vacunaId]!.day.toString().padLeft(2, '0')}/${_fechasVacunas[vacuna.vacunaId]!.month.toString().padLeft(2, '0')}/${_fechasVacunas[vacuna.vacunaId]!.year}',
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          );
        },
      ).toList(),
    );
  }

  Widget _buildAlergiasSection() {
    if (_alergiasDisponibles.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(
          16,
        ),
        child: Center(
          child: Text(
            'No hay alergias registradas en el sistema',
          ),
        ),
      );
    }

    return Column(
      children: _alergiasDisponibles.map(
        (
          alergia,
        ) {
          final isSelected = _alergiasSeleccionadas.contains(
            alergia.alergiaId,
          );
          return Card(
            margin: const EdgeInsets.only(
              bottom: 8,
            ),
            child: Column(
              children: [
                CheckboxListTile(
                  value: isSelected,
                  onChanged:
                      (
                        value,
                      ) {
                        setState(
                          () {
                            if (value ==
                                true) {
                              _alergiasSeleccionadas.add(
                                alergia.alergiaId!,
                              );
                            } else {
                              _alergiasSeleccionadas.remove(
                                alergia.alergiaId,
                              );
                              _notasAlergias.remove(
                                alergia.alergiaId,
                              );
                            }
                          },
                        );
                      },
                  title: Text(
                    alergia.nombre,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    'Tipo: ${alergia.tipo}',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.slate500Light,
                    ),
                  ),
                  activeColor: AppColors.primary,
                ),
                if (isSelected)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      16,
                      0,
                      16,
                      12,
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'Notas adicionales',
                        isDense: true,
                        filled: true,
                        fillColor: AppColors.slate50Light,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            8,
                          ),
                        ),
                      ),
                      maxLines: 2,
                      onChanged:
                          (
                            value,
                          ) => _notasAlergias[alergia.alergiaId!] = value,
                    ),
                  ),
              ],
            ),
          );
        },
      ).toList(),
    );
  }
}
