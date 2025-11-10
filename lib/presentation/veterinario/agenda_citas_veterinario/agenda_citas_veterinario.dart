import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:vet_smart_ids/core/app_colors.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:vet_smart_ids/presentation/veterinario/navbar/navbar_veterinario.dart';
import 'package:vet_smart_ids/providers/cita_provider.dart';
import 'package:vet_smart_ids/models/cita.dart';

class VetAppointmentScreen extends StatefulWidget {
  static const String name = 'agenda_citas_veterinario';
  const VetAppointmentScreen({super.key});

  @override
  State<VetAppointmentScreen> createState() => _VetAppointmentScreenState();
}

class _VetAppointmentScreenState extends State<VetAppointmentScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    // Cargar citas del mes actual al iniciar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCitasDelMes(_focusedDay);
    });
  }

  Future<void> _loadCitasDelMes(DateTime date) async {
    await context.read<CitaProvider>().loadCitasByMonth(date.year, date.month);
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });
    }
  }

  void _onPageChanged(DateTime focusedDay) {
    setState(() {
      _focusedDay = focusedDay;
    });
    // Cargar citas del nuevo mes
    _loadCitasDelMes(focusedDay);
  }

  @override
  Widget build(BuildContext context) {
    final citaProvider = context.watch<CitaProvider>();
    final citasDelDia = _selectedDay != null
        ? citaProvider.getCitasByDate(_selectedDay!)
        : <Cita>[];

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 56,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 24),
          onPressed: () => context.pop(),
          color: AppColors.textLight,
        ),
        title: const Text(
          'Agenda de Citas',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: const [SizedBox(width: 48)],
      ),
      body: citaProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Calendario
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.cardLight,
                        borderRadius: BorderRadius.circular(16.0),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.black05,
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(16.0),
                      child: TableCalendar(
                        firstDay: DateTime.utc(2020, 1, 1),
                        lastDay: DateTime.utc(2030, 12, 31),
                        focusedDay: _focusedDay,
                        calendarFormat: _calendarFormat,
                        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                        onDaySelected: _onDaySelected,
                        onPageChanged: _onPageChanged,
                        onFormatChanged: (format) {
                          setState(() {
                            _calendarFormat = format;
                          });
                        },
                        // Estilo del encabezado
                        headerStyle: HeaderStyle(
                          formatButtonVisible: false,
                          titleCentered: true,
                          titleTextStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: AppColors.textLight,
                          ),
                          leftChevronIcon: const Icon(
                            Icons.chevron_left,
                            size: 24,
                            color: AppColors.textLight,
                          ),
                          rightChevronIcon: const Icon(
                            Icons.chevron_right,
                            size: 24,
                            color: AppColors.textLight,
                          ),
                          headerMargin: const EdgeInsets.only(bottom: 16),
                        ),
                        // Estilo de los días de la semana
                        daysOfWeekStyle: DaysOfWeekStyle(
                          weekdayStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: AppColors.black.withValues(alpha: 0.5),
                          ),
                          weekendStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: AppColors.black.withValues(alpha: 0.5),
                          ),
                        ),
                        // Estilo de las celdas
                        calendarStyle: CalendarStyle(
                          selectedDecoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          selectedTextStyle: const TextStyle(
                            color: AppColors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          todayDecoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            shape: BoxShape.circle,
                          ),
                          todayTextStyle: const TextStyle(
                            color: AppColors.textLight,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          defaultTextStyle: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textLight,
                          ),
                          outsideDaysVisible: false,
                          // Resaltar días con citas
                          markerDecoration: BoxDecoration(
                            color: AppColors.secondary,
                            shape: BoxShape.circle,
                          ),
                        ),
                        // Marcadores para días con citas
                        calendarBuilders: CalendarBuilders(
                          markerBuilder: (context, date, events) {
                            if (citaProvider.hasCitasOnDay(date)) {
                              return Positioned(
                                bottom: 2,
                                child: Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: Colors.green.shade600,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.green.withValues(alpha: 0.4),
                                        blurRadius: 4,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ),
                    ),
                  ),

                  // Lista de citas del día seleccionado
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _selectedDay != null
                              ? _formatTituloDia(_selectedDay!)
                              : 'Citas del día',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Mostrar citas o mensaje vacío
                        if (citasDelDia.isEmpty)
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(32.0),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.event_busy,
                                    size: 64,
                                    color: AppColors.slate500Light,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'No hay citas para este día',
                                    style: TextStyle(
                                      color: AppColors.slate500Light,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        else
                          ...citasDelDia.map((cita) => Padding(
                                padding: const EdgeInsets.only(bottom: 12.0),
                                child: _CitaCard(cita: cita),
                              )),
                      ],
                    ),
                  ),

                  // Separador
                  if (citaProvider.citas.isNotEmpty) ...[
                    const SizedBox(height: 32),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Divider(
                        color: AppColors.slate500Light.withValues(alpha: 0.3),
                        thickness: 1,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Todas las citas del mes
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_month,
                                color: AppColors.primary,
                                size: 24,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _formatTituloMes(_focusedDay),
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Spacer(),
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
                                  '${citaProvider.citas.length} citas',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          ...citaProvider.citas.map((cita) => Padding(
                                padding: const EdgeInsets.only(bottom: 12.0),
                                child: _CitaCard(cita: cita),
                              )),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 80),
                ],
              ),
            ),
      // Botón flotante
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Container(
        height: 56,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: InkWell(
          onTap: () => context.push('/crear_cita'),
          borderRadius: BorderRadius.circular(28),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 24, 0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.add, color: AppColors.white, size: 24),
                const SizedBox(width: 8),
                Text(
                  'Nueva Cita',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const VetNavbar(
        currentRoute: '/agenda_citas_veterinario',
      ),
    );
  }

  String _formatTituloDia(DateTime date) {
    final ahora = DateTime.now();
    final hoy = DateTime(ahora.year, ahora.month, ahora.day);
    final fechaSeleccionada = DateTime(date.year, date.month, date.day);

    if (fechaSeleccionada.isAtSameMomentAs(hoy)) {
      return 'Citas de hoy';
    }

    final manana = hoy.add(const Duration(days: 1));
    if (fechaSeleccionada.isAtSameMomentAs(manana)) {
      return 'Citas de mañana';
    }

    final meses = [
      '',
      'Enero',
      'Febrero',
      'Marzo',
      'Abril',
      'Mayo',
      'Junio',
      'Julio',
      'Agosto',
      'Septiembre',
      'Octubre',
      'Noviembre',
      'Diciembre'
    ];
    final dias = ['', 'Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo'];

    return 'Citas del ${dias[date.weekday]}, ${date.day} de ${meses[date.month]}';
  }

  String _formatTituloMes(DateTime date) {
    final meses = [
      '',
      'Enero',
      'Febrero',
      'Marzo',
      'Abril',
      'Mayo',
      'Junio',
      'Julio',
      'Agosto',
      'Septiembre',
      'Octubre',
      'Noviembre',
      'Diciembre'
    ];

    return 'Todas las citas de ${meses[date.month]} ${date.year}';
  }
}

