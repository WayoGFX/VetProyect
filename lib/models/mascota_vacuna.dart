class MascotaVacuna {
  final int? mascotaVacunaId;
  final int mascotaId;
  final int vacunaId;
  final DateTime fechaAplicacion;
  final String lote;

  MascotaVacuna({
    this.mascotaVacunaId,
    required this.mascotaId,
    required this.vacunaId,
    required this.fechaAplicacion,
    required this.lote,
  });

  // Desde JSON (respuesta de la API)
  factory MascotaVacuna.fromJson(Map<String, dynamic> json) {
    return MascotaVacuna(
      mascotaVacunaId: json['mascotaVacunaId'],
      mascotaId: json['mascotaId'],
      vacunaId: json['vacunaId'],
      fechaAplicacion: DateTime.parse(json['fechaAplicacion']),
      lote: json['lote'],
    );
  }

  // A JSON (para enviar a la API)
  Map<String, dynamic> toJson() {
    return {
      if (mascotaVacunaId != null) 'mascotaVacunaId': mascotaVacunaId,
      'mascotaId': mascotaId,
      'vacunaId': vacunaId,
      'fechaAplicacion': fechaAplicacion.toIso8601String(),
      'lote': lote,
    };
  }
}
