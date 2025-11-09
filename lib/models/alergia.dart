class Alergia {
  final int? alergiaId;
  final String nombre;
  final String tipo;

  Alergia({
    this.alergiaId,
    required this.nombre,
    required this.tipo,
  });

  // Desde JSON (respuesta de la API)
  factory Alergia.fromJson(Map<String, dynamic> json) {
    return Alergia(
      alergiaId: json['alergiaId'],
      nombre: json['nombre'],
      tipo: json['tipo'],
    );
  }

  // A JSON (para enviar a la API)
  Map<String, dynamic> toJson() {
    return {
      if (alergiaId != null) 'alergiaId': alergiaId,
      'nombre': nombre,
      'tipo': tipo,
    };
  }
}