// Tarjeta de cita (similar a citas_del_dia)
class _CitaCard extends StatelessWidget {
  final Cita cita;

  const _CitaCard({required this.cita});

  @override
  Widget build(BuildContext context) {
    final titulo = cita.mascotaNombre != null
        ? '${cita.mascotaNombre} - ${cita.motivo}'
        : cita.motivo;

    return InkWell(
      onTap: () {
        context.read<CitaProvider>().selectCita(cita);
        context.push('/cita_detalles_veterinario');
      },
      borderRadius: BorderRadius.circular(12),
      child: Card(
        elevation: 1,
        margin: const EdgeInsets.only(bottom: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Foto de la mascota
              CircleAvatar(
                radius: 28,
                backgroundColor: AppColors.primary20,
                backgroundImage: cita.mascotaFotoUrl != null && cita.mascotaFotoUrl!.isNotEmpty
                    ? NetworkImage(cita.mascotaFotoUrl!)
                    : null,
                child: cita.mascotaFotoUrl == null || cita.mascotaFotoUrl!.isEmpty
                    ? Icon(Icons.pets, color: AppColors.primary, size: 28)
                    : null,
              ),
              const SizedBox(width: 16),
              // Información
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      titulo,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textLight,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatHora(cita.fechaHora),
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.slate500Light,
                      ),
                    ),
                    if (cita.veterinarioNombre != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        'Dr(a). ${cita.veterinarioNombre}',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.slate500Light,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              // Estado badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _getEstadoColor(cita.estado).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _getEstadoColor(cita.estado),
                    width: 1.5,
                  ),
                ),
                child: Text(
                  cita.estado,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: _getEstadoColor(cita.estado),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatHora(DateTime fecha) {
    final hour = fecha.hour;
    final minute = fecha.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final hour12 = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '$hour12:$minute $period';
  }

  Color _getEstadoColor(String estado) {
    switch (estado.toLowerCase()) {
      case 'completada':
      case 'realizada':
        return Colors.green;
      case 'cancelada':
        return Colors.red;
      case 'pendiente':
      default:
        return Colors.orange;
    }
  }
}
