import 'package:flutter/material.dart';
import 'package:vet_smart_ids/services/api_service.dart';

class EstadisticasProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  // Tipos de animales
  Map<String, double> _tiposAnimales = {};
  Map<String, Color> _tiposAnimalesColors = {};
  
  // Enfermedades comunes
  Map<String, double> _enfermedadesComunes = {};
  Map<String, Color> _enfermedadesColores = {};

  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  Map<String, double> get tiposAnimales => _tiposAnimales;
  Map<String, Color> get tiposAnimalesColors => _tiposAnimalesColors;
  Map<String, double> get enfermedadesComunes => _enfermedadesComunes;
  Map<String, Color> get enfermedadesColores => _enfermedadesColores;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Cargar todas las estadísticas
  Future<void> loadEstadisticas() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Obtener todas las mascotas para calcular estadísticas de tipos
      final mascotas = await _apiService.getMascotas();
      _calcularTiposAnimales(mascotas);

      // Obtener historiales médicos para calcular enfermedades comunes
      final historiales = await _apiService.getHistorialesMedicos();
      _calcularEnfermedadesComunes(historiales);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      print('Error al cargar estadísticas: $e');
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Calcular tipos de animales basados en mascotas
  void _calcularTiposAnimales(List<dynamic> mascotas) {
    final tipoCount = <String, int>{};

    // Contar por especie de mascota
    for (var mascota in mascotas) {
      final especie = mascota.especie ?? 'Otros';
      tipoCount[especie] = (tipoCount[especie] ?? 0) + 1;
    }

    // Convertir a porcentajes
    final total = tipoCount.values.fold<int>(0, (sum, count) => sum + count);
    _tiposAnimales = {};
    tipoCount.forEach((tipo, count) {
      _tiposAnimales[tipo] = count / total;
    });

    // Asignar colores
    final coloresDisponibles = {
      'Perros': const Color(0xFFFFDDC1),
      'Gatos': const Color(0xFFC1FFD7),
      'Aves': const Color(0xFFD1C1FF),
      'Roedores': const Color(0xFFFFC1E3),
      'Otros': const Color(0xFFC1EFFF),
    };

    _tiposAnimalesColors = {};
    _tiposAnimales.forEach((tipo, _) {
      _tiposAnimalesColors[tipo] =
          coloresDisponibles[tipo] ?? const Color(0xFFC1EFFF);
    });
  }

  /// Calcular enfermedades comunes basadas en diagnósticos del historial
  void _calcularEnfermedadesComunes(List<dynamic> historiales) {
    if (historiales.isEmpty) {
      // Si no hay historiales, usar datos por defecto
      _enfermedadesComunes = {
        'Problemas de Piel': 0.35,
        'Problemas Digestivos': 0.25,
        'Alergias': 0.20,
        'Problemas Respiratorios': 0.15,
        'Otros': 0.05,
      };
      
      _enfermedadesColores = {
        'Problemas de Piel': const Color(0xFFFFDDC1),
        'Problemas Digestivos': const Color(0xFFC1FFD7),
        'Alergias': const Color(0xFFD1C1FF),
        'Problemas Respiratorios': const Color(0xFFFFC1E3),
        'Otros': const Color(0xFFC1EFFF),
      };
      return;
    }

    final enfermedadCount = <String, int>{};
    
    // Mapeo de palabras clave a categorías de enfermedades (expandido)
    final Map<String, String> categoriasEnfermedad = {
      'piel': 'Problemas de Piel',
      'dermatitis': 'Problemas de Piel',
      'alopecia': 'Problemas de Piel',
      'sarna': 'Problemas de Piel',
      'prurito': 'Problemas de Piel',
      'picazón': 'Problemas de Piel',
      'digestivo': 'Problemas Digestivos',
      'gastritis': 'Problemas Digestivos',
      'diarrea': 'Problemas Digestivos',
      'estreñimiento': 'Problemas Digestivos',
      'vómito': 'Problemas Digestivos',
      'gastroenteritis': 'Problemas Digestivos',
      'pancreatitis': 'Problemas Digestivos',
      'alergia': 'Alergias',
      'alérgico': 'Alergias',
      'intolerancia': 'Alergias',
      'respiratorio': 'Problemas Respiratorios',
      'tos': 'Problemas Respiratorios',
      'asma': 'Problemas Respiratorios',
      'neumonía': 'Problemas Respiratorios',
      'bronquitis': 'Problemas Respiratorios',
      'dental': 'Problemas Dentales',
      'caries': 'Problemas Dentales',
      'gingivitis': 'Problemas Dentales',
      'sarro': 'Problemas Dentales',
      'articular': 'Problemas Articulares',
      'artritis': 'Problemas Articulares',
      'displasia': 'Problemas Articulares',
      'cojera': 'Problemas Articulares',
      'oftalmológico': 'Problemas Oculares',
      'conjuntivitis': 'Problemas Oculares',
      'cataratas': 'Problemas Oculares',
      'queratitis': 'Problemas Oculares',
      'infección': 'Infecciones',
      'inflamación': 'Inflamación',
      'obesidad': 'Problemas Metabólicos',
      'diabetes': 'Problemas Metabólicos',
      'hipotiroidismo': 'Problemas Metabólicos',
    };

    // Contar diagnósticos por categoría
    for (var historial in historiales) {
      final diagnostico = historial.diagnostico.toLowerCase();
      
      // Buscar categoría correspondiente
      String categoria = 'Otros';
      for (var palabra in categoriasEnfermedad.keys) {
        if (diagnostico.contains(palabra)) {
          categoria = categoriasEnfermedad[palabra]!;
          break;
        }
      }
      
      enfermedadCount[categoria] = (enfermedadCount[categoria] ?? 0) + 1;
    }

    // Convertir a porcentajes y ordenar por mayor a menor
    final total = enfermedadCount.values.fold<int>(0, (sum, count) => sum + count);
    _enfermedadesComunes = {};
    
    // Ordenar por frecuencia (descendente) y tomar las top 5
    final sorted = enfermedadCount.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    for (var entry in sorted.take(5)) {
      _enfermedadesComunes[entry.key] = entry.value / total;
    }

    // Asignar colores según categoría
    final coloresDisponibles = {
      'Problemas de Piel': const Color(0xFFFFDDC1),
      'Problemas Digestivos': const Color(0xFFC1FFD7),
      'Alergias': const Color(0xFFD1C1FF),
      'Problemas Respiratorios': const Color(0xFFFFC1E3),
      'Problemas Dentales': const Color(0xFFC1EFFF),
      'Problemas Articulares': const Color(0xFFFFE3C1),
      'Problemas Oculares': const Color(0xFFC1E3FF),
      'Infecciones': const Color(0xFFFFB3C1),
      'Inflamación': const Color(0xFFFFCDD2),
      'Problemas Metabólicos': const Color(0xFFF0F4C3),
      'Otros': const Color(0xFFE0E0E0),
    };

    _enfermedadesColores = {};
    _enfermedadesComunes.forEach((enfermedad, _) {
      _enfermedadesColores[enfermedad] =
          coloresDisponibles[enfermedad] ?? const Color(0xFFC1EFFF);
    });
    
    print('Estadísticas cargadas - Enfermedades: $_enfermedadesComunes');
  }
}
