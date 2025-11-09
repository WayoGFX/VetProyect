class Veterinario {
  final int? veterinarioId;
  final String nombreCompleto;
  final String email;
  final String passwordHash;
  final String telefono;
  final String especialidad;
  final String? fotoUrl;

  Veterinario({
    this.veterinarioId,
    required this.nombreCompleto,
    required this.email,
    required this.passwordHash,
    required this.telefono,
    required this.especialidad,
    this.fotoUrl,
  });

  // Desde JSON (respuesta de la API)
  factory Veterinario.fromJson(Map<String, dynamic> json) {
    return Veterinario(
      veterinarioId: json['veterinarioId'],
      nombreCompleto: json['nombreCompleto'],
      email: json['email'],
      passwordHash: json['passwordHash'],
      telefono: json['telefono'],
      especialidad: json['especialidad'],
      fotoUrl: json['fotoUrl'],
    );
  }

  // A JSON (para enviar a la API)
  Map<String, dynamic> toJson() {
    return {
      if (veterinarioId != null) 'veterinarioId': veterinarioId,
      'nombreCompleto': nombreCompleto,
      'email': email,
      'passwordHash': passwordHash,
      'telefono': telefono,
      'especialidad': especialidad,
      if (fotoUrl != null) 'fotoUrl': fotoUrl,
    };
  }
}
