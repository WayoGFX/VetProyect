import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:vet_smart_ids/core/app_colors.dart';
import 'package:vet_smart_ids/models/veterinario.dart';
import 'package:vet_smart_ids/providers/veterinario_provider.dart';

class Register_Vet extends StatelessWidget {
  const Register_Vet({super.key});
  static const String name = "register_vet";

  @override
  Widget build(BuildContext context) {
    return const VetRegisterScreen();
  }
}

class VetRegisterScreen extends StatefulWidget {
  const VetRegisterScreen({super.key});

  @override
  State<VetRegisterScreen> createState() => _VetRegisterScreenState();
}

class _VetRegisterScreenState extends State<VetRegisterScreen> {
  final _nombreController = TextEditingController();
  final _apellidoController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _especialidadController = TextEditingController();
  final _codigoController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // Código secreto de la veterinaria (3 números + 1 letra)
  // CAMBIAR ESTO según el código real de tu veterinaria
  static const String CODIGO_VETERINARIA = '123A';

  @override
  void dispose() {
    _nombreController.dispose();
    _apellidoController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _telefonoController.dispose();
    _especialidadController.dispose();
    _codigoController.dispose();
    super.dispose();
  }

  bool _validarCodigoVeterinaria(String codigo) {
    // Validar formato: 3 dígitos + 1 letra mayúscula
    final regex = RegExp(r'^\d{3}[A-Z]$');
    if (!regex.hasMatch(codigo)) {
      return false;
    }
    // Validar que sea el código correcto
    return codigo == CODIGO_VETERINARIA;
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

    // Validar código de veterinaria
    if (!_validarCodigoVeterinaria(_codigoController.text.trim().toUpperCase())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Código de veterinaria inválido'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    final veterinarioProvider =
        Provider.of<VeterinarioProvider>(context, listen: false);

    // Crear objeto Veterinario
    final nuevoVeterinario = Veterinario(
      nombreCompleto:
          '${_nombreController.text.trim()} ${_apellidoController.text.trim()}',
      email: _emailController.text.trim(),
      passwordHash: _passwordController.text,
      telefono: _telefonoController.text.trim(),
      especialidad: _especialidadController.text.trim(),
    );

    final success = await veterinarioProvider.register(nuevoVeterinario);

    if (!mounted) return;

    if (success) {
      // Registro exitoso
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('¡Cuenta creada exitosamente!'),
          backgroundColor: Colors.green,
        ),
      );
      context.go('/menu_veterinario');
    } else {
      // Mostrar error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(veterinarioProvider.errorMessage ??
              'Error al crear la cuenta'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final veterinarioProvider = Provider.of<VeterinarioProvider>(context);

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
                      "Crear cuenta de Veterinario",
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
                      "Únete a VetSmart para gestionar tu clínica",
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
                      especialidadController: _especialidadController,
                      codigoController: _codigoController,
                    ),

                    const SizedBox(height: 24),

                    // Botón de registro
                    SignUpButton(
                      onPressed: veterinarioProvider.isLoading
                          ? null
                          : _handleRegister,
                      isLoading: veterinarioProvider.isLoading,
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
  final TextEditingController especialidadController;
  final TextEditingController codigoController;

  const SignUpForm({
    super.key,
    required this.nombreController,
    required this.apellidoController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.telefonoController,
    required this.especialidadController,
    required this.codigoController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Código de Veterinaria (PRIMERO - Lo más importante)
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.amber.shade50,
            border: Border.all(color: Colors.amber.shade700, width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(Icons.lock, color: Colors.amber.shade700),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Código de Veterinaria',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: codigoController,
                maxLength: 4,
                textCapitalization: TextCapitalization.characters,
                style: const TextStyle(
                  color: AppColors.textLight,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 4,
                ),
                decoration: const InputDecoration(
                  hintText: '123A',
                  helperText: 'Formato: 3 números + 1 letra (Ej: 456B)',
                  helperMaxLines: 2,
                  prefixIcon: Icon(Icons.vpn_key),
                  counterText: '',
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9A-Za-z]')),
                  TextInputFormatter.withFunction((oldValue, newValue) {
                    return TextEditingValue(
                      text: newValue.text.toUpperCase(),
                      selection: newValue.selection,
                    );
                  }),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingresa el código';
                  }
                  if (!RegExp(r'^\d{3}[A-Z]$').hasMatch(value)) {
                    return 'Formato incorrecto (debe ser 3 números + 1 letra)';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

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

        // Especialidad
        TextFormField(
          controller: especialidadController,
          style: const TextStyle(color: AppColors.textLight),
          decoration: const InputDecoration(
            hintText: 'Especialidad',
            helperText: 'Ej: Medicina General, Cirugía, etc.',
            prefixIcon: Icon(Icons.medical_services),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Ingresa tu especialidad';
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
        context.go('/login_vet');
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
