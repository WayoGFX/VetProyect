import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:vet_smart_ids/core/app_colors.dart';
import 'package:vet_smart_ids/presentation/veterinario/navbar/navbar_veterinario.dart';
import 'package:vet_smart_ids/providers/cita_provider.dart';
import 'package:vet_smart_ids/models/cita.dart';

class GestureEditar
    extends
        StatefulWidget {
  const GestureEditar({
    Key? key,
  }) : super(
         key: key,
       );
  static const String name = "gesture_editar";

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
  final _formKey =
      GlobalKey<
        FormState
      >();
  final TextEditingController _motivoController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _notasController = TextEditingController();

  DateTime? _fechaSeleccionada;
  TimeOfDay? _horaSeleccionada;
  String _estadoSeleccionado = 'Pendiente';

  bool _isLoading = false;

  // Estados disponibles con íconos y colores
  final List<
    Map<
      String,
      dynamic
    >
  >
  _estados = [
    {
      'nombre': 'Pendiente',
      'icono': Icons.schedule,
      'color': Colors.orange,
    },
    {
      'nombre': 'Realizada',
      'icono': Icons.check_circle,
      'color': Colors.green,
    },
    {
      'nombre': 'Cancelada',
      'icono': Icons.cancel,
      'color': Colors.red,
    },
  ];

  @override
  void initState() {
    super.initState();
    // Cargar datos de la cita seleccionada
    WidgetsBinding.instance.addPostFrameCallback(
      (
        _,
      ) {
        final cita = context
            .read<
              CitaProvider
            >()
            .citaSeleccionada;
        if (cita !=
            null) {
          setState(
            () {
              _fechaSeleccionada = cita.fechaHora;
              _horaSeleccionada = TimeOfDay.fromDateTime(
                cita.fechaHora,
              );
              _motivoController.text = cita.motivo;
              _descripcionController.text =
                  cita.citaDescripcion ??
                  '';
              _notasController.text =
                  cita.notas ??
                  '';
              _estadoSeleccionado = cita.estado;
            },
          );
        }
      },
    );
  }

  @override
  void dispose() {
    _motivoController.dispose();
    _descripcionController.dispose();
    _notasController.dispose();
    super.dispose();
  }

  Future<
    void
  >
  _seleccionarFecha() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          _fechaSeleccionada ??
          DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(
        const Duration(
          days: 365,
        ),
      ),
    );
    if (picked !=
        null) {
      setState(
        () {
          _fechaSeleccionada = picked;
        },
      );
    }
  }

  Future<
    void
  >
  _seleccionarHora() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime:
          _horaSeleccionada ??
          TimeOfDay.now(),
    );
    if (picked !=
        null) {
      setState(
        () {
          _horaSeleccionada = picked;
        },
      );
    }
  }

  String _formatFecha(
    DateTime? fecha,
  ) {
    if (fecha ==
        null)
      return 'Seleccionar fecha';
    final meses = [
      '',
      'Ene',
      'Feb',
      'Mar',
      'Abr',
      'May',
      'Jun',
      'Jul',
      'Ago',
      'Sep',
      'Oct',
      'Nov',
      'Dic',
    ];
    final dias = [
      '',
      'Lun',
      'Mar',
      'Mié',
      'Jue',
      'Vie',
      'Sáb',
      'Dom',
    ];
    return '${dias[fecha.weekday]}, ${fecha.day} de ${meses[fecha.month]} de ${fecha.year}';
  }

  String _formatHora(
    TimeOfDay? hora,
  ) {
    if (hora ==
        null)
      return 'Seleccionar hora';
    final hour =
        hora.hourOfPeriod ==
            0
        ? 12
        : hora.hourOfPeriod;
    final minute = hora.minute.toString().padLeft(
      2,
      '0',
    );
    final period =
        hora.period ==
            DayPeriod.am
        ? 'AM'
        : 'PM';
    return '$hour:$minute $period';
  }

  Future<
    void
  >
  _guardarCambios() async {
    if (_formKey.currentState!.validate()) {
      if (_fechaSeleccionada ==
          null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(
          const SnackBar(
            content: Text(
              'Por favor selecciona una fecha',
            ),
          ),
        );
        return;
      }
      if (_horaSeleccionada ==
          null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(
          const SnackBar(
            content: Text(
              'Por favor selecciona una hora',
            ),
          ),
        );
        return;
      }

      setState(
        () => _isLoading = true,
      );

      final citaProvider = context
          .read<
            CitaProvider
          >();
      final citaActual = citaProvider.citaSeleccionada;

      if (citaActual ==
              null ||
          citaActual.citaId ==
              null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(
          const SnackBar(
            content: Text(
              'Error: No se encontró la cita a editar',
            ),
            backgroundColor: Colors.red,
          ),
        );
        setState(
          () => _isLoading = false,
        );
        return;
      }

      // Combinar fecha y hora
      final fechaHora = DateTime(
        _fechaSeleccionada!.year,
        _fechaSeleccionada!.month,
        _fechaSeleccionada!.day,
        _horaSeleccionada!.hour,
        _horaSeleccionada!.minute,
      );

      final citaActualizada = Cita(
        citaId: citaActual.citaId,
        mascotaId: citaActual.mascotaId,
        usuarioId: citaActual.usuarioId,
        veterinarioId: citaActual.veterinarioId,
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

      final success = await citaProvider.updateCita(
        citaActual.citaId!,
        citaActualizada,
      );

      setState(
        () => _isLoading = false,
      );

      if (!mounted) return;

      if (success) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(
          const SnackBar(
            content: Text(
              'Cita actualizada exitosamente',
            ),
            backgroundColor: Colors.green,
          ),
        );
        // Recargar las citas del día
        await citaProvider.loadCitasDelDia();
        if (mounted) context.pop();
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(
          SnackBar(
            content: Text(
              citaProvider.errorMessage ??
                  'Error al actualizar la cita',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final citaProvider = context
        .watch<
          CitaProvider
        >();
    final cita = citaProvider.citaSeleccionada;

    if (cita ==
        null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Editar Cita',
          ),
        ),
        body: const Center(
          child: Text(
            'No se encontró información de la cita',
          ),
        ),
      );
    }

    final isDark =
        Theme.of(
          context,
        ).brightness ==
        Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.textLight
          : AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: isDark
            ? AppColors.textLight.withValues(
                alpha: 0.8,
              )
            : AppColors.backgroundLight.withValues(
                alpha: 0.8,
              ),
        elevation: 0,
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
        title: Text(
          'Editar Cita',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDark
                ? AppColors.white
                : AppColors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(
          16,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Información de la mascota
              Container(
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
                          : AppColors.black05,
                      blurRadius: 10,
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(
                  24,
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 32,
                      backgroundColor: AppColors.primary20,
                      backgroundImage:
                          cita.mascotaFotoUrl !=
                                  null &&
                              cita.mascotaFotoUrl!.isNotEmpty
                          ? NetworkImage(
                              cita.mascotaFotoUrl!,
                            )
                          : null,
                      child:
                          cita.mascotaFotoUrl ==
                                  null ||
                              cita.mascotaFotoUrl!.isEmpty
                          ? Icon(
                              Icons.pets,
                              color: AppColors.primary,
                              size: 32,
                            )
                          : null,
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            cita.mascotaNombre ??
                                'Mascota',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: isDark
                                  ? AppColors.white
                                  : AppColors.textLight,
                            ),
                          ),
                          if (cita.usuarioNombre !=
                              null)
                            Text(
                              'Dueño: ${cita.usuarioNombre}',
                              style: TextStyle(
                                color: isDark
                                    ? AppColors.slate600Light.withValues(
                                        alpha: 0.7,
                                      )
                                    : AppColors.slate600Light,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 24,
              ),

              // Selector de Estado (Creativo)
              Text(
                'Estado de la Cita',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark
                      ? AppColors.white
                      : AppColors.textLight,
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: _estados.map(
                  (
                    estado,
                  ) {
                    final isSelected =
                        _estadoSeleccionado ==
                        estado['nombre'];
                    return InkWell(
                      onTap: () {
                        setState(
                          () {
                            _estadoSeleccionado = estado['nombre'];
                          },
                        );
                      },
                      borderRadius: BorderRadius.circular(
                        16,
                      ),
                      child: AnimatedContainer(
                        duration: const Duration(
                          milliseconds: 200,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? estado['color'].withValues(
                                  alpha: 0.15,
                                )
                              : (isDark
                                    ? AppColors.textLight
                                    : AppColors.cardLight),
                          borderRadius: BorderRadius.circular(
                            16,
                          ),
                          border: Border.all(
                            color: isSelected
                                ? estado['color']
                                : AppColors.slateBorder,
                            width: isSelected
                                ? 2.5
                                : 1.5,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: estado['color'].withValues(
                                      alpha: 0.3,
                                    ),
                                    blurRadius: 8,
                                    offset: const Offset(
                                      0,
                                      2,
                                    ),
                                  ),
                                ]
                              : [],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              estado['icono'],
                              color: isSelected
                                  ? estado['color']
                                  : (isDark
                                        ? AppColors.white
                                        : AppColors.slate600Light),
                              size: 20,
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Text(
                              estado['nombre'],
                              style: TextStyle(
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.w600,
                                color: isSelected
                                    ? estado['color']
                                    : (isDark
                                          ? AppColors.white
                                          : AppColors.textLight),
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ).toList(),
              ),
              const SizedBox(
                height: 24,
              ),

              // Campo: Fecha
              InkWell(
                onTap: _seleccionarFecha,
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Fecha',
                    prefixIcon: const Icon(
                      Icons.calendar_month,
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
                  child: Text(
                    _formatFecha(
                      _fechaSeleccionada,
                    ),
                    style: TextStyle(
                      fontSize: 16,
                      color:
                          _fechaSeleccionada ==
                              null
                          ? AppColors.slate500Light
                          : (isDark
                                ? AppColors.white
                                : AppColors.textLight),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),

              // Campo: Hora
              InkWell(
                onTap: _seleccionarHora,
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Hora',
                    prefixIcon: const Icon(
                      Icons.schedule,
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
                  child: Text(
                    _formatHora(
                      _horaSeleccionada,
                    ),
                    style: TextStyle(
                      fontSize: 16,
                      color:
                          _horaSeleccionada ==
                              null
                          ? AppColors.slate500Light
                          : (isDark
                                ? AppColors.white
                                : AppColors.textLight),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),

              // Campo: Motivo
              TextFormField(
                controller: _motivoController,
                decoration: InputDecoration(
                  labelText: 'Motivo de la consulta',
                  prefixIcon: const Icon(
                    Icons.medical_services,
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
                validator:
                    (
                      value,
                    ) {
                      if (value ==
                              null ||
                          value.trim().isEmpty) {
                        return 'Ingresa el motivo de la consulta';
                      }
                      return null;
                    },
              ),
              const SizedBox(
                height: 16,
              ),

              // Campo: Descripción
              TextFormField(
                controller: _descripcionController,
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: 'Descripción (opcional)',
                  prefixIcon: const Padding(
                    padding: EdgeInsets.only(
                      top: 12,
                    ),
                    child: Icon(
                      Icons.notes,
                    ),
                  ),
                  alignLabelWithHint: true,
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
              ),
              const SizedBox(
                height: 16,
              ),

              // Campo: Notas Adicionales
              TextFormField(
                controller: _notasController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'Notas Adicionales (opcional)',
                  prefixIcon: const Padding(
                    padding: EdgeInsets.only(
                      top: 12,
                    ),
                    child: Icon(
                      Icons.description,
                    ),
                  ),
                  alignLabelWithHint: true,
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
              ),
              const SizedBox(
                height: 24,
              ),

              // Botón Guardar Cambios
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : _guardarCambios,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.textLight,
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        16,
                      ),
                    ),
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
                      : const Text(
                          'Guardar Cambios',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                ),
              ),
              const SizedBox(
                height: 80,
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
