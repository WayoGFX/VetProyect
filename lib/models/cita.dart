class Cita {
  final int? citaId;
  final int mascotaId;
  final int usuarioId;
  final int veterinarioId;
  final DateTime fechaHora;
  final String motivo;
  final String citaDescripcion;
  final String? notas;
  final String estado;

  Cita({
    this.citaId,
    required this.mascotaId,
    required this.usuarioId,
    required this.veterinarioId,
    required this.fechaHora,
    required this.motivo,
    required this.citaDescripcion,
    this.notas,
    required this.estado,
  });

  // Desde JSON (respuesta de la API)
  factory Cita.fromJson(Map<String, dynamic> json) {
    return Cita(
      citaId: json['citaId'],
      mascotaId: json['mascotaId'],
      usuarioId: json['usuarioId'],
      veterinarioId: json['veterinarioId'],
      fechaHora: DateTime.parse(json['fechaHora']),
      motivo: json['motivo'],
      citaDescripcion: json['citaDescripcion'],
      notas: json['notas'],
      estado: json['estado'],
    );
  }

  // A JSON (para enviar a la API)
  Map<String, dynamic> toJson() {
    return {
      if (citaId != null) 'citaId': citaId,
      'mascotaId': mascotaId,
      'usuarioId': usuarioId,
      'veterinarioId': veterinarioId,
      'fechaHora': fechaHora.toIso8601String(),
      'motivo': motivo,
      'citaDescripcion': citaDescripcion,
      if (notas != null) 'notas': notas,
      'estado': estado,
    };
  }
}
