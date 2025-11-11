import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vet_smart_ids/core/app_colors.dart';
import 'package:vet_smart_ids/presentation/usuario/navbar/navbar_usuario.dart';
// Importamos tu AppColors

// Clase de modelo de mensaje simple
class ChatMessage {
  final String text;
  final bool isUser; // true si es el usuario, false si es VetSmart
  final String senderName;
  final String avatarUrl;

  const ChatMessage({
    required this.text,
    required this.isUser,
    required this.senderName,
    required this.avatarUrl,
  });
}

class ChatScreen
    extends
        StatelessWidget {
  static const String name = 'ChatScreen';
  const ChatScreen({
    super.key,
  });

  // Datos simulados para el chat
  final List<
    ChatMessage
  >
  messages = const [
    ChatMessage(
      text: 'Hola, soy el asistente virtual de VetSmart. ¿En qué puedo ayudarte hoy?',
      isUser: false,
      senderName: 'VetSmart',
      avatarUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCVd4GQMtkHLVk9sKfb9uqiXSeS0rnC_XMUbgLZ8mWuvRKEdUWWoSq-wVzaTF6eGORrmyXLSL5wuF6P9tPAQNk7k3s1C-ZDa0oehizRuCFe0pCGfU2cl_r6wPMovslSyOgO0h4yNIgHEWA9T4em39H1XrN_qMivU8Jvk6sfHd_H4xjoRDp-xBAJJkFBk26XSj3ACxCj-w-thNUOQpIgy7wlRCFEFlrEKARnnG45pgSC-PXthFWz41oKdKASpXUXGjpf9zZusD3tu6E',
    ),
    ChatMessage(
      text: 'Hola, tengo una pregunta sobre la próxima cita de mi mascota.',
      isUser: true,
      senderName: 'Tú',
      avatarUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuA_-srrfn-74XnSre0TsCrGNlZCJh_wKuLf23HwHCAjrXCo5b_LsTIq6BZdsqFABEGYqGsMFaBtDzIMgHk9dQM8gIavDUv5zFC3rILR_IrMtz7NtFWufWIvbjeo-IEVcPYgSwHLg5zxR5vkXJdUQbTxZeaz7nKi-D7BiEMrovAA_ivVkKEh4oXpjj3iJ7WSf17Y6TH8WJp0ToOKxlKgN7OnEMuEIKsxhA6WORGq1bIOc16xCvvsONYwhuMbZso81m6IckNxYkWJUek',
    ),
    ChatMessage(
      text: 'Claro, puedo ayudarte con eso. ¿Podrías proporcionarme el nombre de tu mascota o algún detalle de la cita?',
      isUser: false,
      senderName: 'VetSmart',
      avatarUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCVd4GQMtkHLVk9sKfb9uqiXSeS0rnC_XMUbgLZ8mWuvRKEdUWWoSq-wVzaTF6eGORrmyXLSL5wuF6P9tPAQNk7k3s1C-ZDa0oehizRuCFe0pCGfU2cl_r6wPMovslSyOgO0h4yNIgHEWA9T4em39H1XrN_qMivU8Jvk6sfHd_H4xjoRDp-xBAJJkFBk26XSj3ACxCj-w-thNUOQpIgy7wlRCFEFlrEKARnnG45pgSC-PXthFWz41oKdKASpXUXGjpf9zZusD3tu6E',
    ),
  ];

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      // Appbar
      appBar: AppBar(
        toolbarHeight: 56, // Ajuste para que no use el toolbarHeight
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
          ), // Icono de flecha
          onPressed: () => context.pop(),
          color: AppColors.textLight, // text-gray-800
        ),
        title: Text(
          'VetSmart',
          style:
              Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(
                fontSize: 18,
              ),
        ),
        centerTitle: true,
        actions: const [
          SizedBox(
            width: 24,
          ),
        ], // w-6
        // Borde inferior (border-b border-primary/20)
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(
            1.0,
          ),
          child: Container(
            color: AppColors.primary.withOpacity(
              0.2,
            ),
            height: 1.0,
          ),
        ),
      ),

      // Contenido , los mensajes
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(
                16.0,
              ), // p-4
              itemCount: messages.length,
              // invierte la lista para que empiece desde abajo
              reverse: false,
              itemBuilder:
                  (
                    context,
                    index,
                  ) {
                    return Padding(
                      padding: const EdgeInsets.only(
                        bottom: 24.0,
                      ), // space-y-6
                      child: _MessageBubble(
                        message: messages[index],
                      ),
                    );
                  },
            ),
          ),

          // Entrada de texto con widget
          const _ChatInputBar(),
        ],
      ),
      // navbar
      bottomNavigationBar: const UserNavbar(
        // Le pasamos la ruta estática para que el navbar resalte el ícono "Inicio".
        currentRoute: '/chat',
      ),
    );
  }
}

