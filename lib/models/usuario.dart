class Usuario {
  final int? usuarioId;
  final String nombreCompleto;
  final String email;
  final String passwordHash;
  final String telefono;
  final String direccion;
  final DateTime? fechaRegistro;

  Usuario({
    this.usuarioId,
    required this.nombreCompleto,
    required this.email,
    required this.passwordHash,
    required this.telefono,
    required this.direccion,
    this.fechaRegistro,
  });

  // Desde JSON (respuesta de la API)
  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      usuarioId: json['usuarioId'],
      nombreCompleto: json['nombreCompleto'],
      email: json['email'],
      passwordHash: json['passwordHash'],
      telefono: json['telefono'],
      direccion: json['direccion'],
      fechaRegistro: json['fechaRegistro'] != null
          ? DateTime.parse(json['fechaRegistro'])
          : null,
    );
  }

  // A JSON (para enviar a la API)
  Map<String, dynamic> toJson() {
    return {
      if (usuarioId != null) 'usuarioId': usuarioId,
      'nombreCompleto': nombreCompleto,
      'email': email,
      'passwordHash': passwordHash,
      'telefono': telefono,
      'direccion': direccion,
      if (fechaRegistro != null) 'fechaRegistro': fechaRegistro!.toIso8601String(),
    };
  }
}
