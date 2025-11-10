import 'package:flutter/material.dart';
import 'package:vet_smart_ids/models/cita.dart';
import 'package:vet_smart_ids/services/api_service.dart';

class CitaProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Cita> _citas = [];
  Cita? _citaSeleccionada;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<Cita> get citas => _citas;
  Cita? get citaSeleccionada => _citaSeleccionada;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Cargar todas las citas
  Future<void> loadCitas() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _citas = await _apiService.getCitas();
    } catch (e) {
      _errorMessage = e.toString();
      print('Error al cargar citas: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Cargar citas de un usuario
  Future<void> loadCitasByUsuario(int usuarioId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final todasCitas = await _apiService.getCitas();
      _citas = todasCitas.where((c) => c.usuarioId == usuarioId).toList();
    } catch (e) {
      _errorMessage = e.toString();
      print('Error al cargar citas del usuario: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Cargar citas de un veterinario
  Future<void> loadCitasByVeterinario(int veterinarioId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final todasCitas = await _apiService.getCitas();
      _citas =
          todasCitas.where((c) => c.veterinarioId == veterinarioId).toList();
    } catch (e) {
      _errorMessage = e.toString();
      print('Error al cargar citas del veterinario: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Cargar citas desde hoy en adelante (hoy, mañana, pasado, etc.)
  Future<void> loadCitasDelDia() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final todasCitas = await _apiService.getCitas();
      final ahora = DateTime.now();
      // Fecha de hoy a las 00:00:00 para comparar
      final hoyInicio = DateTime(ahora.year, ahora.month, ahora.day);

      // Filtrar citas desde hoy en adelante
      _citas = todasCitas.where((c) {
        final fechaCita = DateTime(c.fechaHora.year, c.fechaHora.month, c.fechaHora.day);
        return fechaCita.isAfter(hoyInicio) || fechaCita.isAtSameMomentAs(hoyInicio);
      }).toList();

      // Ordenar por fecha (más cercanas primero)
      _citas.sort((a, b) => a.fechaHora.compareTo(b.fechaHora));
    } catch (e) {
      _errorMessage = e.toString();
      print('Error al cargar citas: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Obtener citas de esta semana (desde mañana hasta fin de semana)
  List<Cita> get citasProximasSemana {
    final ahora = DateTime.now();
    final manana = DateTime(ahora.year, ahora.month, ahora.day).add(const Duration(days: 1));

    // Encontrar el domingo de esta semana
    final diasHastaDomingo = DateTime.sunday - ahora.weekday;
    final finSemana = DateTime(ahora.year, ahora.month, ahora.day)
        .add(Duration(days: diasHastaDomingo >= 0 ? diasHastaDomingo : diasHastaDomingo + 7));

    return _citas.where((c) {
      final fechaCita = DateTime(c.fechaHora.year, c.fechaHora.month, c.fechaHora.day);
      return (fechaCita.isAfter(manana) || fechaCita.isAtSameMomentAs(manana)) &&
             (fechaCita.isBefore(finSemana) || fechaCita.isAtSameMomentAs(finSemana));
    }).toList();
  }

  /// Cargar una cita por ID
  Future<void> loadCitaById(int id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _citaSeleccionada = await _apiService.getCitaById(id);
    } catch (e) {
      _errorMessage = e.toString();
      print('Error al cargar cita: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Crear una nueva cita
  Future<bool> createCita(Cita cita) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _apiService.createCita(cita);
      await loadCitas(); // Recargar la lista
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      print('Error al crear cita: $e');
      return false;
    }
  }

  /// Actualizar una cita
  Future<bool> updateCita(int id, Cita cita) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _apiService.updateCita(id, cita);
      await loadCitas(); // Recargar la lista
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      print('Error al actualizar cita: $e');
      return false;
    }
  }

  /// Eliminar una cita
  Future<bool> deleteCita(int id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _apiService.deleteCita(id);
      await loadCitas(); // Recargar la lista
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      print('Error al eliminar cita: $e');
      return false;
    }
  }

  /// Seleccionar una cita
  void selectCita(Cita cita) {
    _citaSeleccionada = cita;
    notifyListeners();
  }

  /// Limpiar cita seleccionada
  void clearSelection() {
    _citaSeleccionada = null;
    notifyListeners();
  }
}
