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
          _awaitingPetName = false; // Mascota seleccionada, ya no esperar más nombres
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

      // Mascota cargada exitosamente, ya no esperar más nombres
      _awaitingPetName = false;

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
                  (v.vacuna?.nombre ??
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
                  (a.alergia?.nombre ??
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
    final promptLower = prompt.toLowerCase();

    // Respuestas a preguntas comunes
    if (_matchesKeywords(promptLower, ['hola', 'buenos días', 'buenas tardes', 'buenas noches', 'hey', 'hi'])) {
      return '¡Hola! Soy el asistente de VetSmart. Puedo ayudarte con información sobre tu mascota, síntomas comunes, cuidados básicos y más. ¿En qué puedo ayudarte?';
    }

    if (_matchesKeywords(promptLower, ['gracias', 'muchas gracias', 'thank you'])) {
      return '¡De nada! Si necesitas algo más, no dudes en preguntar. Estoy aquí para ayudarte con tus mascotas.';
    }

    if (_matchesKeywords(promptLower, ['adiós', 'adios', 'hasta luego', 'chao', 'bye'])) {
      return 'Hasta luego! Cuida bien de tu mascota. Recuerda que siempre puedes volver si necesitas ayuda.';
    }

    // Preguntas sobre vacunas
    if (_matchesKeywords(promptLower, ['vacuna', 'vacunas', 'inmunización', 'calendario de vacunación'])) {
      if (pacienteDetalle != null) {
        final mascota = pacienteDetalle.mascota;
        final vacunas = (pacienteDetalle.vacunas as List)
            .map((v) => '${v.vacuna?.nombre ?? 'Vacuna'} (${_formatDate(v.fechaAplicacion)})')
            .join('\n  • ');

        if (vacunas.isNotEmpty) {
          return 'Vacunas aplicadas a ${mascota.nombre}:\n  • $vacunas\n\nEs importante mantener el calendario de vacunación al día. Consulta con tu veterinario sobre las próximas dosis.';
        } else {
          return '${mascota.nombre} no tiene vacunas registradas aún. Es muy importante vacunar a tu mascota para prevenir enfermedades. Consulta con tu veterinario sobre el calendario de vacunación recomendado.';
        }
      }
      return 'Las vacunas son esenciales para proteger a tu mascota de enfermedades graves. Cada especie tiene un calendario específico. Para ver las vacunas de tu mascota, dime su nombre primero.';
    }

    // Preguntas sobre alergias
    if (_matchesKeywords(promptLower, ['alergia', 'alergias', 'alérgico', 'reacción alérgica'])) {
      if (pacienteDetalle != null) {
        final mascota = pacienteDetalle.mascota;
        final alergias = (pacienteDetalle.alergias as List)
            .map((a) => '${a.alergia?.nombre ?? 'Alergia'} - Tipo: ${a.alergia?.tipo ?? 'N/A'}${a.notas != null ? '\n    Notas: ${a.notas}' : ''}')
            .join('\n  • ');

        if (alergias.isNotEmpty) {
          return 'Alergias registradas de ${mascota.nombre}:\n  • $alergias\n\nEvita el contacto con estos alérgenos y consulta con tu veterinario si notas síntomas como picazón, enrojecimiento o problemas respiratorios.';
        } else {
          return '${mascota.nombre} no tiene alergias registradas. Si notas síntomas como picazón excesiva, enrojecimiento, problemas respiratorios o digestivos, consulta con tu veterinario.';
        }
      }
      return 'Las alergias en mascotas pueden manifestarse de varias formas: picazón, enrojecimiento, problemas digestivos, etc. Para ver las alergias registradas, dime el nombre de tu mascota.';
    }

    // Preguntas sobre citas
    if (_matchesKeywords(promptLower, ['cita', 'citas', 'consulta', 'consultas', 'agendar', 'próxima cita'])) {
      if (pacienteDetalle != null) {
        final mascota = pacienteDetalle.mascota;
        final proximasCitas = (pacienteDetalle.proximasCitas as List);

        if (proximasCitas.isNotEmpty) {
          final citasTexto = proximasCitas.take(3).map((c) =>
            '${c.motivo} - ${_formatDateTime(c.fechaHora)}'
          ).join('\n  • ');
          return 'Próximas citas de ${mascota.nombre}:\n  • $citasTexto\n\nRecuerda llegar unos minutos antes. Puedes ver más detalles en la sección de citas de la app.';
        } else {
          return '${mascota.nombre} no tiene citas programadas. Puedes agendar una nueva cita desde la app o contactando a tu veterinario.';
        }
      }
      return 'Puedes agendar citas para tu mascota desde la aplicación. Para ver las citas programadas, dime el nombre de tu mascota.';
    }

    // Preguntas sobre alimentación
    if (_matchesKeywords(promptLower, ['comida', 'alimento', 'alimentación', 'comer', 'dieta', 'nutrición'])) {
      if (pacienteDetalle != null) {
        final mascota = pacienteDetalle.mascota;
        final especie = mascota.especie.toLowerCase();

        if (especie.contains('perro')) {
          return 'Alimentación para ${mascota.nombre}:\n\nPerros necesitan:\n• Comida balanceada específica para su edad y tamaño\n• Agua fresca disponible siempre\n• 2-3 comidas al día (adultos)\n• Evitar: chocolate, uvas, cebolla, ajo, alimentos con xilitol\n\nConsulta con tu veterinario sobre la cantidad adecuada según el peso y actividad de ${mascota.nombre}.';
        } else if (especie.contains('gato')) {
          return 'Alimentación para ${mascota.nombre}:\n\nGatos necesitan:\n• Comida de alta calidad rica en proteína animal\n• Agua fresca siempre disponible\n• 2-4 comidas pequeñas al día\n• Evitar: lácteos, atún en exceso, cebolla, ajo\n\nLos gatos son carnívoros obligados. Consulta con tu veterinario sobre la dieta ideal para ${mascota.nombre}.';
        }
        return 'Para ${mascota.nombre}, te recomiendo consultar con tu veterinario sobre la dieta más adecuada según su especie, edad, peso y nivel de actividad.';
      }
      return 'La alimentación adecuada es clave para la salud de tu mascota. Cada especie y etapa de vida requiere diferentes nutrientes. ¿Sobre qué mascota quieres saber?';
    }

    // Preguntas sobre ejercicio
    if (_matchesKeywords(promptLower, ['ejercicio', 'paseo', 'pasear', 'actividad física', 'jugar', 'juego'])) {
      if (pacienteDetalle != null) {
        final mascota = pacienteDetalle.mascota;
        final especie = mascota.especie.toLowerCase();

        if (especie.contains('perro')) {
          return 'Ejercicio para ${mascota.nombre}:\n\n• Paseos diarios: al menos 30-60 minutos\n• Juegos interactivos: buscar, tira y afloja\n• Socialización con otros perros\n• Adapta la intensidad a su edad y raza\n\nEl ejercicio regular previene obesidad, mejora el comportamiento y fortalece el vínculo contigo.';
        } else if (especie.contains('gato')) {
          return 'Ejercicio para ${mascota.nombre}:\n\n• Juegos con juguetes interactivos\n• Rascadores y árboles para gatos\n• Sesiones de juego de 10-15 min varias veces al día\n• Enriquecimiento ambiental (cajas, escondites)\n\nLos gatos necesitan estimulación mental y física, especialmente si viven en interior.';
        }
        return 'El ejercicio es importante para ${mascota.nombre}. Consulta con tu veterinario sobre la cantidad y tipo de actividad recomendada.';
      }
      return 'El ejercicio regular es esencial para la salud física y mental de las mascotas. ¿Sobre qué mascota quieres información?';
    }

    // Preguntas sobre baño/higiene
    if (_matchesKeywords(promptLower, ['baño', 'bañar', 'higiene', 'aseo', 'limpiar', 'limpieza', 'peinar'])) {
      if (pacienteDetalle != null) {
        final mascota = pacienteDetalle.mascota;
        final especie = mascota.especie.toLowerCase();

        if (especie.contains('perro')) {
          return 'Higiene para ${mascota.nombre}:\n\n• Baño: cada 1-3 meses (según actividad)\n• Cepillado: diario o semanal según el pelaje\n• Uñas: cortar cada 1-2 meses\n• Dientes: cepillar 2-3 veces por semana\n• Oídos: revisar y limpiar semanalmente\n\nUsa productos específicos para perros. El exceso de baños puede resecar la piel.';
        } else if (especie.contains('gato')) {
          return 'Higiene para ${mascota.nombre}:\n\n• Los gatos se asean solos, baño solo si es necesario\n• Cepillado: diario (pelo largo) o semanal (pelo corto)\n• Uñas: proporcionar rascador, cortar si es necesario\n• Dientes: cepillar 2-3 veces por semana\n• Oídos: revisar semanalmente\n\nEvita bañar a tu gato frecuentemente a menos que sea necesario.';
        }
        return 'La higiene adecuada mantiene a ${mascota.nombre} saludable. Consulta con tu veterinario sobre rutinas específicas.';
      }
      return 'El cuidado e higiene varía según la especie y tipo de pelaje. ¿De qué mascota quieres saber?';
    }

    // Preguntas sobre comportamiento
    if (_matchesKeywords(promptLower, ['comportamiento', 'conducta', 'agresivo', 'miedo', 'ansiedad', 'ladra', 'maúlla', 'destructivo'])) {
      return 'Problemas de comportamiento:\n\n• Pueden indicar estrés, miedo, aburrimiento o problemas de salud\n• Identificar la causa es clave para solucionarlo\n• Considera: cambios recientes, rutina, ejercicio, estimulación\n• El refuerzo positivo es más efectivo que el castigo\n\nSi el problema persiste o empeora, consulta con un veterinario o etólogo (especialista en comportamiento animal).';
    }

    // Preguntas sobre edad
    if (_matchesKeywords(promptLower, ['edad', 'años', 'viejo', 'cachorro', 'adulto', 'senior'])) {
      if (pacienteDetalle != null) {
        final mascota = pacienteDetalle.mascota;
        final edadTexto = _calcAgeText(mascota.fechaNacimiento);
        return '${mascota.nombre} tiene ${edadTexto}.\n\nCada etapa de vida requiere cuidados específicos:\n• Cachorro/gatito: más vacunas, socialización\n• Adulto: mantenimiento, prevención\n• Senior: chequeos más frecuentes, dieta especial\n\nConsulta con tu veterinario sobre los cuidados según la edad.';
      }
      return 'Dime el nombre de tu mascota y te diré su edad y los cuidados recomendados para su etapa de vida.';
    }

    // Información general si no hay detalle
    if (pacienteDetalle == null) {
      return 'Puedo ayudarte con:\n• Información sobre vacunas y alergias\n• Consejos sobre alimentación y ejercicio\n• Cuidados e higiene\n• Síntomas y cuándo acudir al veterinario\n\nPara darte información específica, dime el nombre de tu mascota.';
    }

    // Respuesta por defecto con información de la mascota
    final mascota = pacienteDetalle.mascota;
    final vacunas =
        (pacienteDetalle.vacunas
                as List)
            .map(
              (
                v,
              ) =>
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
      '\nPregúntame sobre vacunas, alergias, citas, alimentación, ejercicio o describe síntomas para sugerencias.',
    );
    return buffer.toString();
  }

  bool _matchesKeywords(String text, List<String> keywords) {
    return keywords.any((keyword) => text.contains(keyword));
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  String _formatDateTime(DateTime date) {
    final hour = date.hour > 12 ? date.hour - 12 : (date.hour == 0 ? 12 : date.hour);
    final period = date.hour >= 12 ? 'PM' : 'AM';
    return '${date.day}/${date.month}/${date.year} ${hour}:${date.minute.toString().padLeft(2, '0')} $period';
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
