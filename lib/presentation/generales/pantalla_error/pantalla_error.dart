import 'package:flutter/material.dart';
import 'package:vet_smart_ids/core/app_colors.dart'; // importa paleta de colores

class ErrorWidget extends StatelessWidget {
  static const String name = 'PantallaError';

  const ErrorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.black05 : AppColors.backgroundLight,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Botón de cerrar (esquina superior derecha)
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(Icons.close, size: 28),
                  color: isDark ? AppColors.textLight : AppColors.textLight,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),

              // Contenido central
              Column(
                children: [
                  AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                            'https://lh3.googleusercontent.com/aida-public/AB6AXuAAhvQ1rmEQ8QBFHP2gU5t9PULNH9dWMcdvVAbc_aMayfn55nnajrpJbzrli7lCTwQrGm-Gl6AK0j7tMxTQ5gqyvlU41CxH0CPskgdqZuPQbazLy-UekVISGsvCpIXGa_OOeyVniDjCAXPJRr4yo0S_LTW3da1n7HYWLBOb3_LZ52xCo3fkB1D_PzRVRBiTv9rpUCV0-3tUNv3zjZrJWba_nnqbzgTvfIXo5hQ4sjmR_PqokXigs6k4RbFsdQtzducUgpN7bq9ekwI',
                          ),
                          fit: BoxFit.contain,
                          alignment: Alignment.center,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    '¡Ups! Algo salió mal',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.textLight : AppColors.textLight,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Lo sentimos, pero ocurrió un error inesperado. Por favor, inténtalo de nuevo o contacta a soporte si el problema persiste.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color:
                          isDark ? AppColors.textLight : AppColors.textLight,
                    ),
                  ),
                ],
              ),

              // Botón inferior
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.black87,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                    shadowColor: AppColors.primary.withOpacity(0.2),
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  child: const Text('Intentar de nuevo'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
