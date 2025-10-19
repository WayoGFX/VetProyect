import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vet_smart_ids/core/app_colors.dart';

class Login_Vet
    extends
        StatelessWidget {
  const Login_Vet({
    super.key,
  });
  static const String name = "login_vet";

  @override
  Widget build(
    BuildContext context,
  ) {
    return const VetSmartLoginScreen();
  }
}

class VetSmartLoginScreen
    extends
        StatelessWidget {
  const VetSmartLoginScreen({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      body: Column(
        children: [
          const LoginHeaderImage(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  SizedBox(
                    height: 24,
                  ),

                  // Título principal
                  Text(
                    "Bienvenido a VetSmart",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textLight,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(
                    height: 8,
                  ),

                  // Subtítulo
                  Text(
                    "Inicia sesión para administrar tu clínica",
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.slate500Light,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(
                    height: 32,
                  ),
                  LoginForm(),
                  SizedBox(
                    height: 16,
                  ),
                  LoginButton(),
                  SizedBox(
                    height: 24,
                  ),
                  SignUpText(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LoginHeaderImage
    extends
        StatelessWidget {
  const LoginHeaderImage({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Container(
      height: 200,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
            'https://lh3.googleusercontent.com/aida-public/AB6AXuDWWYCfUcAQi5S3OMLBCD2j2TFsuriVwPEz-1vcnUYLs7FEfTF_yTNxOxib3IAFquhAABjRBR5r8X4ClUsJQCK7OPqjONfW39xVBrurmmhZ3_rby1rE9u4PcBZeb1pwX24szPFXYwo9VvOMGdu7w_r9uXYc-k3qKeI1urRgQyVk6H-sSKlriWljfpZncYWVqss1a1VpRSVmLwki6V1t9u5zOPFb7ivDXWHhzJ9-YHRJZ_lGi7G6xTOMfdocHdy6XmH0DZ2XjVGn3MY',
          ),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class LoginForm
    extends
        StatelessWidget {
  const LoginForm({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    // Usamos TextFormField para mejorar la integración con formularios
    return Column(
      children: [
        // Campo de correo
        TextFormField(
          style: const TextStyle(
            color: AppColors.textLight,
          ),
          decoration: InputDecoration(
            hintText: 'Correo',
          ),
        ),
        const SizedBox(
          height: 16,
        ),

        // Campo de contraseña
        TextFormField(
          obscureText: true,
          style: const TextStyle(
            color: AppColors.textLight,
          ),
          decoration: InputDecoration(
            hintText: 'Contraseña',
          ),
        ),
      ],
    );
  }
}

class LoginButton
    extends
        StatelessWidget {
  const LoginButton({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          GoRouter.of(
            context,
          ).push(
            '/menu_veterinario',
          );
        },
        // Los estilos se heredan de app_theme.dart
        child: const Text(
          "Acceso",
          // El estilo de texto base se hereda de app_theme.dart
        ),
      ),
    );
  }
}

class SignUpText
    extends
        StatelessWidget {
  const SignUpText({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return GestureDetector(
      onTap: () {
        // Navega a la pantalla de registro usando GoRouter
        context.go(
          '/register_vet',
        ); // <-- Cambio a GoRouter
      },
      child: const Text.rich(
        TextSpan(
          text: "¿No tienes una cuenta? ",
          style: TextStyle(
            fontSize: 14,
            color: AppColors.primary,
          ),
          children: [
            TextSpan(
              text: 'Inscribirse',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
