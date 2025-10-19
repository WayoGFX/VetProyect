// lib/screens/appointment_screen.dart
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:vet_smart_ids/core/app_colors.dart';
import 'package:go_router/go_router.dart';
import 'package:vet_smart_ids/presentation/veterinario/navbar/navbar_veterinario.dart'; //GoRouter para la navegación

class VetAppointmentScreen
    extends
        StatefulWidget {
  static const String name = 'agenda_citas_veterinario';
  const VetAppointmentScreen({
    super.key,
  });

  @override
  State<
    VetAppointmentScreen
  >
  createState() => _AppointmentScreenState();
}

class _AppointmentScreenState
    extends
        State<
          VetAppointmentScreen
        > {
  // Estado del calendario
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  // Datos simulados de citas
  final List<
    CitaAgendada_dos
  >
  citasAgendadas = const [
    CitaAgendada_dos(
      title: 'Consulta general',
      time: '10:00 AM - 11:00 AM',
      icon: Icons.calendar_today,
    ),
    CitaAgendada_dos(
      title: 'Vacunación',
      time: '11:30 AM - 12:30 PM',
      icon: Icons.calendar_today,
    ),
    CitaAgendada_dos(
      title: 'Cirugía',
      time: '2:00 PM - 3:00 PM',
      icon: Icons.calendar_today,
    ),
    CitaAgendada_dos(
      title: 'Cirugía',
      time: '2:00 PM - 3:00 PM',
      icon: Icons.calendar_today,
    ),
    CitaAgendada_dos(
      title: 'Cirugía',
      time: '2:00 PM - 3:00 PM',
      icon: Icons.calendar_today,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  // Función de manejo de la selección de día
  void _onDaySelected(
    DateTime selectedDay,
    DateTime focusedDay,
  ) {
    if (!isSameDay(
      _selectedDay,
      selectedDay,
    )) {
      setState(
        () {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay; // Mantener el mes visible
        },
      );
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final ColorScheme colorScheme = Theme.of(
      context,
    ).colorScheme;
    final TextTheme textTheme = Theme.of(
      context,
    ).textTheme;

    return Scaffold(
      // Appbar
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 56,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            size: 24,
          ),
          onPressed: () => context.pop(),
          color: AppColors.textLight,
          style: ButtonStyle(
            overlayColor: WidgetStateProperty.all(
              AppColors.primary20,
            ),
          ),
        ),
        title: Text(
          'Citas',
          style: textTheme.titleMedium?.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: const [
          SizedBox(
            width: 48,
          ),
        ],
      ),

      // Contenido principal
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(
          bottom: 16.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Calendario (mx-auto max-w-sm rounded-xl p-4 shadow-sm)
            Padding(
              padding: const EdgeInsets.all(
                50.0,
              ), // p-4
              child: Container(
                constraints: const BoxConstraints(
                  maxWidth: 400,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(
                    12.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.black.withOpacity(
                        0.05,
                      ),
                      blurRadius: 4,
                      offset: const Offset(
                        0,
                        2,
                      ),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(
                  16.0,
                ),
                child: _CalendarWidget(
                  focusedDay: _focusedDay,
                  selectedDay: _selectedDay,
                  onDaySelected: _onDaySelected,
                  calendarFormat: _calendarFormat,
                  onFormatChanged:
                      (
                        format,
                      ) {
                        setState(
                          () {
                            _calendarFormat = format;
                          },
                        );
                      },
                ),
              ),
            ),

            // Lista de Citas
            Padding(
              padding: const EdgeInsets.only(
                left: 16.0,
                right: 16.0,
                top: 16.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título: Citas de la semana
                  Text(
                    'Citas de la semana',
                    style: textTheme.titleLarge?.copyWith(
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ), // mt-4
                  // Lista de tarjetas de citas
                  Column(
                    children: citasAgendadas
                        .map(
                          (
                            appointment,
                          ) => Padding(
                            padding: const EdgeInsets.only(
                              bottom: 12.0,
                            ), // space-y-3
                            child: _AppointmentCard(
                              data: appointment,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // 3. Botón Flotante
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: const _NewAppointmentButton(),
      // navbar
      bottomNavigationBar: const VetNavbar(
        // Le pasamos la ruta estática para que el navbar resalte el ícono
        currentRoute: '/agenda_citas',
      ),
    );
  }
}

// Componentes reutilizable

/// Widget del Calendario (Basado en TableCalendar)
class _CalendarWidget
    extends
        StatelessWidget {
  final DateTime focusedDay;
  final DateTime? selectedDay;
  final Function(
    DateTime,
    DateTime,
  )
  onDaySelected;
  final CalendarFormat calendarFormat;
  final Function(
    CalendarFormat,
  )
  onFormatChanged;

  const _CalendarWidget({
    required this.focusedDay,
    required this.selectedDay,
    required this.onDaySelected,
    required this.calendarFormat,
    required this.onFormatChanged,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    final colorScheme = Theme.of(
      context,
    ).colorScheme;

    return TableCalendar(
      firstDay: DateTime.utc(
        2020,
        1,
        1,
      ),
      lastDay: DateTime.utc(
        2030,
        12,
        31,
      ),
      focusedDay: focusedDay,
      calendarFormat: calendarFormat,
      selectedDayPredicate:
          (
            day,
          ) => isSameDay(
            selectedDay,
            day,
          ),
      onDaySelected: onDaySelected,
      onFormatChanged: onFormatChanged,

      // Personalización del encabezado (Mayo 2024, botones de flecha)
      headerStyle: HeaderStyle(
        formatButtonVisible: false, // Ocultar el botón de formato (Week/Month)
        titleCentered: true,
        titleTextStyle:
            Theme.of(
              context,
            ).textTheme.titleMedium!.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: AppColors.textLight, // text-contrast
            ),
        leftChevronIcon: Icon(
          Icons.chevron_left,
          size: 18,
          color: AppColors.textLight,
        ),
        rightChevronIcon: Icon(
          Icons.chevron_right,
          size: 18,
          color: AppColors.textLight,
        ),
        headerMargin: const EdgeInsets.only(
          bottom: 16,
        ), // mb-4
      ),

      // Personalización de los días de la semana
      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle:
            Theme.of(
              context,
            ).textTheme.bodySmall!.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 14, // text-sm
              color: AppColors.black.withOpacity(
                0.5,
              ), // text-contrast/50
            ),
        weekendStyle:
            Theme.of(
              context,
            ).textTheme.bodySmall!.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: AppColors.black.withOpacity(
                0.5,
              ),
            ),
      ),

      // Personalización de las celdas de los días
      calendarStyle: CalendarStyle(
        // Estilo del día seleccionado (Día 5, bg-primary text-white font-bold)
        selectedDecoration: BoxDecoration(
          color: colorScheme.primary,
          shape: BoxShape.circle,
        ),
        selectedTextStyle:
            Theme.of(
              context,
            ).textTheme.bodyMedium!.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
        // Estilo del día actual (opcional)
        todayDecoration: BoxDecoration(
          color: AppColors.primary.withOpacity(
            0.2,
          ),
          shape: BoxShape.circle,
        ),
        // Estilo de los otros días
        defaultTextStyle:
            Theme.of(
              context,
            ).textTheme.bodyMedium!.copyWith(
              fontSize: 14, // text-sm
              color: AppColors.textLight,
            ),
        outsideDaysVisible: false, // Ocultar días de otros meses
      ),

      // Constructor para el contenido de las celdas para aplicar el hover:bg-primary/20
      calendarBuilders: CalendarBuilders(
        defaultBuilder:
            (
              context,
              day,
              focusedDay,
            ) {
              // Envuelve el número del día en un InkWell para el efecto hover
              return Center(
                child: SizedBox(
                  height: 40, // h-10
                  width: 40, // w-10
                  child: Material(
                    color: Colors.transparent,
                    shape: const CircleBorder(),
                    child: InkWell(
                      onTap: () => onDaySelected(
                        day,
                        focusedDay,
                      ),
                      borderRadius: BorderRadius.circular(
                        20,
                      ),
                      hoverColor: AppColors.primary20,
                      child: Center(
                        child: Text(
                          '${day.day}',
                          style:
                              Theme.of(
                                context,
                              ).textTheme.bodyMedium!.copyWith(
                                fontSize: 14,
                                color: AppColors.textLight,
                              ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
        selectedBuilder:
            (
              context,
              day,
              focusedDay,
            ) {
              // Si es el día seleccionado, usa el estilo activo (Día 5)
              return Center(
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${day.day}',
                      style:
                          Theme.of(
                            context,
                          ).textTheme.bodyMedium!.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                    ),
                  ),
                ),
              );
            },
      ),
    );
  }
}

//Tarjeta de Cita
class CitaAgendada_dos {
  final String title;
  final String time;
  final IconData icon;

  const CitaAgendada_dos({
    required this.title,
    required this.time,
    required this.icon,
  });
}

class _AppointmentCard
    extends
        StatelessWidget {
  final CitaAgendada_dos data;
  const _AppointmentCard({
    required this.data,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    final colorScheme = Theme.of(
      context,
    ).colorScheme;
    final textTheme = Theme.of(
      context,
    ).textTheme;

    return InkWell(
      // InkWell PARA HACER TODA LA TARJETA CLICKABLEeeee
      onTap: () {
        // Redirigir a detalles de cita usando GoRouter
        context.push(
          '/cita_detalles_veterinario',
        );
      },
      splashColor: AppColors.primary.withOpacity(
        0.1,
      ),
      highlightColor: AppColors.primary.withOpacity(
        0.05,
      ),
      borderRadius: BorderRadius.circular(
        8.0,
      ),

      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(
            8.0,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(
                0.05,
              ), // shadow-sm
              blurRadius: 4,
              offset: const Offset(
                0,
                2,
              ),
            ),
          ],
        ),
        padding: const EdgeInsets.all(
          12.0,
        ), // p-3
        child: Row(
          children: [
            // Icono y Fondo
            Container(
              width: 48,
              height: 48,
              margin: const EdgeInsets.only(
                right: 16,
              ), // gap-4
              decoration: BoxDecoration(
                color: AppColors.primary20,
                borderRadius: BorderRadius.circular(
                  8.0,
                ),
              ),
              child: Icon(
                data.icon,
                color: colorScheme.primary,
                size: 24,
              ),
            ),

            // Texto
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Título
                Text(
                  data.title,
                  style: textTheme.bodyMedium!.copyWith(
                    fontWeight: FontWeight.w500, // font-medium
                    color: AppColors.textLight,
                  ),
                ),
                const SizedBox(
                  height: 2,
                ),
                // Subtítulo
                Text(
                  data.time,
                  style: textTheme.bodySmall!.copyWith(
                    fontSize: 14, // text-sm
                    color: AppColors.black60,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// botón Flotante de nueva cita
class _NewAppointmentButton
    extends
        StatelessWidget {
  const _NewAppointmentButton();

  @override
  Widget build(
    BuildContext context,
  ) {
    final colorScheme = Theme.of(
      context,
    ).colorScheme;

    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: colorScheme.primary, // bg-primary
        borderRadius: BorderRadius.circular(
          28,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(
              0.2,
            ),
            blurRadius: 10,
            offset: const Offset(
              0,
              4,
            ),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          context.push(
            '/crear_cita',
          );
        },
        borderRadius: BorderRadius.circular(
          28,
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            16,
            0,
            24,
            0,
          ), // pl-4 pr-6
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.add,
                color: AppColors.white,
                size: 24,
              ),
              const SizedBox(
                width: 8,
              ), // gap-2
              Text(
                'Nueva Cita',
                style:
                    Theme.of(
                      context,
                    ).textTheme.bodyMedium!.copyWith(
                      fontSize: 16, // text-base
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
