import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:vet_smart_ids/core/app_colors.dart';
import 'package:vet_smart_ids/providers/usuario_provider.dart';

class Login_Usuario extends StatelessWidget {
  const Login_Usuario({super.key});
  static const String name = "login_user";

  @override
  Widget build(BuildContext context) {
    return const UserLoginScreen();
  }
}

class UserLoginScreen extends StatefulWidget {
  const UserLoginScreen({super.key});

  @override
  State<UserLoginScreen> createState() => _UserLoginScreenState();
}

class _UserLoginScreenState extends State<UserLoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final usuarioProvider =
        Provider.of<UsuarioProvider>(context, listen: false);

    final success = await usuarioProvider.login(
      _emailController.text.trim(),
      _passwordController.text,
    );

    if (!mounted) return;

    if (success) {
      // Login exitoso, navegar al menú usuario
      context.go('/menu_usuario');
    } else {
      // Mostrar error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              usuarioProvider.errorMessage ?? 'Error al iniciar sesión'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final usuarioProvider = Provider.of<UsuarioProvider>(context);

    return Scaffold(
      body: Column(
        children: [
          const LoginHeaderImage(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 24),
                    // Título principal
                    const Text(
                      "Bienvenido a VetSmart",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textLight,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    // Subtítulo
                    const Text(
                      "Inicia sesión para conocer la información de tu mascota",
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.slate500Light,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),

                    // Formulario
                    LoginForm(
                      emailController: _emailController,
                      passwordController: _passwordController,
                    ),

                    const SizedBox(height: 16),

                    // Botón de login
                    LoginButton(
                      onPressed:
                          usuarioProvider.isLoading ? null : _handleLogin,
                      isLoading: usuarioProvider.isLoading,
                    ),

                    const SizedBox(height: 24),
                    const SignUpText(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LoginHeaderImage extends StatelessWidget {
  const LoginHeaderImage({super.key});

  @override
  Widget build(BuildContext context) {
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

class LoginForm extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const LoginForm({
    super.key,
    required this.emailController,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Campo de correo
        TextFormField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          style: const TextStyle(
            color: AppColors.textLight,
          ),
          decoration: const InputDecoration(
            hintText: 'Correo',
            prefixIcon: Icon(Icons.email),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Ingresa tu correo';
            }
            if (!value.contains('@')) {
              return 'Ingresa un correo válido';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        // Campo de contraseña
        TextFormField(
          controller: passwordController,
          obscureText: true,
          style: const TextStyle(
            color: AppColors.textLight,
          ),
          decoration: const InputDecoration(
            hintText: 'Contraseña',
            prefixIcon: Icon(Icons.lock),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Ingresa tu contraseña';
            }
            return null;
          },
        ),
      ],
    );
  }
}

class LoginButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;

  const LoginButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : const Text("Acceso"),
      ),
    );
  }
}

class SignUpText extends StatelessWidget {
  const SignUpText({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.go('/register_usuario');
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
