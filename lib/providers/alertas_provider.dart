import 'package:flutter/material.dart';
import 'package:vet_smart_ids/services/api_service.dart';

class AlertaModel {
  final String id;
  final String titulo;
  final String subtitulo;
  final IconData icono;
  final Color color;
  final DateTime fecha;
  final String tipo; // 'cita', 'pendiente'

  AlertaModel({
    required this.id,
    required this.titulo,
    required this.subtitulo,
    required this.icono,
    required this.color,
    required this.fecha,
    required this.tipo,
  });
}

class AlertasProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<AlertaModel> _alertas = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<AlertaModel> get alertas => _alertas;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Cargar todas las alertas
  Future<void> loadAlertas() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final alertas = <AlertaModel>[];

      // Obtener citas próximas (próximos 7 días)
      final citas = await _apiService.getCitas();
      final ahora = DateTime.now();
      final en7Dias = ahora.add(const Duration(days: 7));

      for (var cita in citas) {
        if (cita.fechaHora.isAfter(ahora) && cita.fechaHora.isBefore(en7Dias)) {
          alertas.add(
            AlertaModel(
              id: 'cita_${cita.citaId}',
              titulo: 'Cita próxima: ${cita.mascotaNombre}',
              subtitulo: _formatearFecha(cita.fechaHora),
              icono: Icons.calendar_today,
              color: const Color(0xFF4A90E2),
              fecha: cita.fechaHora,
              tipo: 'cita',
            ),
          );
        }
      }

      // Ordenar alertas por fecha
      alertas.sort((a, b) => a.fecha.compareTo(b.fecha));
      
      // Limitar a las primeras 5 alertas
      _alertas = alertas.take(5).toList();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      print('Error al cargar alertas: $e');
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Formatear fecha para mostrar en alertas
  String _formatearFecha(DateTime fecha) {
    final ahora = DateTime.now();
    final diferencia = fecha.difference(ahora);

    if (diferencia.inDays == 0) {
      return 'Hoy a las ${fecha.hour.toString().padLeft(2, '0')}:${fecha.minute.toString().padLeft(2, '0')}';
    } else if (diferencia.inDays == 1) {
      return 'Mañana a las ${fecha.hour.toString().padLeft(2, '0')}:${fecha.minute.toString().padLeft(2, '0')}';
    } else if (diferencia.inDays <= 7) {
      return 'En ${diferencia.inDays} días';
    } else {
      return '${fecha.day}/${fecha.month}/${fecha.year}';
    }
  }
}