// componentes reutilzables

// mensaje burbuja
class _MessageBubble
    extends
        StatelessWidget {
  final ChatMessage message;
  const _MessageBubble({
    required this.message,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    final ColorScheme colorScheme = Theme.of(
      context,
    ).colorScheme;

    // Alinear el mensaje a la derecha de usuario o izquierda de bot
    return Align(
      alignment: message.isUser
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Row(
        mainAxisAlignment: message.isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Avatar
          if (!message.isUser)
            _Avatar(
              url: message.avatarUrl,
            ),

          if (!message.isUser)
            const SizedBox(
              width: 12,
            ), // gap-3
          // Contenido del Mensaje
          Flexible(
            child: Column(
              crossAxisAlignment: message.isUser
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                // Nombre del que escribe
                Text(
                  message.senderName,
                  style:
                      Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(
                        fontSize: 12,
                        color: AppColors.slate500Light,
                      ),
                ),
                const SizedBox(
                  height: 4,
                ), // gap-1
                // Globo de Mensaje
                Container(
                  // limitar el ancho
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: message.isUser
                        ? colorScheme.primary
                        : AppColors.primary20,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(
                        8.0,
                      ),
                      topRight: const Radius.circular(
                        8.0,
                      ),
                      bottomLeft: message.isUser
                          ? const Radius.circular(
                              8.0,
                            )
                          : Radius.zero,
                      bottomRight: message.isUser
                          ? Radius.zero
                          : const Radius.circular(
                              8.0,
                            ),
                    ),
                  ),
                  child: Text(
                    message.text,
                    style:
                        Theme.of(
                          context,
                        ).textTheme.bodyMedium?.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: message.isUser
                              ? AppColors.textLight
                              : AppColors.textLight,
                        ),
                  ),
                ),
              ],
            ),
          ),

          if (message.isUser)
            const SizedBox(
              width: 12,
            ), // gap-3
          // Avatar usuario
          if (message.isUser)
            _Avatar(
              url: message.avatarUrl,
            ),
        ],
      ),
    );
  }
}

/// Avatar circular
class _Avatar
    extends
        StatelessWidget {
  final String url;
  const _Avatar({
    required this.url,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.slate500Light.withOpacity(
          0.1,
        ), // Placeholder
      ),
      child: ClipOval(
        child: Image.network(
          url, // URL de imagen simulada
          fit: BoxFit.cover,
          errorBuilder:
              (
                context,
                error,
                stackTrace,
              ) => const Icon(
                Icons.person,
                size: 24,
                color: AppColors.slate500Light,
              ),
        ),
      ),
    );
  }
}

/// Barra de Entrada de Chat
class _ChatInputBar
    extends
        StatelessWidget {
  const _ChatInputBar();

  @override
  Widget build(
    BuildContext context,
  ) {
    final ColorScheme colorScheme = Theme.of(
      context,
    ).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,

        border: Border(
          top: BorderSide(
            color: AppColors.primary.withOpacity(
              0.2,
            ),
          ),
        ),
      ),
      padding: const EdgeInsets.all(
        8.0,
      ),
      child: Row(
        children: [
          // Campo de Texto
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Escribe tu mensaje...',
                hintStyle: TextStyle(
                  color: AppColors.slate500Light,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                filled: true,
                fillColor: AppColors.primary20,
                isDense: true,

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    24,
                  ),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    24,
                  ),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    24,
                  ),

                  borderSide: BorderSide(
                    color: colorScheme.primary,
                    width: 2.0,
                  ),
                ),
              ),
              style: TextStyle(
                color: AppColors.textLight,
                fontSize: 16, // text-base
                fontWeight: FontWeight.normal,
              ),
              minLines: 1,
              maxLines: 4,
            ),
          ),

          const SizedBox(
            width: 8,
          ), // gap-2
          // Botón de Enviar
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colorScheme.primary,
            ),
            child: IconButton(
              icon: const Icon(
                Icons.send,
              ),
              color: AppColors.textLight,
              onPressed: () {
                print(
                  'Mensaje enviado',
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
