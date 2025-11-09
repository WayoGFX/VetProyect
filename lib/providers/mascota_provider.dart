import 'package:flutter/material.dart';
import 'package:vet_smart_ids/models/mascota.dart';
import 'package:vet_smart_ids/services/api_service.dart';

class MascotaProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Mascota> _mascotas = [];
  Mascota? _mascotaSeleccionada;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<Mascota> get mascotas => _mascotas;
  Mascota? get mascotaSeleccionada => _mascotaSeleccionada;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Cargar todas las mascotas
  Future<void> loadMascotas() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _mascotas = await _apiService.getMascotas();
    } catch (e) {
      _errorMessage = e.toString();
      print('Error al cargar mascotas: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Cargar mascotas de un usuario específico
  Future<void> loadMascotasByUsuario(int usuarioId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final todasMascotas = await _apiService.getMascotas();
      _mascotas =
          todasMascotas.where((m) => m.usuarioId == usuarioId).toList();
    } catch (e) {
      _errorMessage = e.toString();
      print('Error al cargar mascotas del usuario: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Cargar una mascota por ID
  Future<void> loadMascotaById(int id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _mascotaSeleccionada = await _apiService.getMascotaById(id);
    } catch (e) {
      _errorMessage = e.toString();
      print('Error al cargar mascota: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Crear una nueva mascota
  Future<bool> createMascota(Mascota mascota) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _apiService.createMascota(mascota);
      await loadMascotas(); // Recargar la lista
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      print('Error al crear mascota: $e');
      return false;
    }
  }

  /// Actualizar una mascota
  Future<bool> updateMascota(int id, Mascota mascota) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _apiService.updateMascota(id, mascota);
      await loadMascotas(); // Recargar la lista
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      print('Error al actualizar mascota: $e');
      return false;
    }
  }

  /// Eliminar una mascota
  Future<bool> deleteMascota(int id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _apiService.deleteMascota(id);
      await loadMascotas(); // Recargar la lista
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      print('Error al eliminar mascota: $e');
      return false;
    }
  }

  /// Seleccionar una mascota
  void selectMascota(Mascota mascota) {
    _mascotaSeleccionada = mascota;
    notifyListeners();
  }

  /// Limpiar mascota seleccionada
  void clearSelection() {
    _mascotaSeleccionada = null;
    notifyListeners();
  }
}
