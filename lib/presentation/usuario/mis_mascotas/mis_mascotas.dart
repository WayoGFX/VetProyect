// mis_mascotas.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vet_smart_ids/core/app_colors.dart';
import 'package:vet_smart_ids/presentation/usuario/navbar/navbar_usuario.dart';

// Modelo de datos para una mascota
class Pet {
  final String name;
  final String species;
  final String imageUrl;

  // Constructor constante
  const Pet({
    required this.name,
    required this.species,
    required this.imageUrl,
  });
}

// Lista de datos de mascotas de ejemplo (mock data)
const List<
  Pet
>
userPets = [
  Pet(
    name: 'Max',
    species: 'Perro',
    imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDMtF4PPptbOJ1sNbi34MACT0NDviPxYFfxbHTBqUBmyiwgjQ4lb_1rbX7dYit3P_2vZFDrt45DqhrhkenLEnGL_9NBgsdV6YZP3tffsX0kAAqFrRlEjY49L0q0BNPOp_ERVnaTcF3H-0xsOWwF6XV-ZFFA3_DNBpL6NPmTLue67fKCSQKzfnI3W_2uKv_cPac1efKhpl4v1BVoqpHGohKgqmyDMh67XdznKqe3ltu7kUt-CSV-YFq5a-H5RgfdHgsl2-a9NBTosH0',
  ),
  Pet(
    name: 'Mimi',
    species: 'Gato',
    imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBgi7XM0rYfLr26rmQo-tdgLWoLRiIiGmbePpkF7acLCGMcn6k8hgtMNvN9D9eIjN2VJ_4OW8bziXbevetcptjuN69tZ7uEo5qDm_v3QJZAmFihuzC0dbyQOrdtu81ICrIcOswv-ugQTFsemPMLA5SyH72L_Q5RZj8eaQ2O-LCnRB6f9oh7HlrTUOblDidtm-cxWhhNUXlP25MrgYY4VAkMy7fl3HRcqomNo8Nnxi2UqVBiS_U8lMuCmfU65RT11_aKlDoPzMBcDT0',
  ),
  Pet(
    name: 'Buddy',
    species: 'Perro',
    imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuD1UeslQHKKEV7wozgVzgCIHExJPoi5ljygZtcrbaxBIu3ZenzZyE_LtnwbYSkj25vxJWkwOsUWjTggkEkA-JtWH_6CRHgWorgJxPMoSZCkHYhDGhWYXUXbpk3uVpFIqAMT6WXaPDBinB-NX7UHBstRhLRKFWcUvhN1tlBR2_gc2I8yJYRSVpC_1TxgcJPi6moIGx4uV6Lx0la91rN9kgbjC9M9JsFhXBBjxZWTk4jtCZdBYC7SPd7UCTR6ju4-56VlrIBYnFHXLuQ',
  ),
];

// Pantalla principal que muestra la lista de mascotas
class MisMascotasScreen
    extends
        StatefulWidget {
  // Nombre de la ruta estática
  static const String name = 'mis_mascotas_screen';

  const MisMascotasScreen({
    super.key,
  });

  @override
  State<
    MisMascotasScreen
  >
  createState() => _MisMascotasScreenState();
}

class _MisMascotasScreenState
    extends
        State<
          MisMascotasScreen
        > {
  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
          ),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Mis mascotas',
        ),
        centerTitle: true,
      ),
      // Muestra la lista de tarjetas de mascotas de forma eficiente
      body: ListView.builder(
        padding: const EdgeInsets.all(
          16.0,
        ),
        itemCount: userPets.length, // Total de elementos a construir
        itemBuilder:
            (
              context,
              index,
            ) {
              final pet = userPets[index]; // Obtiene la mascota actual
              return _PetCard(
                pet: pet,
              ); // Retorna el widget de la tarjeta
            },
      ),

      // navbar
      bottomNavigationBar: const UserNavbar(
        // Le pasamos la ruta estática para que el navbar resalte el ícono "Inicio".
        currentRoute: '/mis_mascotas',
      ),
    );
  }
}

// Widget reutilizable para la tarjeta de una mascota
class _PetCard
    extends
        StatelessWidget {
  final Pet pet; // Datos de la mascota

  const _PetCard({
    required this.pet,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    // Agrega espacio vertical después de la tarjeta
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 24.0,
      ),
      child: Card(
        elevation: 4,
        shadowColor: AppColors.black.withOpacity(
          0.1,
        ),
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            16.0,
          ),
        ),
        child: InkWell(
          onTap: () {
            context.push(
              '/perfil_mascota',
            );
          },
          // Permite apilar la imagen, el degradado y el texto
          child: Stack(
            children: [
              // Asegura que la imagen sea cuadrada
              AspectRatio(
                aspectRatio:
                    1 /
                    1,
                // Carga la imagen desde la red
                child: Image.network(
                  pet.imageUrl,
                  fit: BoxFit.cover,
                  // Muestra un indicador de carga
                  loadingBuilder:
                      (
                        context,
                        child,
                        loadingProgress,
                      ) {
                        if (loadingProgress ==
                            null)
                          return child;
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                ),
              ),

              // Superpone el degradado oscuro y el texto
              Positioned.fill(
                child: Container(
                  // Degradado para mejorar la legibilidad del texto
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
                    padding: const EdgeInsets.all(
                      16.0,
                    ),
                    // Alinea el contenido en la parte inferior izquierda
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Nombre de la mascota
                          Text(
                            pet.name,
                            style:
                                Theme.of(
                                  context,
                                ).textTheme.titleLarge?.copyWith(
                                  color: AppColors.white,
                                  fontSize: 24,
                                ),
                          ),
                          // Especie de la mascota
                          Text(
                            pet.species,
                            style:
                                Theme.of(
                                  context,
                                ).textTheme.bodyMedium?.copyWith(
                                  color: AppColors.white.withOpacity(
                                    0.9,
                                  ),
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
