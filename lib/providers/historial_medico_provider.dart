import 'package:flutter/material.dart';
import 'package:vet_smart_ids/models/historial_medico.dart';
import 'package:vet_smart_ids/services/api_service.dart';

class HistorialMedicoProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<HistorialMedico> _historiales = [];
  HistorialMedico? _historialSeleccionado;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<HistorialMedico> get historiales => _historiales;
  HistorialMedico? get historialSeleccionado => _historialSeleccionado;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Cargar todos los historiales médicos
  Future<void> loadHistoriales() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _historiales = await _apiService.getHistorialesMedicos();
    } catch (e) {
      _errorMessage = e.toString();
      print('Error al cargar historiales: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Cargar historiales de una mascota específica
  Future<void> loadHistorialesByMascota(int mascotaId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final todosHistoriales = await _apiService.getHistorialesMedicos();
      _historiales =
          todosHistoriales.where((h) => h.mascotaId == mascotaId).toList();
    } catch (e) {
      _errorMessage = e.toString();
      print('Error al cargar historiales de la mascota: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Cargar historiales de múltiples mascotas
  Future<void> loadHistorialesByMascotas(List<int> mascotaIds) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final todosHistoriales = await _apiService.getHistorialesMedicos();
      _historiales = todosHistoriales
          .where((h) => mascotaIds.contains(h.mascotaId))
          .toList();
    } catch (e) {
      _errorMessage = e.toString();
      print('Error al cargar historiales de las mascotas: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Cargar un historial por ID
  Future<void> loadHistorialById(int id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _historialSeleccionado = await _apiService.getHistorialMedicoById(id);
    } catch (e) {
      _errorMessage = e.toString();
      print('Error al cargar historial: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Crear un nuevo historial médico
  Future<bool> createHistorial(HistorialMedico historial) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _apiService.createHistorialMedico(historial);
      await loadHistoriales(); // Recargar la lista
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      print('Error al crear historial: $e');
      return false;
    }
  }

  /// Actualizar un historial médico
  Future<bool> updateHistorial(int id, HistorialMedico historial) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _apiService.updateHistorialMedico(id, historial);
      await loadHistoriales(); // Recargar la lista
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      print('Error al actualizar historial: $e');
      return false;
    }
  }

  /// Eliminar un historial médico
  Future<bool> deleteHistorial(int id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _apiService.deleteHistorialMedico(id);
      await loadHistoriales(); // Recargar la lista
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      print('Error al eliminar historial: $e');
      return false;
    }
  }
}
