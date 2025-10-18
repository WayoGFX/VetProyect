// lib/models/paciente_models.dart

class Paciente {
  final String nombre;
  final String razaEdad;
  final String fotoUrl;
  final List<
    Vacuna
  >
  vacunas;
  final List<
    Alergia
  >
  alergias;
  final List<
    Cita
  >
  proximasCitas;
  final List<
    Cita
  >
  citasAnteriores;

  const Paciente({
    required this.nombre,
    required this.razaEdad,
    required this.fotoUrl,
    required this.vacunas,
    required this.alergias,
    required this.proximasCitas,
    required this.citasAnteriores,
  });
}

class Alergia {
  final String nombre;
  final String detalle;

  const Alergia({
    required this.nombre,
    this.detalle = '',
  });
}

class Vacuna {
  final String nombre;
  final String fecha;

  const Vacuna({
    required this.nombre,
    required this.fecha,
  });
}

class Cita {
  final String motivo;
  final String doctor;
  final String fecha;
  final String detalleTiempo;
  final bool isUpcoming;

  const Cita({
    required this.motivo,
    required this.doctor,
    required this.fecha,
    required this.detalleTiempo,
    this.isUpcoming = false,
  });
}

// Datos de ejemplo
final Paciente
maxData = Paciente(
  nombre: 'Max',
  razaEdad: 'Golden Retriever, 3 años',
  fotoUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBQWtZBWDo8FaFdszSnQZ1A1sz5LOz27ekmfaJiFeaWWld8DosqR5HWTG7CvKd4SHkqf6U8NupB41JAewX6eU_jCFIazCf65dfH6DDo9EFPSgG4aSRkGE6qgRgS4qKcvGe4w42QS3VflJqm3AULCJRs5FVofXS6N36V9uAPOCyLWv946ROYgj1GFZEHkMsBsbeL5Gozo_sJZhsDSa06_dctXmhwnswjjg_m_XDaBbditOqYMxpXn7OTjIZYLjFSAPo5K45EkcVGrjk', // URL de ejemplo
  alergias: const [
    Alergia(
      nombre: 'Polen',
      detalle: 'Ambiental',
    ),
    Alergia(
      nombre: 'Pollo',
      detalle: 'Alimentaria',
    ),
  ],
  vacunas: const [
    Vacuna(
      nombre: 'Rabia',
      fecha: '20/01/2023',
    ),
    Vacuna(
      nombre: 'Parvovirus',
      fecha: '15/05/2023',
    ),
    Vacuna(
      nombre: 'Moquillo',
      fecha: '15/05/2023',
    ),
  ],
  proximasCitas: const [
    Cita(
      motivo: 'Revisión Anual',
      doctor: 'Dr. Villalobos',
      fecha: '25/10/2024',
      detalleTiempo: '10:00 AM',
      isUpcoming: true,
    ),
    Cita(
      motivo: 'Vacunación',
      doctor: 'Dra. Costa',
      fecha: '15/11/2024',
      detalleTiempo: '11:30 AM',
      isUpcoming: true,
    ),
  ],
  citasAnteriores: const [
    Cita(
      motivo: 'Consulta por cojera',
      doctor: 'Dr. Villalobos',
      fecha: '12/07/2024',
      detalleTiempo: 'Completa',
    ),
    Cita(
      motivo: 'Vacuna Rabia',
      doctor: 'Dra. Costa',
      fecha: '20/01/2023',
      detalleTiempo: 'Completa',
    ),
  ],
);
