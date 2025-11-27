import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vet_smart_ids/core/app_colors.dart';
import 'package:vet_smart_ids/presentation/usuario/navbar/navbar_usuario.dart';
// Importamos tu AppColors
import 'package:provider/provider.dart';
import 'package:vet_smart_ids/providers/mascota_provider.dart';
import 'package:vet_smart_ids/models/mascota.dart';
import 'dart:async';

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
        StatefulWidget {
  static const String name = 'ChatScreen';
  const ChatScreen({
    super.key,
  });

  @override
  State<
    ChatScreen
  >
  createState() => _ChatScreenState();
}

class _ChatScreenState
    extends
        State<
          ChatScreen
        > {
  final List<
    ChatMessage
  >
  messages = [];
  final TextEditingController _controller = TextEditingController();
  bool _awaitingPetName = true;
  bool _awaitingChoice = false;
  List<
    Mascota
  >
  _choiceCandidates = [];

  @override
  void initState() {
    super.initState();
    // Mensaje inicial
    messages.add(
      const ChatMessage(
        text: 'Hola, soy el asistente virtual de VetSmart. ¿Cuál es el nombre de tu mascota?',
        isUser: false,
        senderName: 'VetSmart',
        avatarUrl: '',
      ),
    );
    // Cargar mascotas en el provider si no están cargadas
    WidgetsBinding.instance.addPostFrameCallback(
      (
        _,
      ) {
        final provider = context
            .read<
              MascotaProvider
            >();
        if (provider.mascotas.isEmpty) provider.loadMascotas();
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<
    void
  >
  _handleSend(
    String text,
  ) async {
    if (text.trim().isEmpty) return;
    try {
      // wrap in try to catch unexpected errors and show friendly message
      setState(
        () {
          messages.add(
            ChatMessage(
              text: text.trim(),
              isUser: true,
              senderName: 'Tú',
              avatarUrl: '',
            ),
          );
          _controller.clear();
        },
      );

      // Si estamos esperando que el usuario elija entre varias coincidencias
      if (_awaitingChoice) {
        final choice = int.tryParse(
          text.trim(),
        );
        if (choice !=
                null &&
            choice >
                0 &&
            choice <=
                _choiceCandidates.length) {
          final chosen =
              _choiceCandidates[choice -
                  1];
          // seleccionar y cargar
          final prov = context
              .read<
                MascotaProvider
              >();
          prov.selectMascota(
            chosen,
          );
          await prov.loadPacienteDetalle(
            chosen.mascotaId!,
          );
          _awaitingChoice = false;
          _choiceCandidates = [];
          messages.add(
            ChatMessage(
              text: 'Perfecto — has seleccionado a ${chosen.nombre}. He cargado su información.',
              isUser: false,
              senderName: 'VetSmart',
              avatarUrl: '',
            ),
          );
          setState(
            () {},
          );
          return;
        } else {
          messages.add(
            const ChatMessage(
              text: 'Opción inválida. Responde con el número correspondiente a la mascota.',
              isUser: false,
              senderName: 'VetSmart',
              avatarUrl: '',
            ),
          );
          setState(
            () {},
          );
          return;
        }
      }

      // Si aún no tenemos mascota, interpretamos el texto como nombre
      if (_awaitingPetName) {
        // If the user provided symptoms instead of a name, attempt a diagnosis without pet data
        if (_looksLikeSymptoms(
          text,
        )) {
          await _diagnoseWithoutPet(
            text.trim(),
          );
          return;
        }

        await _resolvePetByName(
          text.trim(),
        );
        return;
      }

      // si llegamos aquí, es un mensaje normal -> procesar más abajo
    } catch (
      e,
      st
    ) {
      // mostrar error en chat y console
      messages.add(
        ChatMessage(
          text: 'Error interno al procesar tu mensaje: ${e.toString()}',
          isUser: false,
          senderName: 'VetSmart',
          avatarUrl: '',
        ),
      );
      print(
        'Error en chat _handleSend: $e',
      );
      print(
        st,
      );
      setState(
        () {},
      );
      return;
    }

    // Construir respuesta local (chatbot sin LLM)
    final provider = context
        .read<
          MascotaProvider
        >();
    String responseText;
    try {
      responseText = _localResponder(
        text,
        provider.pacienteDetalle,
      );
    } catch (
      e
    ) {
      responseText = 'Hubo un error al generar la respuesta: $e';
    }

    setState(
      () {
        messages.add(
          ChatMessage(
            text: responseText,
            isUser: false,
            senderName: 'VetSmart',
            avatarUrl: '',
          ),
        );
      },
    );
  }

  Future<
    void
  >
  _resolvePetByName(
    String name,
  ) async {
    final prov = context
        .read<
          MascotaProvider
        >();
    final lower = name.toLowerCase();
    Mascota? found;
    try {
      // Asegurarse de tener la lista
      if (prov.mascotas.isEmpty) await prov.loadMascotas();
      // 1) búsqueda exacta
      for (var m in prov.mascotas) {
        if (m.nombre.toLowerCase() ==
            lower) {
          found = m;
          break;
        }
      }
      // 2) startsWith
      if (found ==
          null) {
        final starts = prov.mascotas
            .where(
              (
                m,
              ) => m.nombre.toLowerCase().startsWith(
                lower,
              ),
            )
            .toList();
        if (starts.length ==
            1)
          found = starts.first;
        if (starts.length >
            1) {
          _choiceCandidates = starts;
        }
      }
      // 3) contains
      if (found ==
              null &&
          _choiceCandidates.isEmpty) {
        final contains = prov.mascotas
            .where(
              (
                m,
              ) => m.nombre.toLowerCase().contains(
                lower,
              ),
            )
            .toList();
        if (contains.length ==
            1)
          found = contains.first;
        if (contains.length >
            1) {
          _choiceCandidates = contains;
        }
      }
    } catch (
      e
    ) {
      // ignorar
    }

    if (found ==
            null &&
        _choiceCandidates.isEmpty) {
      messages.add(
        const ChatMessage(
          text: 'No encontré una mascota con ese nombre. ¿Puedes verificar o dar más datos (raza, dueño)?',
          isUser: false,
          senderName: 'VetSmart',
          avatarUrl: '',
        ),
      );
      // seguir esperando nombre
      _awaitingPetName = true;
      setState(
        () {},
      );
      return;
    }

    // Si hay varias coincidencias, pedir al usuario que elija por número
    if (found ==
            null &&
        _choiceCandidates.isNotEmpty) {
      _awaitingChoice = true;
      _awaitingPetName = false;
      final buffer = StringBuffer();
      buffer.writeln(
        'Encontré varias mascotas con ese nombre. Responde con el número correspondiente:',
      );
      for (
        var i = 0;
        i <
            _choiceCandidates.length;
        i++
      ) {
        final m = _choiceCandidates[i];
        buffer.writeln(
          '${i + 1}) ${m.nombre} — ${m.raza} — ID: ${m.mascotaId}',
        );
      }
      messages.add(
        ChatMessage(
          text: buffer.toString(),
          isUser: false,
          senderName: 'VetSmart',
          avatarUrl: '',
        ),
      );
      setState(
        () {},
      );
      return;
    }

    // Seleccionar y cargar detalle
    final foundNonNull = found!;
    try {
      prov.selectMascota(
        foundNonNull,
      );
      if (foundNonNull.mascotaId ==
          null) {
        messages.add(
          ChatMessage(
            text: 'La mascota encontrada no tiene ID válido en el sistema.',
            isUser: false,
            senderName: 'VetSmart',
            avatarUrl: '',
          ),
        );
        _awaitingPetName = true;
        setState(
          () {},
        );
        return;
      }
      await prov.loadPacienteDetalle(
        foundNonNull.mascotaId!,
      );

      final petSummary = _buildPetContextText(
        prov.pacienteDetalle,
      );
      messages.add(
        ChatMessage(
          text: 'Perfecto — encontré a ${foundNonNull.nombre}. He cargado su información:\n$petSummary\n¿En qué puedo ayudarte respecto a ${foundNonNull.nombre}?',
          isUser: false,
          senderName: 'VetSmart',
          avatarUrl: '',
        ),
      );
      setState(
        () {},
      );
    } catch (
      e,
      st
    ) {
      // Manejar errores al cargar detalle
      messages.add(
        ChatMessage(
          text: 'No pude cargar los detalles de la mascota: ${e.toString()}',
          isUser: false,
          senderName: 'VetSmart',
          avatarUrl: '',
        ),
      );
      print(
        'Error cargando paciente detalle: $e',
      );
      print(
        st,
      );
      // permitir reintento
      _awaitingPetName = true;
      setState(
        () {},
      );
      return;
    }
  }

  String _buildPetContextText(
    pacienteDetalle,
  ) {
    if (pacienteDetalle ==
        null)
      return '';
    final mascota = pacienteDetalle.mascota;
    final dueno = pacienteDetalle.dueno;
    final vacunas =
        (pacienteDetalle.vacunas
                as List)
            .map(
              (
                v,
              ) =>
                  (v.vacunaNombre ??
                  (v.vacuna?.nombre) ??
                  'vacuna'),
            )
            .join(
              ', ',
            );
    final alergias =
        (pacienteDetalle.alergias
                as List)
            .map(
              (
                a,
              ) =>
                  (a.alergiaNombre ??
                  (a.alergia?.tipo) ??
                  'alergia'),
            )
            .join(
              ', ',
            );
    final ultimaConsulta =
        (pacienteDetalle.historialMedico
                as List)
            .isNotEmpty
        ? (pacienteDetalle.historialMedico
                  as List)
              .first
              .fechaConsulta
              .toString()
        : 'sin historial reciente';
    final duenioNombre =
        (dueno !=
            null)
        ? (dueno.nombreCompleto)
        : '';
    return 'Mascota: ${mascota.nombre}\nRaza: ${mascota.raza}\nEspecie: ${mascota.especie}\nEdad aproximada: ${_calcAgeText(mascota.fechaNacimiento)}\nDueño: $duenioNombre\nVacunas aplicadas: ${vacunas.isNotEmpty ? vacunas : 'ninguna registrada'}\nAlergias: ${alergias.isNotEmpty ? alergias : 'ninguna registrada'}\nÚltima consulta: $ultimaConsulta';
  }

  String _calcAgeText(
    DateTime? nacimiento,
  ) {
    if (nacimiento ==
        null)
      return 'desconocida';
    final now = DateTime.now();
    final diff = now.difference(
      nacimiento,
    );
    final years =
        (diff.inDays /
                365)
            .floor();
    if (years >
        0)
      return '$years año(s)';
    final months =
        ((diff.inDays %
                    365) /
                30)
            .floor();
    if (months >
        0)
      return '$months mes(es)';
    return '${diff.inDays} día(s)';
  }

  String _localResponder(
    String prompt,
    pacienteDetalle,
  ) {
    // Respuesta simple basada en los datos disponibles
    if (pacienteDetalle ==
        null) {
      return 'Puedo ayudarte si me proporcionas el nombre de la mascota y, opcionalmente, alguna información adicional (raza, edad, síntomas).';
    }
    final mascota = pacienteDetalle.mascota;
    final vacunas =
        (pacienteDetalle.vacunas
                as List)
            .map(
              (
                v,
              ) =>
                  v.vacunaNombre ??
                  v.vacuna?.nombre ??
                  'vacuna',
            )
            .join(
              ', ',
            );
    final alergias =
        (pacienteDetalle.alergias
                as List)
            .map(
              (
                a,
              ) =>
                  a.alergiaNombre ??
                  a.alergia?.nombre ??
                  'alergia',
            )
            .join(
              ', ',
            );
    final buffer = StringBuffer();
    buffer.writeln(
      'Resumen de ${mascota.nombre}:',
    );
    buffer.writeln(
      '- Raza: ${mascota.raza}',
    );
    buffer.writeln(
      '- Edad aproximada: ${_calcAgeText(mascota.fechaNacimiento)}',
    );
    buffer.writeln(
      '- Vacunas: ${vacunas.isNotEmpty ? vacunas : 'ninguna registrada'}',
    );
    buffer.writeln(
      '- Alergias: ${alergias.isNotEmpty ? alergias : 'ninguna registrada'}',
    );
    buffer.writeln(
      '\nSi describes los síntomas podré darte sugerencias generales (no sustituyen al veterinario).',
    );
    return buffer.toString();
  }

  bool _looksLikeSymptoms(
    String text,
  ) {
    final s = text.toLowerCase();
    final keywords = [
      'fiebre',
      'vomito',
      'vómito',
      'vómitos',
      'vomitado',
      'diarrea',
      'tos',
      'letargo',
      'debilidad',
      'sangre',
      'sangrado',
      'desmay',
      'no come',
      'no come',
      'no come nada',
    ];
    for (var k in keywords) {
      if (s.contains(
        k,
      ))
        return true;
    }
    // also consider numeric vomiting counts like "5 veces"
    final vomMatch = RegExp(
      r'\b(\d{1,2})\s+veces\b',
    );
    if (vomMatch.hasMatch(
      s,
    ))
      return true;
    return false;
  }

  Future<
    void
  >
  _diagnoseWithoutPet(
    String userSymptoms,
  ) async {
    // Generar diagnóstico simple basado en reglas (sin LLM)
    String reply;
    try {
      reply = _localSymptomDiagnosis(
        userSymptoms,
      );
    } catch (
      e
    ) {
      reply = 'No pude generar un diagnóstico automático ahora. Intenta nuevamente o proporciona el nombre de la mascota para obtener su historial.';
      print(
        'Error in _diagnoseWithoutPet: $e',
      );
    }

    messages.add(
      ChatMessage(
        text: reply,
        isUser: false,
        senderName: 'VetSmart',
        avatarUrl: '',
      ),
    );
    setState(
      () {},
    );
  }

  String _localSymptomDiagnosis(
    String text,
  ) {
    final s = text.toLowerCase();
    final buffer = StringBuffer();
    buffer.writeln(
      'Posibles causas y recomendaciones (orientativo):',
    );
    if (s.contains(
          'fiebre',
        ) &&
        s.contains(
          'vomit',
        )) {
      buffer.writeln(
        '- Puede indicar infección (viral/bacteriana) o intoxicación alimentaria.',
      );
    } else if (s.contains(
      'vomit',
    )) {
      buffer.writeln(
        '- Vómitos repetidos pueden indicar gastroenteritis, ingestión de cuerpo extraño, intoxicación o problemas metabólicos.',
      );
    } else if (s.contains(
      'diarrea',
    )) {
      buffer.writeln(
        '- Diarrea puede ser por alimento, parásitos o infección. Vigila deshidratación.',
      );
    } else {
      buffer.writeln(
        '- Los síntomas descritos requieren observación; si hay empeoramiento acude al veterinario.',
      );
    }

    // signos de alarma
    buffer.writeln(
      '\nSignos de alarma (acudir urgente):',
    );
    buffer.writeln(
      '- Vómitos continuos (>4-6 veces en el día), sangre en vómito o heces, colapso, dificultad para respirar, convulsiones, deshidratación severa.',
    );

    buffer.writeln(
      '\nRecomendaciones iniciales:',
    );
    buffer.writeln(
      '- Retirar la comida por unas horas (4-8h) si el animal está vomitando mucho y luego ofrecer pequeñas cantidades de agua en intervalos.',
    );
    buffer.writeln(
      '- Si bebe poco o no puede retener líquidos, acude al veterinario (riesgo de deshidratación).',
    );
    buffer.writeln(
      '- No administrar medicamentos humanos sin indicación veterinaria.',
    );
    buffer.writeln(
      '- Si sospechas ingestión de tóxicos, busca atención inmediata.',
    );

    buffer.writeln(
      '\nSi quieres, dime el nombre de la mascota para revisar su historial y adaptar el diagnóstico.',
    );
    return buffer.toString();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 56,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
          ),
          onPressed: () => context.pop(),
          color: AppColors.textLight,
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
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(
                16.0,
              ),
              itemCount: messages.length,
              itemBuilder:
                  (
                    context,
                    index,
                  ) {
                    return Padding(
                      padding: const EdgeInsets.only(
                        bottom: 24.0,
                      ),
                      child: _MessageBubble(
                        message: messages[index],
                      ),
                    );
                  },
            ),
          ),
          // Entrada
          Container(
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.surface,
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
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: _awaitingPetName
                          ? 'Introduce el nombre de la mascota'
                          : 'Escribe tu mensaje...',
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
                    ),
                    minLines: 1,
                    maxLines: 4,
                    onSubmitted:
                        (
                          v,
                        ) => _handleSend(
                          v,
                        ),
                    style: TextStyle(
                      color: AppColors.textLight,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Container(
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(
                      context,
                    ).colorScheme.primary,
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.send,
                    ),
                    color: AppColors.textLight,
                    onPressed: () => _handleSend(
                      _controller.text,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const UserNavbar(
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
