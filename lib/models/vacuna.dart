class Vacuna {
  final int? vacunaId;
  final String nombre;
  final String descripcion;

  Vacuna({
    this.vacunaId,
    required this.nombre,
    required this.descripcion,
  });

  // Desde JSON (respuesta de la API)
  factory Vacuna.fromJson(Map<String, dynamic> json) {
    return Vacuna(
      vacunaId: json['vacunaId'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
    );
  }

  // A JSON (para enviar a la API)
  Map<String, dynamic> toJson() {
    return {
      if (vacunaId != null) 'vacunaId': vacunaId,
      'nombre': nombre,
      'descripcion': descripcion,
    };
  }
}
