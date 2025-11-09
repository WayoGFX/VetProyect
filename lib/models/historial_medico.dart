class HistorialMedico {
  final int? historialId;
  final int mascotaId;
  final int veterinarioId;
  final int usuarioId;
  final String diagnostico;
  final String tratamiento;
  final String? notasAdicionales;
  final DateTime fechaConsulta;

  HistorialMedico({
    this.historialId,
    required this.mascotaId,
    required this.veterinarioId,
    required this.usuarioId,
    required this.diagnostico,
    required this.tratamiento,
    this.notasAdicionales,
    required this.fechaConsulta,
  });

  // Desde JSON (respuesta de la API)
  factory HistorialMedico.fromJson(Map<String, dynamic> json) {
    return HistorialMedico(
      historialId: json['historialId'],
      mascotaId: json['mascotaId'],
      veterinarioId: json['veterinarioId'],
      usuarioId: json['usuarioId'],
      diagnostico: json['diagnostico'],
      tratamiento: json['tratamiento'],
      notasAdicionales: json['notasAdicionales'],
      fechaConsulta: DateTime.parse(json['fechaConsulta']),
    );
  }

  // A JSON (para enviar a la API)
  Map<String, dynamic> toJson() {
    return {
      if (historialId != null) 'historialId': historialId,
      'mascotaId': mascotaId,
      'veterinarioId': veterinarioId,
      'usuarioId': usuarioId,
      'diagnostico': diagnostico,
      'tratamiento': tratamiento,
      if (notasAdicionales != null) 'notasAdicionales': notasAdicionales,
      'fechaConsulta': fechaConsulta.toIso8601String(),
    };
  }
}
