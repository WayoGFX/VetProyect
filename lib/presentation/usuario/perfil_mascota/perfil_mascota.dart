// perfil_mascota.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vet_smart_ids/core/app_colors.dart';
import 'package:vet_smart_ids/presentation/usuario/navbar/navbar_usuario.dart';

// Modelo de datos para el perfil de una mascota
class PetProfile {
  // Propiedades inmutables (final)
  final String name;
  final String breed;
  final String owner;
  final String imageUrl;
  final String species;
  final String birthDate;
  final String contact;
  final String address;
  final String observations;

  // Constructor constante con parámetros requeridos
  const PetProfile({
    required this.name,
    required this.breed,
    required this.owner,
    required this.imageUrl,
    required this.species,
    required this.birthDate,
    required this.contact,
    required this.address,
    required this.observations,
  });
}

// Datos de ejemplo para el perfil
const buddyProfile = PetProfile(
  name: 'Buddy',
  breed: 'Golden Retriever',
  owner: 'Alex Ramirez',
  imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuC-WQqClYYZJDeV4_u2nr20bAFtlb13-wphYnNvigeWhd2KtP9r_DR3OOgO_xkclbWrVFY_QFKY94-fh3A0UTNHfAHfzLjzCkHONu0Pe_bFPDT4cAaOw9nqmDEw9esKWKpQpBvKGVJyLKDKQiUU0GqWNdY_dnbFq-yxxvytcBwz_7-jAukk5xkPNUUKs1kobM-6f5_Mht1eLF85j0hGCOhFEtduvnXHKIdchdvpms-1ypR_-6aooLq-avoiFBQFrGjkgTxV2oFOrjg',
  species: 'Canino',
  birthDate: '15 de Marzo de 2018',
  contact: '+52 55 1234 5678',
  address: 'Calle Principal 123, Ciudad de México',
  observations: 'Buddy es un perro muy activo y amigable. Requiere ejercicio diario y una dieta balanceada',
);

// Pantalla principal del perfil de la mascota
class PerfilMascotaScreen
    extends
        StatefulWidget {
  // Nombre estático para la gestión de rutas
  static const String name = 'perfil_mascota_screen';

  const PerfilMascotaScreen({
    super.key,
  });

  @override
  State<
    PerfilMascotaScreen
  >
  createState() => _PerfilMascotaScreenState();
}

class _PerfilMascotaScreenState
    extends
        State<
          PerfilMascotaScreen
        > {
  @override
  Widget build(
    BuildContext context,
  ) {
    const pet = buddyProfile;

    // Scaffold usa los estilos del tema global
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
          ),
          onPressed: () => context.pop(), // Vuelve atras
        ),
        title: const Text(
          'Perfil de la Mascota',
        ),
        centerTitle: true,
      ),
      // Permite el desplazamiento vertical del contenido
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Sección superior: Foto y nombre
            Padding(
              padding: const EdgeInsets.all(
                16.0,
              ),
              child: Column(
                children: [
                  // Imagen de perfil redondeada
                  CircleAvatar(
                    radius: 64,
                    backgroundImage: NetworkImage(
                      pet.imageUrl,
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    pet.name,
                    // Usa el estilo 'titleLarge' del tema
                    style:
                        Theme.of(
                          context,
                        ).textTheme.titleLarge?.copyWith(
                          fontSize: 24,
                        ),
                  ),
                  Text(
                    pet.breed,
                    style: TextStyle(
                      color: AppColors.slate500Light,
                    ),
                  ),
                  Text(
                    'Propietario: ${pet.owner}',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.slate500Light,
                    ),
                  ),
                ],
              ),
            ),

            // Sección de tarjetas de información
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
              ),
              child: Column(
                children: [
                  // Tarjeta con información general
                  _InfoCard(
                    title: 'Información General',
                    child: Column(
                      children: [
                        _InfoRow(
                          label: 'Especie',
                          value: pet.species,
                        ),
                        _InfoRow(
                          label: 'Raza',
                          value: pet.breed,
                        ),
                        _InfoRow(
                          label: 'Nacimiento',
                          value: pet.birthDate,
                        ),
                        _InfoRow(
                          label: 'Contacto',
                          value: pet.contact,
                        ),
                        _InfoRow(
                          label: 'Dirección',
                          value: pet.address,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  // Tarjeta de observaciones
                  _InfoCard(
                    title: 'Observaciones',
                    child: Text(
                      pet.observations,
                      style:
                          Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(
                            color: AppColors.slate500Light,
                          ),
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  // Botón para historial médico
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.receipt_long,
                      ),
                      label: const Text(
                        'Ver Historial Médico Completo',
                      ),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: AppColors.white, // Color del texto e ícono
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            12,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // navbar
      bottomNavigationBar: const UserNavbar(
        // Le pasamos la ruta estática para que el navbar resalte el ícono "Inicio".
        currentRoute: '/perfil_paciente',
      ),
    );
  }
}

// Widgets Reutilizables

// Tarjeta de contenedor para secciones de información
class _InfoCard
    extends
        StatelessWidget {
  final String title;
  final Widget child;

  const _InfoCard({
    required this.title,
    required this.child,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Container(
      width: double.infinity, // Ocupa todo el ancho
      padding: const EdgeInsets.all(
        16.0,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary20,
        borderRadius: BorderRadius.circular(
          16.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium, // Estilo del tema
          ),
          const SizedBox(
            height: 12,
          ),
          child, // Contenido de la tarjeta
        ],
      ),
    );
  }
}

// Fila para mostrar una etiqueta y un valor
class _InfoRow
    extends
        StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8.0,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          // Borde superior para separar filas
          border: Border(
            top: BorderSide(
              color: AppColors.primary20,
              width: 1.0,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            top: 8.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: AppColors.slate500Light,
                ),
              ),
              // El valor ocupa el espacio restante y se alinea a la derecha
              Expanded(
                child: Text(
                  value,
                  textAlign: TextAlign.right,
                  style:
                      Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
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
