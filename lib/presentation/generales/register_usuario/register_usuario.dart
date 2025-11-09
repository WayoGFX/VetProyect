import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:vet_smart_ids/core/app_colors.dart';
import 'package:vet_smart_ids/models/usuario.dart';
import 'package:vet_smart_ids/providers/usuario_provider.dart';

class Register_Usuario extends StatelessWidget {
  const Register_Usuario({super.key});
  static const String name = "register";

  @override
  Widget build(BuildContext context) {
    return const UserRegisterScreen();
  }
}

class UserRegisterScreen extends StatefulWidget {
  const UserRegisterScreen({super.key});

  @override
  State<UserRegisterScreen> createState() => _UserRegisterScreenState();
}

class _UserRegisterScreenState extends State<UserRegisterScreen> {
  final _nombreController = TextEditingController();
  final _apellidoController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _direccionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nombreController.dispose();
    _apellidoController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _telefonoController.dispose();
    _direccionController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    // Validar que las contraseñas coincidan
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Las contraseñas no coinciden'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final usuarioProvider =
        Provider.of<UsuarioProvider>(context, listen: false);

    // Crear objeto Usuario
    final nuevoUsuario = Usuario(
      nombreCompleto:
          '${_nombreController.text.trim()} ${_apellidoController.text.trim()}',
      email: _emailController.text.trim(),
      passwordHash: _passwordController.text, // En producción, hashear esto
      telefono: _telefonoController.text.trim(),
      direccion: _direccionController.text.trim(),
      fechaRegistro: DateTime.now(),
    );

    final success = await usuarioProvider.register(nuevoUsuario);

    if (!mounted) return;

    if (success) {
      // Registro exitoso, mostrar mensaje y navegar al menú
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('¡Cuenta creada exitosamente!'),
          backgroundColor: Colors.green,
        ),
      );
      context.go('/menu_usuario');
    } else {
      // Mostrar error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              usuarioProvider.errorMessage ?? 'Error al crear la cuenta'),
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
          const RegisterHeaderImage(),
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
                      "Crear una cuenta",
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
                      "Únete a VetSmart para conocer la información de tu mascota",
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.slate500Light,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),

                    // Formulario
                    SignUpForm(
                      nombreController: _nombreController,
                      apellidoController: _apellidoController,
                      emailController: _emailController,
                      passwordController: _passwordController,
                      confirmPasswordController: _confirmPasswordController,
                      telefonoController: _telefonoController,
                      direccionController: _direccionController,
                    ),

                    const SizedBox(height: 24),

                    // Botón de registro
                    SignUpButton(
                      onPressed:
                          usuarioProvider.isLoading ? null : _handleRegister,
                      isLoading: usuarioProvider.isLoading,
                    ),

                    const SizedBox(height: 24),
                    const LoginRedirectText(),
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

class SignUpForm extends StatelessWidget {
  final TextEditingController nombreController;
  final TextEditingController apellidoController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final TextEditingController telefonoController;
  final TextEditingController direccionController;

  const SignUpForm({
    super.key,
    required this.nombreController,
    required this.apellidoController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.telefonoController,
    required this.direccionController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Nombre
        TextFormField(
          controller: nombreController,
          style: const TextStyle(color: AppColors.textLight),
          decoration: const InputDecoration(
            hintText: 'Nombre',
            prefixIcon: Icon(Icons.person),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Ingresa tu nombre';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        // Apellido
        TextFormField(
          controller: apellidoController,
          style: const TextStyle(color: AppColors.textLight),
          decoration: const InputDecoration(
            hintText: 'Apellido',
            prefixIcon: Icon(Icons.person_outline),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Ingresa tu apellido';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        // Email
        TextFormField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          style: const TextStyle(color: AppColors.textLight),
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

        // Teléfono
        TextFormField(
          controller: telefonoController,
          keyboardType: TextInputType.phone,
          style: const TextStyle(color: AppColors.textLight),
          decoration: const InputDecoration(
            hintText: 'Teléfono',
            prefixIcon: Icon(Icons.phone),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Ingresa tu teléfono';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        // Dirección
        TextFormField(
          controller: direccionController,
          style: const TextStyle(color: AppColors.textLight),
          decoration: const InputDecoration(
            hintText: 'Dirección',
            prefixIcon: Icon(Icons.home),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Ingresa tu dirección';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        // Contraseña
        TextFormField(
          controller: passwordController,
          obscureText: true,
          style: const TextStyle(color: AppColors.textLight),
          decoration: const InputDecoration(
            hintText: 'Contraseña',
            prefixIcon: Icon(Icons.lock),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Ingresa tu contraseña';
            }
            if (value.length < 6) {
              return 'Mínimo 6 caracteres';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        // Confirmar contraseña
        TextFormField(
          controller: confirmPasswordController,
          obscureText: true,
          style: const TextStyle(color: AppColors.textLight),
          decoration: const InputDecoration(
            hintText: 'Confirmar contraseña',
            prefixIcon: Icon(Icons.lock_outline),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Confirma tu contraseña';
            }
            return null;
          },
        ),
      ],
    );
  }
}

class SignUpButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;

  const SignUpButton({
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
            : const Text("Inscribirse"),
      ),
    );
  }
}

class LoginRedirectText extends StatelessWidget {
  const LoginRedirectText({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.go('/login_usuario');
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

class RegisterHeaderImage extends StatelessWidget {
  const RegisterHeaderImage({super.key});

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
