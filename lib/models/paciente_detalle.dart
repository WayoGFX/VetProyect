import 'package:vet_smart_ids/models/mascota.dart';
import 'package:vet_smart_ids/models/usuario.dart';
import 'package:vet_smart_ids/models/alergia.dart';
import 'package:vet_smart_ids/models/vacuna.dart';
import 'package:vet_smart_ids/models/mascota_vacuna.dart';
import 'package:vet_smart_ids/models/mascota_alergia.dart';
import 'package:vet_smart_ids/models/historial_medico.dart';
import 'package:vet_smart_ids/models/cita.dart';

/// Modelo completo para mostrar en la ficha del paciente
class PacienteDetalle {
  final Mascota mascota;
  final Usuario dueno;
  final List<VacunaAplicada> vacunas;
  final List<AlergiaDetalle> alergias;
  final List<Cita> proximasCitas;
  final List<Cita> citasAnteriores;
  final List<HistorialMedico> historialMedico;

  PacienteDetalle({
    required this.mascota,
    required this.dueno,
    required this.vacunas,
    required this.alergias,
    required this.proximasCitas,
    required this.citasAnteriores,
    required this.historialMedico,
  });

  /// Getter para mostrar raza y edad formateada
  String get razaEdad {
    final edad = _calcularEdad(mascota.fechaNacimiento);
    return '${mascota.raza}, $edad';
  }

  String _calcularEdad(DateTime fechaNacimiento) {
    final ahora = DateTime.now();
    final diferencia = ahora.difference(fechaNacimiento);
    final anos = (diferencia.inDays / 365).floor();
    final meses = ((diferencia.inDays % 365) / 30).floor();

    if (anos > 0) {
      return meses > 0 ? '$anos años, $meses meses' : '$anos ${anos == 1 ? 'año' : 'años'}';
    } else if (meses > 0) {
      return '$meses ${meses == 1 ? 'mes' : 'meses'}';
    } else {
      final dias = diferencia.inDays;
      return '$dias ${dias == 1 ? 'día' : 'días'}';
    }
  }
}

/// Vacuna con información de aplicación
class VacunaAplicada {
  final Vacuna vacuna;
  final DateTime fechaAplicacion;
  final String lote;

  VacunaAplicada({
    required this.vacuna,
    required this.fechaAplicacion,
    required this.lote,
  });

  factory VacunaAplicada.fromMascotaVacuna(
    MascotaVacuna mascotaVacuna,
    Vacuna vacuna,
  ) {
    return VacunaAplicada(
      vacuna: vacuna,
      fechaAplicacion: mascotaVacuna.fechaAplicacion,
      lote: mascotaVacuna.lote,
    );
  }

  String get fechaFormateada {
    return '${fechaAplicacion.day.toString().padLeft(2, '0')}/${fechaAplicacion.month.toString().padLeft(2, '0')}/${fechaAplicacion.year}';
  }
}

/// Alergia con notas adicionales
class AlergiaDetalle {
  final Alergia alergia;
  final String? notas;

  AlergiaDetalle({
    required this.alergia,
    this.notas,
  });

  factory AlergiaDetalle.fromMascotaAlergia(
    MascotaAlergia mascotaAlergia,
    Alergia alergia,
  ) {
    return AlergiaDetalle(
      alergia: alergia,
      notas: mascotaAlergia.notas,
    );
  }

  String get detalle => notas?.isNotEmpty == true ? notas! : alergia.tipo;
}
