class Mascota {
  final int? mascotaId;
  final int usuarioId;
  final String nombre;
  final String especie;
  final String raza;
  final DateTime fechaNacimiento;
  final String? fotoUrl;
  final String? observaciones;

  Mascota({
    this.mascotaId,
    required this.usuarioId,
    required this.nombre,
    required this.especie,
    required this.raza,
    required this.fechaNacimiento,
    this.fotoUrl,
    this.observaciones,
  });

  // Desde JSON (respuesta de la API)
  factory Mascota.fromJson(Map<String, dynamic> json) {
    return Mascota(
      mascotaId: json['mascotaId'],
      usuarioId: json['usuarioId'],
      nombre: json['nombre'],
      especie: json['especie'],
      raza: json['raza'],
      fechaNacimiento: DateTime.parse(json['fechaNacimiento']),
      fotoUrl: json['fotoUrl'],
      observaciones: json['observaciones'],
    );
  }

  // A JSON (para enviar a la API)
  Map<String, dynamic> toJson() {
    return {
      if (mascotaId != null) 'mascotaId': mascotaId,
      'usuarioId': usuarioId,
      'nombre': nombre,
      'especie': especie,
      'raza': raza,
      'fechaNacimiento': fechaNacimiento.toIso8601String().split('T')[0], // Solo fecha
      if (fotoUrl != null) 'fotoUrl': fotoUrl,
      if (observaciones != null) 'observaciones': observaciones,
    };
  }
}
