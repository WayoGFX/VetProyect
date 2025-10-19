import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Importa la paleta de colores de la aplicación
import 'package:vet_smart_ids/core/app_colors.dart';
import 'package:vet_smart_ids/presentation/veterinario/navbar/navbar_veterinario.dart';

// Pantalla principal del menú de usuario
class VetMainMenuScreen
    extends
        StatelessWidget {
  // Nombre de la ruta estático, usado por GoRouter.
  static const String name = 'VetMainMenuScreen';
  const VetMainMenuScreen({
    super.key,
  });

  // Lista de objetos MenuItemData que definen las opciones del menú
  final List<
    MenuItemData
  >
  menuItems = const [
    MenuItemData(
      title: 'Citas del día ',
      subtitle: 'Accede al información general de la veterinaria',
      icon: Icons.folder_shared,
      route: '/citas_del_dia',
    ),
    MenuItemData(
      title: 'Dashboard',
      subtitle: 'Conoce la información de la veterinaria',
      icon: Icons.dashboard,
      route: '/dashboard',
    ),
    MenuItemData(
      title: 'Perfil Veterinario',
      subtitle: 'Administra tu perfil',
      icon: Icons.person,
      route: '/perfil_veterinarios',
    ),
    MenuItemData(
      title: 'Nuevo paciente',
      subtitle: 'Agregar nuevo paciente',
      icon: Icons.person_add_alt_1,
      route: '/nuevo_paciente',
    ),
    MenuItemData(
      title: 'Nueva cita',
      subtitle: 'Administra tu perfil',
      icon: Icons.assignment_add,
      route: '/crear_cita',
    ),
    MenuItemData(
      title: 'Agenda citas',
      subtitle: 'Agenda de citas',
      icon: Icons.assignment_turned_in_sharp,
      route: '/agenda_citas_veterinario',
    ),
    MenuItemData(
      title: 'Lista de pacientes',
      subtitle: 'Ver los pacientes filtrados',
      icon: Icons.supervised_user_circle_rounded,
      route: '/lista_pacientes',
    ),
    MenuItemData(
      title: 'ERROR',
      subtitle: 'Esto es para demostrar que sirven los manejos de errores',
      icon: Icons.error,
      route: '/ruta_para_sacar_10',
    ),
  ];

  @override
  Widget build(
    BuildContext context,
  ) {
    // Obtenemos el esquema de color (ColorScheme) del tema actual para colores dinámicos
    final ColorScheme colorScheme = Theme.of(
      context,
    ).colorScheme;

    return Scaffold(
      // ponemos el appbar
      appBar: AppBar(
        // Deshabilita la flecha de ir atrás automática, porque que es la pantalla principal.
        automaticallyImplyLeading: false,
        // Título central.
        title: const Text(
          'VetSmart',
        ),
        centerTitle: true,
        // Botones de acción a la derecha, solo tiene el botón de notificaciones pero de momento solo maquetado
        actions: const [
          _NotificationButton(),
        ],
      ),

      // Contenido principal
      body: SingleChildScrollView(
        // Agrega un padding de 16.0 a todo
        padding: const EdgeInsets.all(
          16.0,
        ),
        child: Column(
          // Alinea el contenido a la izquierda
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título principal del menu
            Text(
              'Menú Veterinario',
              style:
                  // diseño para el titulo.
                  Theme.of(
                    context,
                  ).textTheme.headlineMedium?.copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                    // Usa el color de texto definido en el ColorScheme
                    color: colorScheme.onSurface,
                  ),
            ),
            // Espacio vertical de 24.0
            const SizedBox(
              height: 24,
            ),
            // Mapea la lista de datos a widgets de elementos de menú
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: menuItems
                  .map(
                    (
                      item,
                    ) => Padding(
                      // Espacio de 16.0 debajo de cada elemento de la lista
                      padding: const EdgeInsets.only(
                        bottom: 16.0,
                      ),
                      child: _MenuListItem(
                        data: item, // Pasa los datos de la opción al widget de forma pro
                      ),
                    ),
                  )
                  .toList(), // Convierte el resultado del mapeo de nuevo a una lista de widgets
            ),
          ],
        ),
      ),
      // navbar
      bottomNavigationBar: const VetNavbar(
        // Le pasamos la ruta estática para que el navbar resalte el ícono "Inicio".
        currentRoute: '/menu_veterinario',
      ),
    );
  }
}

// Componentes Reutilizables

// Widget para el botón de notificaciones
class _NotificationButton
    extends
        StatelessWidget {
  const _NotificationButton();

  @override
  Widget build(
    BuildContext context,
  ) {
    return Container(
      width: 48, // para  el ancho del contenedor
      height: 48, // para el alto del contenedor
      margin: const EdgeInsets.only(
        right: 8.0,
      ),
      child: Material(
        // Usa Material para dar un fondo y permitir la interacción InkWell
        color: Theme.of(
          context,
          // Usa el color primario del tema
        ).colorScheme.primary,
        borderRadius: BorderRadius.circular(
          24,
        ), // Hace el contenedor circular
        child: InkWell(
          onTap: () {
            // Lógica para cuando se toca el botón.
          },
          borderRadius: BorderRadius.circular(
            24,
          ),
          child: Icon(
            Icons.notifications,
            color: Theme.of(
              context,
            ).colorScheme.onSurface,
            size: 28,
          ),
        ),
      ),
    );
  }
}

// Clase de modelo de datos para un elemento individual del menú.
class MenuItemData {
  final String title;
  final String subtitle;
  final IconData icon;
  final String route;

  // Constructor .
  const MenuItemData({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.route,
  });
}

// Widget para un elemento de la lista principal del menú
class _MenuListItem
    extends
        StatelessWidget {
  final MenuItemData data;

  const _MenuListItem({
    required this.data,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    // Usa Card para obtener la elevación y el fondo del tema
    return Card(
      child: InkWell(
        onTap: () {
          // Usa GoRouter para navegar
          GoRouter.of(
            context,
          ).push(
            data.route,
          );
        },
        // diseño
        borderRadius: BorderRadius.circular(
          16.0,
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              8.0,
            ),
            border: Border.all(
              color: AppColors.black.withOpacity(
                0.05,
              ),
            ),
          ),
          padding: const EdgeInsets.all(
            16.0,
          ),
          child: Row(
            children: [
              // Icono con fondo.
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  // Fondo con el color primario
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(
                    8.0,
                  ), // Borde redondeado
                ),
                child: Icon(
                  // Muestra el ícono específico de este elemento del menú
                  data.icon,
                  color: AppColors.black, // Color del ícono
                  size: 28,
                ),
              ),

              // Espacio horizontal entre el ícono y el texto
              const SizedBox(
                width: 16,
              ),
              // Columna que contiene el título y el subtítulo
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Título del menú
                    Text(
                      data.title,
                      style: Theme.of(
                        context,
                      ).textTheme.titleMedium,
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    // Subtítulo
                    Text(
                      data.subtitle,
                      style:
                          Theme.of(
                            context,
                          ).textTheme.bodySmall?.copyWith(
                            fontSize: 12,

                            color: AppColors.black60,
                          ),
                    ),
                  ],
                ),
              ),

              // Flecha de navegación a la derecha.
              Icon(
                Icons.chevron_right,
                // Color de la flecha semitransparente (text-black/40).
                color: AppColors.black40,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
