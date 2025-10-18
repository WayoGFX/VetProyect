import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vet_smart_ids/core/app_colors.dart';

class VetNavbar
    extends
        StatelessWidget {
  // Recibe la ruta actual para poder resaltar el ítem activo
  final String currentRoute;

  const VetNavbar({
    super.key,
    required this.currentRoute,
  });

  // Define los ítems del navbar
  final List<
    _NavItem
  >
  navItems = const [
    _NavItem(
      icon: Icons.home,
      label: 'Inicio',
      route: '/menu_veterinario',
    ),
    _NavItem(
      icon: Icons.pets,
      label: 'Mascotas',
      route: '/mis_mascotas',
    ),
    _NavItem(
      icon: Icons.medical_services,
      label: 'Historial',
      route: '/ficha_paciente',
    ),
    _NavItem(
      icon: Icons.calendar_month,
      label: 'Citas',
      route: '/agenda_citas',
    ),
    _NavItem(
      icon: Icons.chat_bubble,
      label: 'Chatbot',
      route: '/chat',
    ),
    _NavItem(
      icon: Icons.person,
      label: 'Perfil',
      route: '/perfil_usuario',
    ),
  ];

  @override
  Widget build(
    BuildContext context,
  ) {
    final colorScheme = Theme.of(
      context,
    ).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: AppColors.primary.withOpacity(
              0.2,
            ), // border-t border-primary/20
          ),
        ),
      ),
      padding: EdgeInsets.only(
        top: 8.0, // pt-2
        bottom:
            12.0 +
            MediaQuery.of(
              context,
            ).padding.bottom, // pb-3 + safe area bottom
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: navItems.map(
          (
            item,
          ) {
            final bool isSelected =
                item.route ==
                currentRoute;
            final Color iconColor = isSelected
                ? AppColors.primary
                : AppColors.slate500Light; // text-primary o text-gray-500

            return GestureDetector(
              onTap: () {
                // Navega a la ruta usando GoRouter
                context.go(
                  item.route,
                );
              },
              child: Column(
                mainAxisSize: MainAxisSize.min, // minimo vertical
                children: [
                  Icon(
                    item.icon,
                    color: iconColor,
                    size: 24,
                  ),
                  const SizedBox(
                    height: 4,
                  ), // gap-1
                  Text(
                    item.label,
                    style: TextStyle(
                      fontSize: 12, // text-xs
                      color: iconColor,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            );
          },
        ).toList(),
      ),
    );
  }
}

// Modelo de datos simple para cada ítem del navbar
class _NavItem {
  final IconData icon;
  final String label;
  final String route;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.route,
  });
}
