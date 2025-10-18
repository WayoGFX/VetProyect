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
        title: 'Menu Usuario',
        icon: Icons.home,
        link: '/menu_usuario',
        description: 'pantalla de menu principal de usuario',
      ),
      MenuItems(
        title: 'Menu Veterinario',
        icon: Icons.home,
        link: '/menu_veterinario',
        description: 'pantalla de menu principal de veterinario',
      ),
      MenuItems(
        title: 'Chatbot',
        icon: Icons.home,
        link: '/chat',
        description: 'pantalla de chat con la veterinaria',
      ),
      MenuItems(
        title: 'Agenda de Citas',
        icon: Icons.home,
        link: '/agenda_citas',
        description: 'pantalla de Agenda de citas',
      ),
      MenuItems(
        title: 'Ficha de paciente',
        icon: Icons.home,
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
        icon: Icons.home,
        link: '/perfil_usuarios',
        description: 'pantalla para el perfil del usuario',
      ),
      MenuItems(
        title: 'Mis mascotas',
        icon: Icons.home,
        link: '/mis_mascotas',
        description: 'pantalla para mirar mis mascotas registradas',
      ),
      MenuItems(
        title: 'Perfil de la mascota',
        icon: Icons.home,
        link: '/perfil_mascota',
        description: 'pantalla del perfil de la mascota',
      ),

      MenuItems(
        title: 'ListaPacientes',
        icon: Icons.home,
        link: '/lista_pacientes',
        description: 'pantalla de Lista de pacientes',
      ),
      MenuItems(
        title: 'NuevoPaciente',
        icon: Icons.home,
        link: '/nuevo_paciente',
        description: 'pantalla de Nuevo paciente',
      ),
      MenuItems(
        title: 'Crear cita',
        icon: Icons.home,
        link: '/crear_cita',
        description: 'pantalla de crear cita ',
      ),
      MenuItems(
        title: 'EditarCita',
        icon: Icons.home,
        link: '/cita_editard',
        description: 'pantalla de Editar cita - deshabilitado',
      ),
      MenuItems(
        title: 'PantallaError',
        icon: Icons.home,
        link: '/pantalla_error',
        description: 'pantalla de Error',
      ),
      MenuItems(
        title: 'Iniciar Sesión',
        icon: Icons.home,
        link: '/login_usuario',
        description: 'Iniciar sesion usuario',
      ),
      MenuItems(
        title: 'Registrar usuario',
        icon: Icons.home,
        link: '/register_usuario',
        description: 'register de usuario',
      ),
      MenuItems(
        title: 'Iniciar Sesión Vet',
        icon: Icons.home,
        link: '/login_vet',
        description: 'Iniciar sesion vet',
      ),
      MenuItems(
        title: 'Registrar Vet',
        icon: Icons.home,
        link: '/register_vet',
        description: 'register de vet',
      ),
      MenuItems(
        title: 'dashboard',
        icon: Icons.home,
        link: '/dashboard',
        description: 'dashboard',
      ),
      MenuItems(
        title: 'Cita Detalles',
        icon: Icons.home,
        link: '/cita_detalles',
        description: 'gesture',
      ),
      MenuItems(
        title: 'Cita Detalles Usuario',
        icon: Icons.home,
        link: '/cita_detalles_usuario',
        description: 'cita detalles',
      ),
      MenuItems(
        title: 'Cita Editar',
        icon: Icons.home,
        link: '/cita_editar',
        description: 'cita editar',
      ),
    ];
