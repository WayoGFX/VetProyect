import 'package:go_router/go_router.dart';

import 'package:vet_smart_ids/presentation/generales/login_vet/login_vet.dart';
import 'package:vet_smart_ids/presentation/generales/register_vet/register_vet.dart';
import 'package:vet_smart_ids/presentation/generales/test_api/test_api_screen.dart';
import 'package:vet_smart_ids/presentation/home/home_screen.dart';
import 'package:vet_smart_ids/presentation/screens.dart';
import 'package:vet_smart_ids/presentation/veterinario/crear_cita/crear_cita.dart';
import 'package:vet_smart_ids/presentation/veterinario/ficha_paciente_veterinario/ficha_paciente_veterinario.dart';
import 'package:vet_smart_ids/presentation/veterinario/menu_veterinario/menu_veterinario.dart';
import 'package:vet_smart_ids/presentation/veterinario/perfil_veterinarios/perfil_veterinario.dart';

// Archivo de rutas

final appRouter = GoRouter(
  initialLocation: '/home',
  routes: [
    GoRoute(
      path: '/home',
      name: HomeScreen.name,
      builder:
          (
            context,
            state,
          ) {
            return const HomeScreen();
          },
    ),
    // Ruta de prueba de API (ELIMINAR EN PRODUCCIÓN)
    GoRoute(
      path: '/test_api',
      name: TestApiScreen.name,
      builder:
          (
            context,
            state,
          ) {
            return const TestApiScreen();
          },
    ),
    //GoRoute Wayo
    GoRoute(
      path: '/menu_usuario',
      name: UserMainMenuScreen.name,
      builder:
          (
            context,
            state,
          ) {
            return const UserMainMenuScreen();
          },
    ),
    GoRoute(
      path: '/menu_veterinario',
      name: VetMainMenuScreen.name,
      builder:
          (
            context,
            state,
          ) {
            return const VetMainMenuScreen();
          },
    ),
    GoRoute(
      path: '/chat',
      name: ChatScreen.name,
      builder:
          (
            context,
            state,
          ) {
            return const ChatScreen();
          },
    ),
    GoRoute(
      path: '/agenda_citas',
      name: AppointmentScreen.name,
      builder:
          (
            context,
            state,
          ) {
            return const AppointmentScreen();
          },
    ),
    GoRoute(
      path: '/ficha_paciente',
      name: PatientProfileScreen.name,
      builder:
          (
            context,
            state,
          ) {
            return PatientProfileScreen(
              patient: maxData,
            );
          },
    ),
    GoRoute(
      path: '/citas_del_dia',
      name: CitasDelDiaScreen.name,
      builder:
          (
            context,
            state,
          ) {
            return const CitasDelDiaScreen();
          },
    ),
    //GoRoute Jaime
    GoRoute(
      path: '/perfil_usuarios',
      name: PerfilUsuarioScreen.name,
      builder:
          (
            context,
            state,
          ) {
            return const PerfilUsuarioScreen();
          },
    ),
    GoRoute(
      path: '/mis_mascotas',
      name: MisMascotasScreen.name,
      builder:
          (
            context,
            state,
          ) {
            return const MisMascotasScreen();
          },
    ),
    GoRoute(
      path: '/perfil_mascota',
      name: PerfilMascotaScreen.name,
      builder:
          (
            context,
            state,
          ) {
            return PerfilMascotaScreen();
          },
    ),

    //GoRoute Hamilton
    GoRoute(
      path: '/lista_pacientes',
      name: PacientesWidget.name,
      builder:
          (
            context,
            state,
          ) {
            return const PacientesWidget();
          },
    ),
    GoRoute(
      path: '/nuevo_paciente',
      name: NuevoPacienteWidget.name,
      builder:
          (
            context,
            state,
          ) {
            return const NuevoPacienteWidget();
          },
    ),
    GoRoute(
      path: '/crear_cita',
      name: CrearCitaWidget.name,
      builder:
          (
            context,
            state,
          ) {
            return const CrearCitaWidget();
          },
    ),
    GoRoute(
      path: '/gesture_editar',
      name: GestureEditar.name,
      builder:
          (
            context,
            state,
          ) {
            return const GestureEditar();
          },
    ),
    GoRoute(
      path: '/agenda_citas_veterinario',
      name: VetAppointmentScreen.name,
      builder:
          (
            context,
            state,
          ) {
            return const VetAppointmentScreen();
          },
    ),
    GoRoute(
      path: '/pantalla_error',
      name: ErrorWidget.name,
      builder:
          (
            context,
            state,
          ) {
            return const ErrorWidget();
          },
    ),

    //GoRoute Andy
    GoRoute(
      path: '/login_usuario',
      name: Login_Usuario.name,
      builder:
          (
            context,
            state,
          ) {
            return const Login_Usuario();
          },
    ),

    GoRoute(
      path: '/register_usuario',
      name: Register_Usuario.name,
      builder:
          (
            context,
            state,
          ) {
            return const Register_Usuario();
          },
    ),
    GoRoute(
      path: '/login_vet',
      name: Login_Vet.name,
      builder:
          (
            context,
            state,
          ) {
            return const Login_Vet();
          },
    ),

    GoRoute(
      path: '/register_vet',
      name: Register_Vet.name,
      builder:
          (
            context,
            state,
          ) {
            return const Register_Vet();
          },
    ),

    GoRoute(
      path: '/dashboard',
      name: Dashboard.name,
      builder:
          (
            context,
            state,
          ) {
            return const Dashboard();
          },
    ),

    GoRoute(
      path: '/perfil_veterinarios',
      name: PerfilVeterinarioScreen.name,
      builder:
          (
            context,
            state,
          ) {
            return const PerfilVeterinarioScreen();
          },
    ),

    GoRoute(
      path: '/cita_detalles_veterinario',
      name: Gesture.name,
      builder:
          (
            context,
            state,
          ) {
            return const Gesture();
          },
    ),
    GoRoute(
      path: '/cita_detalles_usuario',
      name: GestureUser.name,
      builder:
          (
            context,
            state,
          ) {
            return const GestureUser();
          },
    ),
    GoRoute(
      path: '/ficha_paciente_veterinario',
      name: VetPatientProfileScreen.name,
      builder:
          (
            context,
            state,
          ) {
            return VetPatientProfileScreen(
              patient: maxData,
            );
          },
    ),
  ],
  errorBuilder:
      (
        context,
        state,
      ) {
        return const ErrorWidget(); // tu widget personalizado
      },
);
