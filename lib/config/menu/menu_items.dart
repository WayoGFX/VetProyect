import 'package:flutter/material.dart';
// Menu de widgets

// esta lista es para mostrar los widgets que tenemos

class MenuItems {
  final String title;
  final IconData icon;
  final String link;
  final String description;

  const MenuItems({
    required this.title,
    required this.icon,
    required this.link,
    required this.description,
  });
}

const appMenuItems =
    <
      MenuItems
    >[
      MenuItems(
        title: 'Inicio Veterinario',
        icon: Icons.home,
        link: '/login_vet',
        description: 'pantalla de inicio proceso para veterinario',
      ),
      MenuItems(
        title: 'Inicio Usuario',
        icon: Icons.home,
        link: '/login_usuario',
        description: 'pantalla de inicio proceso para usuario',
      ),
      MenuItems(
        title: 'PantallaError',
        icon: Icons.error,
        link: '/pantalla_error',
        description: 'pantalla de Error',
      ),
      MenuItems(
        title: 'Menu Usuario',
        icon: Icons.menu_outlined,
        link: '/menu_usuario',
        description: 'pantalla de menu principal de usuario',
      ),
      MenuItems(
        title: 'Menu Veterinario',
        icon: Icons.menu_outlined,
        link: '/menu_veterinario',
        description: 'pantalla de menu principal de veterinario',
      ),
      MenuItems(
        title: 'Chatbot',
        icon: Icons.support_agent,
        link: '/chat',
        description: 'pantalla de chat con la veterinaria',
      ),
      MenuItems(
        title: 'Agenda de Citas',
        icon: Icons.assignment_turned_in_sharp,
        link: '/agenda_citas',
        description: 'pantalla de Agenda de citas',
      ),
      MenuItems(
        title: 'Ficha de paciente',
        icon: Icons.file_copy_sharp,
        link: '/ficha_paciente',
        description: 'pantalla de Ficha de paciente',
      ),

      MenuItems(
        title: 'Inicio Veterinario',
        icon: Icons.home,
        link: '/citas_del_dia',
        description: 'pantalla que muestra pantalla de inicio veterinario',
      ),
      MenuItems(
        title: 'Perfil del usuario',
        icon: Icons.person_4,
        link: '/perfil_usuarios',
        description: 'pantalla para el perfil del usuario',
      ),
      MenuItems(
        title: 'Mis mascotas',
        icon: Icons.pets,
        link: '/mis_mascotas',
        description: 'pantalla para mirar mis mascotas registradas',
      ),
      MenuItems(
        title: 'Perfil de la mascota',
        icon: Icons.pets_rounded,
        link: '/perfil_mascota',
        description: 'pantalla del perfil de la mascota',
      ),

      MenuItems(
        title: 'ListaPacientes',
        icon: Icons.list_sharp,
        link: '/lista_pacientes',
        description: 'pantalla de Lista de pacientes',
      ),
      MenuItems(
        title: 'NuevoPaciente',
        icon: Icons.person_add_alt_1,
        link: '/nuevo_paciente',
        description: 'pantalla de Nuevo paciente',
      ),
      MenuItems(
        title: 'Crear cita',
        icon: Icons.credit_score_sharp,
        link: '/crear_cita',
        description: 'pantalla de crear cita ',
      ),
      MenuItems(
        title: 'EditarCita',
        icon: Icons.edit,
        link: '/gesture_editar',
        description: 'pantalla de Editar cita',
      ),
      MenuItems(
        title: 'Agenda de Citas para veterinario',
        icon: Icons.assignment_turned_in_sharp,
        link: '/agenda_citas_veterinario',
        description: 'pantalla de Agenda de citas',
      ),
      MenuItems(
        title: 'Iniciar Sesión',
        icon: Icons.login,
        link: '/login_usuario',
        description: 'Iniciar sesion usuario',
      ),
      MenuItems(
        title: 'Registrar usuario',
        icon: Icons.app_registration_outlined,
        link: '/register_usuario',
        description: 'register de usuario',
      ),
      MenuItems(
        title: 'Iniciar Sesión Vet',
        icon: Icons.login,
        link: '/login_vet',
        description: 'Iniciar sesion vet',
      ),
      MenuItems(
        title: 'Registrar Vet',
        icon: Icons.app_registration_outlined,
        link: '/register_vet',
        description: 'register de vet',
      ),
      MenuItems(
        title: 'dashboard',
        icon: Icons.dashboard_rounded,
        link: '/dashboard',
        description: 'dashboard',
      ),
      MenuItems(
        title: 'perfil Veterinario',
        icon: Icons.person_4,
        link: '/perfil_veterinarios',
        description: 'pantalla para el perfil del veterinario',
      ),
      MenuItems(
        title: 'Cita Detalles Veterinario',
        icon: Icons.date_range_outlined,
        link: '/cita_detalles_veterinario',
        description: 'cita detalles veterinario',
      ),
      MenuItems(
        title: 'Cita Detalles Usuario',
        icon: Icons.date_range_outlined,
        link: '/cita_detalles_usuario',
        description: 'cita detalles usuario',
      ),
      MenuItems(
        title: 'Cita Editar',
        icon: Icons.edit,
        link: '/cita_editar',
        description: 'cita editar',
      ),
    ];
