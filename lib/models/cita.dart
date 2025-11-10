class Cita {
  final int? citaId;
  final int? mascotaId;
  final String? mascotaNombre;
  final String? mascotaFotoUrl;
  final int? usuarioId;
  final String? usuarioNombre;
  final int? veterinarioId;
  final String? veterinarioNombre;
  final DateTime fechaHora;
  final String motivo;
  final String? citaDescripcion;
  final String? notas;
  final String estado;

  Cita({
    this.citaId,
    this.mascotaId,
    this.mascotaNombre,
    this.mascotaFotoUrl,
    this.usuarioId,
    this.usuarioNombre,
    this.veterinarioId,
    this.veterinarioNombre,
    required this.fechaHora,
    required this.motivo,
    this.citaDescripcion,
    this.notas,
    required this.estado,
  });

  // Desde JSON (respuesta de la API)
  // Soporta ambos formatos: lista (GET /api/Citas) y detalle (GET /api/Citas/{id})
  factory Cita.fromJson(Map<String, dynamic> json) {
    return Cita(
      citaId: json['citaId'],
      mascotaId: json['mascotaId'],
      mascotaNombre: json['mascotaNombre'],
      mascotaFotoUrl: json['mascotaFotoUrl'],
      usuarioId: json['usuarioId'],
      usuarioNombre: json['usuarioNombre'],
      veterinarioId: json['veterinarioId'],
      veterinarioNombre: json['veterinarioNombre'],
      fechaHora: DateTime.parse(json['fechaHora']),
      motivo: json['motivo'] ?? '',
      citaDescripcion: json['citaDescripcion'],
      notas: json['notas'],
      estado: json['estado'] ?? 'Pendiente',
    );
  }

  // A JSON (para enviar a la API - POST/PUT)
  Map<String, dynamic> toJson() {
    return {
      if (mascotaId != null) 'mascotaId': mascotaId,
      if (usuarioId != null) 'usuarioId': usuarioId,
      if (veterinarioId != null) 'veterinarioId': veterinarioId,
      'fechaHora': fechaHora.toIso8601String(),
      'motivo': motivo,
      if (citaDescripcion != null) 'citaDescripcion': citaDescripcion,
      if (notas != null) 'notas': notas,
      'estado': estado,
    };
  }

  // Para actualizar (PUT) - solo envía campos editables
  Map<String, dynamic> toJsonUpdate() {
    return {
      'fechaHora': fechaHora.toIso8601String(),
      'motivo': motivo,
      if (citaDescripcion != null) 'citaDescripcion': citaDescripcion,
      if (notas != null) 'notas': notas,
      'estado': estado,
    };
  }
}
