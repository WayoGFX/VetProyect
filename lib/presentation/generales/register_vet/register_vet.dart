import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vet_smart_ids/core/app_colors.dart';

class Register_Vet
    extends
        StatelessWidget {
  const Register_Vet({
    super.key,
  });
  static const String name = "register_vet";

  @override
  Widget build(
    BuildContext context,
  ) {
    // Retornamos el Scaffold
    return Scaffold(
      body: Column(
        children: [
          const RegisterHeaderImage(),
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
                    "Crear una cuenta",
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
                    "Únete a VetSmart para gestionar tu clínica",
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.slate500Light,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(
                    height: 32,
                  ),
                  SignUpForm(),
                  SizedBox(
                    height: 24,
                  ),
                  SignUpButton(),
                  SizedBox(
                    height: 24,
                  ),
                  LoginRedirectText(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SignUpForm
    extends
        StatelessWidget {
  const SignUpForm({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Column(
      children: [
        _buildTextField(
          "Nombre",
        ),
        const SizedBox(
          height: 16,
        ),
        _buildTextField(
          "Apellido",
        ),
        const SizedBox(
          height: 16,
        ),
        _buildTextField(
          "Correo",
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(
          height: 16,
        ),
        _buildTextField(
          "Contraseña",
          obscureText: true,
        ),
        const SizedBox(
          height: 16,
        ),
        _buildTextField(
          "Confirmar contraseña",
          obscureText: true,
        ),
      ],
    );
  }

  // Crea campos reutilizables con estilos del tema
  Widget _buildTextField(
    String hint, {
    bool obscureText = false,
    TextInputType? keyboardType,
  }) {
    // Usamos TextFormField para heredar los estilos del tema
    return TextFormField(
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: const TextStyle(
        color: AppColors.textLight,
      ),
      decoration: InputDecoration(
        hintText: hint,
        // Los estilos de decoración se toman de app_theme.dart
      ),
    );
  }
}

class SignUpButton
    extends
        StatelessWidget {
  const SignUpButton({
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
          // Acción temporal para definir ruta de inscribirse
          debugPrint(
            "Enviando datos de inscripción...",
          );
        },
        // Los estilos se heredan de app_theme.dart
        child: const Text(
          "Inscribirse",
          // El estilo de texto base se hereda de app_theme.dart
        ),
      ),
    );
  }
}

class LoginRedirectText
    extends
        StatelessWidget {
  const LoginRedirectText({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return GestureDetector(
      onTap: () {
        // Navega a la pantalla de login usando GoRouter
        context.go(
          '/login_vet',
        );
      },
      child: const Text.rich(
        TextSpan(
          text: "¿Ya tienes una cuenta? ",
          style: TextStyle(
            fontSize: 14,
            color: AppColors.primary,
          ),
          children: [
            TextSpan(
              text: 'Acceso',
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

class RegisterHeaderImage
    extends
        StatelessWidget {
  const RegisterHeaderImage({
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
