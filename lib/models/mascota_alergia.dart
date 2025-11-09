class MascotaAlergia {
  final int? mascotaAlergiaId;
  final int mascotaId;
  final int alergiaId;
  final String? notas;

  MascotaAlergia({
    this.mascotaAlergiaId,
    required this.mascotaId,
    required this.alergiaId,
    this.notas,
  });

  // Desde JSON (respuesta de la API)
  factory MascotaAlergia.fromJson(Map<String, dynamic> json) {
    return MascotaAlergia(
      mascotaAlergiaId: json['mascotaAlergiaId'],
      mascotaId: json['mascotaId'],
      alergiaId: json['alergiaId'],
      notas: json['notas'],
    );
  }

  // A JSON (para enviar a la API)
  Map<String, dynamic> toJson() {
    return {
      if (mascotaAlergiaId != null) 'mascotaAlergiaId': mascotaAlergiaId,
      'mascotaId': mascotaId,
      'alergiaId': alergiaId,
      if (notas != null) 'notas': notas,
    };
  }
}
