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

  /// Cargar citas del día actual
  Future<void> loadCitasDelDia() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final todasCitas = await _apiService.getCitas();
      final hoy = DateTime.now();
      _citas = todasCitas.where((c) {
        return c.fechaHora.year == hoy.year &&
            c.fechaHora.month == hoy.month &&
            c.fechaHora.day == hoy.day;
      }).toList();
    } catch (e) {
      _errorMessage = e.toString();
      print('Error al cargar citas del día: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
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
