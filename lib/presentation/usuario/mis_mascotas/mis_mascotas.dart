import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:vet_smart_ids/core/app_colors.dart';
import 'package:vet_smart_ids/models/mascota.dart';
import 'package:vet_smart_ids/presentation/usuario/navbar/navbar_usuario.dart';
import 'package:vet_smart_ids/providers/mascota_provider.dart';
import 'package:vet_smart_ids/providers/usuario_provider.dart';

/// Pantalla principal que muestra la lista de mascotas del usuario logueado
class MisMascotasScreen extends StatefulWidget {
  /// Nombre de la ruta estática
  static const String name = 'mis_mascotas_screen';

  const MisMascotasScreen({
    super.key,
  });

  @override
  State<MisMascotasScreen> createState() => _MisMascotasScreenState();
}

class _MisMascotasScreenState extends State<MisMascotasScreen> {
  @override
  void initState() {
    super.initState();
    // Cargar las mascotas del usuario después de que se construya el widget
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final usuarioProvider = context.read<UsuarioProvider>();
      if (usuarioProvider.isLoggedIn && usuarioProvider.usuarioActual != null) {
        final usuarioId = usuarioProvider.usuarioActual!.usuarioId;
        if (usuarioId != null) {
          context.read<MascotaProvider>().loadMascotasWithDetailsForUsuario(usuarioId);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => context.pop(),
        ),
        title: const Text('Mis mascotas'),
        centerTitle: true,
      ),
      // Muestra la lista de tarjetas de mascotas usando Provider
      body: Consumer2<UsuarioProvider, MascotaProvider>(
        builder: (context, usuarioProvider, mascotaProvider, child) {
          // Verificar si el usuario está logueado
          if (!usuarioProvider.isLoggedIn) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.person_off_outlined,
                    size: 64,
                    color: AppColors.slate400Light,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Por favor inicia sesión',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
            );
          }

          // Mostrar indicador de carga
          if (mascotaProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // Mostrar error si ocurre
          if (mascotaProvider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red.shade300,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error al cargar mascotas',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    mascotaProvider.errorMessage!,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      final usuarioId = usuarioProvider.usuarioActual?.usuarioId;
                      if (usuarioId != null) {
                        mascotaProvider.loadMascotasWithDetailsForUsuario(usuarioId);
                      }
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }

          final mascotas = mascotaProvider.mascotas;

          // Mostrar mensaje si no hay mascotas
          if (mascotas.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.pets_outlined,
                    size: 64,
                    color: AppColors.slate400Light,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No tienes mascotas registradas',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Crea una nueva mascota para comenzar',
                    style: TextStyle(color: AppColors.slate500Light),
                  ),
                ],
              ),
            );
          }

          // Mostrar lista de mascotas
          return RefreshIndicator(
            onRefresh: () {
              final usuarioId = usuarioProvider.usuarioActual?.usuarioId;
              if (usuarioId != null) {
                return mascotaProvider.loadMascotasWithDetailsForUsuario(usuarioId);
              }
              return Future.value();
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: mascotas.length,
              itemBuilder: (context, index) {
                final mascota = mascotas[index];
                return _MascotaCard(mascota: mascota);
              },
            ),
          );
        },
      ),
      // Navbar
      bottomNavigationBar: const UserNavbar(
        currentRoute: '/mis_mascotas',
      ),
    );
  }
}

/// Widget reutilizable para la tarjeta de una mascota
class _MascotaCard extends StatelessWidget {
  final Mascota mascota;

  const _MascotaCard({
    required this.mascota,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Card(
        elevation: 4,
        shadowColor: AppColors.black.withOpacity(0.1),
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: InkWell(
          onTap: () {
            // Seleccionar la mascota y navegar al perfil
            context.read<MascotaProvider>().selectMascota(mascota);
            context.push('/perfil_mascota');
          },
          child: Stack(
            children: [
              // Imagen de la mascota
              AspectRatio(
                aspectRatio: 1 / 1,
                child: mascota.fotoUrl != null && mascota.fotoUrl!.isNotEmpty
                    ? Image.network(
                        mascota.fotoUrl!,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: AppColors.primary20,
                            child: Icon(
                              Icons.pets,
                              size: 80,
                              color: AppColors.primary,
                            ),
                          );
                        },
                      )
                    : Container(
                        color: AppColors.primary20,
                        child: Icon(
                          Icons.pets,
                          size: 80,
                          color: AppColors.primary,
                        ),
                      ),
              ),

              // Degradado oscuro y texto
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.black60,
                        Colors.transparent,
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.center,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Nombre de la mascota
                          Text(
                            mascota.nombre,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: AppColors.white,
                                  fontSize: 24,
                                ),
                          ),
                          // Especie y raza
                          Text(
                            '${mascota.especie} • ${mascota.raza}',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppColors.white.withOpacity(0.9),
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
